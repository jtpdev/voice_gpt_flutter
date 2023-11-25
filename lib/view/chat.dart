import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_app/services/chat_service.dart';
import 'package:flutter_chatgpt_app/services/date_service.dart';
import 'package:flutter_chatgpt_app/services/speech_service.dart';
import 'package:flutter_chatgpt_app/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SpeechService speechService = SpeechService();
  ChatGPTService chatService = ChatGPTService();
  String transcribedText = '';
  Timer? _speechTimer;
  bool _isloading = false;

  List<Map<String, dynamic>> messages = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    speechService.initialize(((isListening) {
      if (!isListening) {
        manageMessage();
      }
    }));
  }

  @override
  void dispose() {
    _speechTimer?.cancel();
    super.dispose();
  }

  Future<void> manageMessage() async {
    addUserMessage();

    if (transcribedText.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      var receivedMessage = await chatService.sendMessage(transcribedText);
      addChatMessage(receivedMessage);
      transcribedText = "";
      setState(() {
        _isloading = false;
        // toggleListening();
      });
      await speechService.speak(receivedMessage);
    }
  }

  void toggleListening() {
    if (speechService.isListening) {
      setState(() {
        speechService.stopListening();
      });
    } else {
      handleInactivity(10);
      setState(() {
        speechService.startListening((text) {
          setState(() {
            if (text.isNotEmpty) {
              transcribedText = text;
              handleInactivity(1);
            }
          });
        });
      });
    }
  }

  void handleInactivity(int seconds) {
    if (_speechTimer != null && _speechTimer!.isActive) {
      _speechTimer!.cancel();
    }
    _speechTimer = Timer(Duration(seconds: seconds), () {
      setState(() {
        speechService.stopListening();
      });
    });
  }

  void addUserMessage() {
    if (transcribedText.isNotEmpty) {
      setState(() {
        messages.add({
          'text': transcribedText,
          'isUserMessage': true,
          'time': DateService.format(DateTime.now())
        });
      });
    }
  }

  void addChatMessage(String chatMessage) {
    if (transcribedText.isNotEmpty) {
      setState(() {
        messages.add({
          'text': chatMessage,
          'isUserMessage': false,
          'time': DateService.format(DateTime.now())
        });
        transcribedText = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Interface'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                final message = messages.reversed.toList()[index];
                return MessageBubble(
                  text: message['text'],
                  isUserMessage: message['isUserMessage'],
                  time: message['time'],
                );
              },
              reverse: true,
            ),
          ),
          Visibility(
            visible: _isloading,
            child: const CircularProgressIndicator(),
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 64,
                  child: ElevatedButton.icon(
                    onPressed: toggleListening,
                    icon: Icon(
                        speechService.isListening ? Icons.mic : Icons.mic_none),
                    label: Text('Falar'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        speechService.isListening ? Colors.orange : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
