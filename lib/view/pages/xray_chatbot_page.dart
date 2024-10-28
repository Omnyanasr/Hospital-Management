import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class XRayAnalyzerPage extends StatefulWidget {
  @override
  _XRayAnalyzerPageState createState() => _XRayAnalyzerPageState();
}

class _XRayAnalyzerPageState extends State<XRayAnalyzerPage> {
  final List<Map<String, dynamic>> _messages = [];
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _messages.add({
          'image': _image,
          'isUser': true,
        });

        // Simulated bot response
        _messages.add({
          'text': 'Analyzing X-ray... Please wait a moment.',
          'isUser': false,
        });

        // After a delay, show result
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _messages.add({
              'text':
                  'Analysis complete: No significant issues detected. However, consult your doctor for a full evaluation.',
              'isUser': false,
            });
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('X-ray Analyzer'),
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
                    child: message['image'] != null
                        ? Image.file(File(message['image'].path))
                        : Text(message['text']),
                  ),
                );
              },
            ),
          ),
          _buildImageInput(),
        ],
      ),
    );
  }

  Widget _buildImageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: _pickImage,
          ),
          Text('Upload X-ray for analysis'),
        ],
      ),
    );
  }
}
