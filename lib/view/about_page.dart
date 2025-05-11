import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int? _expandedFeatureIndex;

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        "title": "Doctor Appointments",
        "description":
        "Users can book or cancel appointments with doctors and easily view available doctors through the app."
      },
      {
        "title": "Chatbot Symptom Analysis",
        "description":
        "An intelligent chatbot helps users by analyzing their symptoms and suggesting the suitable doctor. It also provides access to the list of available doctors."
      },
      {
        "title": "Blood Test Analysis",
        "description":
        "Users can input blood test values. The system checks if the values are normal or abnormal, suggests possible diseases, provides treatment guides, estimates time to return to normal, and recommends a retest time. It also offers health information and care guides."
      },
      {
        "title": "Monitoring & Prediction",
        "description":
        "The system monitors user health based on blood test inputs and predicts the next expected value to help in early detection and proactive care."
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
                'About MedAssist',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'MedAssist is a smart healthcare application designed to simplify and improve the patient experience. Our app offers convenient features for patients, doctors, and administrators. Here are the key features:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
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
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
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
                'MedAssist is brought to you by a dedicated team of innovators:',
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
