import 'package:flutter/material.dart';
import 'package:hospital_managment_project/components/textformfield.dart';

class SymptomCheckerPage extends StatefulWidget {
  @override
  _SymptomCheckerPageState createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // Stores chat messages

  void _sendSymptomMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text,
          'isUser': true,
        });
        _messageController.clear();

        // Simulated response from symptom checker
        _messages.add({
          'text':
              'Please tell me more about your symptoms. Are you experiencing any pain?',
          'isUser': false,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symptom Checker'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - index - 1];
                return Align(
                  alignment: message['isUser']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message['isUser']
                          ? Colors.blue[200]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(message['text']),
                  ),
                );
              },
            ),
          ),
          _buildMessageInput(_sendSymptomMessage),
        ],
      ),
    );
  }

  Widget _buildMessageInput(VoidCallback onSend) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        children: [
          Expanded(
            child: CustomTextForm(
              hintText: 'Enter details about your condition...',
              hintStyle: const TextStyle(fontSize: 13),
              labelText: 'How Do You Feel?',
              icon: const Icon(
                Icons.medical_services,
                color: Colors.blue,
              ),
              mycontroller: _messageController,
              obscureText: false, // Not obscuring text here
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a symptom description';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
