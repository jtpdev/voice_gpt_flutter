import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatGPTService {
  final apiKey = dotenv.env['API_KEY'];
  final String baseUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage(String message) async {

    var response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            "role": "user",
            "content": message
          }
        ],
        "max_tokens": 50
      }),
    );


    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Falha ao enviar mensagem: ${response.body}');
    }
  }
}
