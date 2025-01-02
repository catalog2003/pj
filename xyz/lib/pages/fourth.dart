import 'package:flutter/material.dart';   
import 'dart:convert';   
import 'package:http/http.dart' as http;   

class FourthPage extends StatefulWidget {   
  final String diseaseName;   

  FourthPage({required this.diseaseName});   

  @override   
  _FourthPageState createState() => _FourthPageState();   
}   

class _FourthPageState extends State<FourthPage> {   
  TextEditingController _controller = TextEditingController();   
  List<Map<String, String>> _messages = [];   
  bool _isSending = false;   
  String detailedResponse = '';   

  Future<String> _getChatGptResponse(String prompt) async {   
    const String apiKey = //"2jubX6kMzzdjr8vpidh8tyuD4lAf6CjRwrrqMuhI7HxiiFv61eKyJQQJ99ALACYeBjFXJ3w3AAABACOGFlCt";   
    const String endpoint = "https://cropai.openai.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2024-08-01-preview";   

    Map<String, String> headers = {   
      "Content-Type": "application/json",   
      "api-key": apiKey,   
    };   

    Map<String, dynamic> body = {   
      "messages": [   
        {"role": "system", "content": "You are an agricultural expert providing detailed and actionable advice."},   
        {"role": "user", "content": prompt},   
      ],   
      "max_tokens": 1000,   
    };   

    try {   
      var response = await http.post(   
        Uri.parse(endpoint),   
        headers: headers,   
        body: json.encode(body),   
      );   

      if (response.statusCode == 200) {   
        var responseBody = json.decode(response.body);   
        return responseBody['choices'][0]['message']['content'];   
      } else {   
        throw Exception("Error: ${response.statusCode}");   
      }   
    } catch (e) {   
      throw Exception("Failed to fetch response: $e");   
    }   
  }   

  @override   
  void initState() {   
    super.initState();   
    if (widget.diseaseName.isNotEmpty) {   
      _fetchDetailedTreatmentInfo(widget.diseaseName);   
    }   
  }   

  Future<void> _fetchDetailedTreatmentInfo(String diseaseName) async {   
    String prompt = "Provide detailed treatment options for managing $diseaseName in crops.";   
    try {   
      setState(() {   
        _messages.add({"type": "user", "text": "Fetching detailed info for $diseaseName..."});   
      });   

      detailedResponse = await _getChatGptResponse(prompt);   

      setState(() {   
        _messages.add({"type": "bot", "text": detailedResponse});   
      });   
    } catch (e) {   
      setState(() {   
        _messages.add({"type": "bot", "text": "Error occurred while fetching detailed info."});   
      });   
    }   
  }   

  @override   
  Widget build(BuildContext context) {   
    return Scaffold(   
      appBar: AppBar(   
        title: Text('Fourth Screen'), // Permanent title for the app bar   
      ),   
      body: Column(   
        children: [   
          Expanded(   
            child: ListView.builder(   
              itemCount: _messages.length,   
              itemBuilder: (context, index) {   
                final message = _messages[index];   
                return Padding(   
                  padding: const EdgeInsets.all(8.0),   
                  child: Align(   
                    alignment: message['type'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,   
                    child: Container(   
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),   
                      decoration: BoxDecoration(   
                        color: message['type'] == 'user' ? Colors.blue : Colors.grey[300],   
                        borderRadius: BorderRadius.circular(8),   
                      ),   
                      child: Text(   
                        message['text'] ?? '',   
                        style: TextStyle(   
                          color: message['type'] == 'user' ? Colors.white : Colors.black,   
                          fontSize: 16,   
                        ),   
                      ),   
                    ),   
                  ),   
                );   
              },   
            ),   
          ),   
          Divider(),   
          Padding(   
            padding: const EdgeInsets.all(8.0),   
            child: Row(   
              children: [   
                Expanded(   
                  child: TextField(   
                    controller: _controller,   
                    decoration: InputDecoration(   
                      labelText: 'Ask a question...',   
                      border: OutlineInputBorder(),   
                    ),   
                    onSubmitted: (_) => _sendMessage(),   
                  ),   
                ),   
                SizedBox(width: 8),   
                ElevatedButton(   
                  onPressed: _sendMessage,   
                  child: Text('Send'),   
                ),   
              ],   
            ),   
          ),   
        ],   
      ),   
    );   
  }   

  void _sendMessage() async {   
    String userInput = _controller.text.trim();   
    if (userInput.isEmpty || _isSending) return;   

    setState(() {   
      _messages.add({"type": "user", "text": userInput});   
      _controller.clear();   
      _isSending = true;   
    });   

    try {   
      String aiResponse = await _getChatGptResponse(userInput);   
      setState(() {   
        _messages.add({"type": "bot", "text": aiResponse});   
        _isSending = false;   
      });   
    } catch (e) {   
      setState(() {   
        _messages.add({"type": "bot", "text": "Error occurred."});   
        _isSending = false;   
      });   
    }   
  }   
}   
