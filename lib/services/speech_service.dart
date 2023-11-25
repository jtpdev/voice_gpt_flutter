import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  FlutterTts flutterTts = FlutterTts();
  stt.SpeechToText speechToText = stt.SpeechToText();
  bool isListening = false;
  Function(bool isListening)? _onListeningChange;

  // Inicializa o Speech to Text
  Future<void> initialize(Function(bool isListening) onListeningChange) async {
    _onListeningChange = onListeningChange;
    flutterTts.setLanguage('en-US');
    bool available = await speechToText.initialize(
      onStatus: (status) {
        print('STT Status: $status');
      },
      onError: (errorNotification) => print('STT Error: $errorNotification'),
    );

    if (!available) {
      print('The user has denied the use of speech recognition.');
    }
  }

  // Começa a escutar
  void startListening(Function(String text) onResult) {
    if (!isListening) {
      speechToText.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        localeId: "en-US"
      );
      _changeListening(true);
    }
  }

  // Para de escutar
  void stopListening() {
    if (isListening) {
      speechToText.stop();
      _changeListening(false);
    }
  }

  void _changeListening(bool value) {
    isListening = value;
    if (_onListeningChange != null) {
      _onListeningChange!(value);
    }
  }

  // Fala um texto
  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }
}
