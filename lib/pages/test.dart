import 'package:chatacter/characters/llm.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> chatHistory = [
    {
      "role": "system",
      "content":
          "You are Napoleon Bonaparte. Respond to the user's questions and comments as Napoleon would, without explicitly stating that you are Napoleon."
    }
  ];
  final LLM _llm = LLM();

  void _sendMessage() async {
    final userMessage = _controller.text;
    setState(() {
      chatHistory.add({"role": "user", "content": userMessage});
    });

    _controller.clear();

    final responseContent = await _llm.sendPostRequest(chatHistory);
    setState(() {
      chatHistory.add({"role": "assistant", "content": responseContent});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interactive Chat Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                if (chatHistory[index]['role'] == 'system') {
                  return Container(); // Do not display the system message
                }
                String displayName = chatHistory[index]['role'] == 'assistant'
                    ? 'Napoleon'
                    : 'User';
                return ListTile(
                  title: Text(
                    '$displayName: ${chatHistory[index]['content']}',
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
