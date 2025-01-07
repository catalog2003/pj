import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

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
  bool _isTyping = false; // State to track if AI is typing

  @override
  void initState() {
    super.initState();
    if (widget.diseaseName.isNotEmpty) {
      _fetchDetailedTreatmentInfo(widget.diseaseName);
    }
  }

  Future<void> _fetchDetailedTreatmentInfo(String diseaseName) async {
    String prompt = "Provide detailed treatment options for managing $diseaseName in crops.";
    _sendMessageToAI(prompt);
  }

  Future<void> _sendMessageToAI(String userInput) async {
    setState(() {
      _messages.add({"type": "user", "text": userInput});
      _isSending = true;
      _isTyping = true; // Set to true when AI is typing
    });

    const String apiKey = "2jubX6kMzzdjr8vpidh8tyuD4lAf6CjRwrrqMuhI7HxiiFv61eKyJQQJ99ALACYeBjFXJ3w3AAABACOGFlCt";
    const String endpoint = "https://cropai.openai.azure.com/openai/deployments/gpt-4o/chat/completions?api-version=2024-08-01-preview";

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "api-key": apiKey,
    };

    Map<String, dynamic> body = {
      "messages": [
        {"role": "system", "content": "You are an agricultural expert providing detailed and actionable advice."},
        {"role": "user", "content": userInput},
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
        String botReply = responseBody['choices'][0]['message']['content'];
        _simulateTypingEffect(botReply);
      } else {
        setState(() {
          _messages.add({"type": "bot", "text": "Error: ${response.statusCode}"});
          _isSending = false;
          _isTyping = false; // Stop typing indicator on error
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"type": "bot", "text": "Failed to fetch response: $e"});
        _isSending = false;
        _isTyping = false; // Stop typing indicator on error
      });
    }
  }

  Future<void> _simulateTypingEffect(String fullText) async {
    String currentText = "";
    List<String> words = fullText.split(" ");

    for (String word in words) {
      await Future.delayed(Duration(milliseconds: 50)); // Simulate typing delay
      setState(() {
        currentText += "$word ";
        if (_messages.isNotEmpty && _messages.last['type'] == 'bot') {
          _messages.last['text'] = currentText.trim();
        } else {
          _messages.add({"type": "bot", "text": currentText.trim()});
        }
      });
    }

    setState(() {
      _isSending = false;
      _isTyping = false; // Stop typing indicator when done
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "AI",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          // Chat messages section
          Expanded(
            child: SingleChildScrollView(
              reverse: true, // Scroll to the bottom on new messages
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chat messages
                    for (var message in _messages)
                      Align(
                        alignment: message['type'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: message['type'] == 'user' ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(message['type'] == 'user' ? 12 : 0),
                              topRight: Radius.circular(message['type'] == 'user' ? 0 : 12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            message['text'] ?? '',
                            style: TextStyle(
                              color: message['type'] == 'user' ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    // Show "Typing..." indicator if AI is typing
                    if (_isTyping)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.chat_bubble, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              "AI is typing...",
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Input area
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask a question...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessageToAI(_controller.text.trim()),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    String userInput = _controller.text.trim();
                    if (userInput.isNotEmpty) {
                      _sendMessageToAI(userInput);
                      _controller.clear(); // Clear the text field after sending
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
