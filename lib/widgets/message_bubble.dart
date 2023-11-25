import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final bool isUserMessage;
  final String time;

  const MessageBubble({
    Key? key,
    required this.text,
    required this.isUserMessage,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.orange : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(text, style: TextStyle(color: Colors.black)),
            Text(time, style: TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
