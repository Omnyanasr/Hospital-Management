import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  // Track the expanded feature
  int? _expandedFeatureIndex;

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        "title": "Doctor Appointments",
        "description":
        "Users can book appointments with doctors of their choice, ensuring hassle-free scheduling."
      },
      {
        "title": "Chatbot Symptom Analysis",
        "description":
        "Our intelligent chatbot allows users to describe their symptoms. Based on the input, the chatbot recommends the appropriate doctor."
      },
      {
        "title": "Radiology Image Analysis",
        "description":
        "Patients can upload radiology images to the system, which detects cancer (if present), identifies its type (e.g., benign or malignant), and highlights the affected area in the image."
      },
      {
        "title": "Follow-Up Recommendation System",
        "description":
        "Based on diagnoses, our app provides actionable follow-up suggestions, such as scheduling biopsies, referring to specialists, or implementing monitoring protocols. It also offers lifestyle recommendations and tracks patient health over time."
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 150,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'About Care360',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We are revolutionizing healthcare with our mobile Hospital Management System. Our app is designed to provide seamless, efficient, and user-friendly healthcare services to patients. Here are the key features of our app:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Features list
              ...features.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> feature = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _expandedFeatureIndex =
                          _expandedFeatureIndex == index ? null : index;
                        });
                      },
                      child: Text(
                        feature["title"]!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue, // Blue text for clickable effect
                          decoration: TextDecoration.underline, // Underline effect
                        ),
                      ),
                    ),
                    if (_expandedFeatureIndex == index)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          feature["description"]!,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Our mission is to bring advanced healthcare to your fingertips, ensuring timely diagnoses, effective treatments, and a better quality of life for all patients.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              const Text(
                'About the Creators',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Care360 is brought to you by a dedicated team of innovators:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 5),
              const Text(
                'Omnya Nasr, Mariam Ali, Nadeen Elsayed, Huda Ahmed, and Salma Afifi.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
