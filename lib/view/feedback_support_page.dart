import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital_managment_project/components/textformfield.dart'; // Import your CustomTextForm widget

class FeedbackSupportPage extends StatefulWidget {
  @override
  _FeedbackSupportPageState createState() => _FeedbackSupportPageState();
}

class _FeedbackSupportPageState extends State<FeedbackSupportPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 3; // Default rating
  String? _selectedCategory; // For feedback categories

  final List<String> _feedbackCategories = [
    'App Feedback',
    'Technical Issue',
    'Feature Request',
    'Service Complaint'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('feedback').add({
          'name': _nameController.text,
          'email': _emailController.text,
          'category': _selectedCategory,
          'rating': _rating,
          'feedback': _feedbackController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thank you for your feedback!')),
        );

        _nameController.clear();
        _emailController.clear();
        _feedbackController.clear();
        setState(() {
          _rating = 3;
          _selectedCategory = null;
        });
      } catch (e) {
        print('Error submitting feedback: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit feedback. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextForm(
                mycontroller: _nameController,
                hintText: 'Enter your name',
                labelText: 'Name',
                icon: const Icon(Icons.person),
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomTextForm(
                mycontroller: _emailController,
                hintText: 'Enter your email',
                labelText: 'Email',
                icon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Feedback Category Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Feedback Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.category),
                ),
                value: _selectedCategory,
                items: _feedbackCategories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 15),

              // Rating Slider
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  Rate Your Experience',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _rating,
                    onChanged: (newRating) {
                      setState(() {
                        _rating = newRating;
                      });
                    },
                    divisions: 4,
                    label: _rating.round().toString(),
                    min: 1,
                    max: 5,
                    activeColor: Color.fromARGB(255, 101, 154,
                        247), // Change the color of the active part of the slider
                    inactiveColor: Colors
                        .grey, // Change the color of the inactive part of the slider
                  ),
                ],
              ),
              const SizedBox(height: 15),

              CustomTextForm(
                mycontroller: _feedbackController,
                hintText: 'Enter your feedback',
                labelText: 'Feedback',
                icon: const Icon(Icons.feedback),
                maxLines: 4,
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  onPressed: _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
