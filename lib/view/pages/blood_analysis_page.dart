import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';


class BloodAnalysisPage extends StatefulWidget {
  @override
  _BloodAnalysisPageState createState() => _BloodAnalysisPageState();
}

class _BloodAnalysisPageState extends State<BloodAnalysisPage> {
  Map<int, Timer?> debounceTimers = {};

  final List<String> dropdownItems = [
    'White Cell Count',
    'Lymphocytes',
    'Lymphocytes %',
    'Monocytes',
    'Monocytes %',
    'Neutrophils',
    'Neutrophils %',
    'Eosinophils',
    'Eosinophils %',
    'Basophils',
    'Basophils %',
    'Red Cell Count',
    'Hemoglobin',
    'Hematocrit (PCV)',
    'MCV',
    'MCH',
    'MCHC',
    'RDW',
    'Platelet Count',
    'MPV',
  ];

  List<Map<String, dynamic>> selections = [
    {'selected': null, 'value': '', 'docId': null}
  ];

  OutlineInputBorder roundedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey),
  );

  final user = FirebaseAuth.instance.currentUser;

  void addDropdown() {
    setState(() {
      selections.add({'selected': null, 'value': '', 'docId': null});
    });
  }

  Future<void> saveOrUpdate(int index) async {
    try {
      if (user == null) return;

      final selection = selections[index];

      if (selection['selected'] == null ||
          selection['value'].toString().isEmpty) {
        return; // Don't save incomplete rows
      }

      final Map<String, dynamic> data = {
        'test_name': selection['selected'],
        'value': selection['value'],
        'user_id': user!.uid,
        'date': FieldValue.serverTimestamp(),
        'unit': '/cmm',
      };

      if (selection['docId'] == null) {
        // Create new document
        DocumentReference docRef = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('test_results')
            .add(data);

        setState(() {
          selections[index]['docId'] = docRef.id;
        });
      } else {
        // Update existing document
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('test_results')
            .doc(selection['docId'])
            .update(data);
      }
    } catch (e) {
      print('Save or update failed: $e');
    }
  }
  Future<void> generateReport(String userId) async {
    final url = Uri.parse('https://9a24-34-125-158-142.ngrok-free.app/generate-report');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'user_id': userId}),
    );

    if (response.statusCode == 200) {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/Medical_Report.pdf');
      await file.writeAsBytes(response.bodyBytes);
      print("PDF downloaded to: ${file.path}");
      OpenFile.open(file.path);
    } else {
      print("Error generating report: ${response.statusCode}");
    }
  }

  Future<void> fetchMonitoringTrends(String userId) async {
    final String url = 'https://1912-34-125-158-142.ngrok-free.app/monitor';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final trends = data['trends'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Monitoring Trends'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: trends.length,
                itemBuilder: (context, index) {
                  final trend = trends[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Test: ${trend["Test Name"]}\n'
                          'Trend: ${trend["Trend Status"]}\n'
                          'Current: ${trend["Current Value"]}\n'
                          '${trend.containsKey("Past Values") ? "Past: ${trend["Past Values"]}\n" : ""}'
                          '${trend.containsKey("Monitoring Priority") ? "Priority: ${trend["Monitoring Priority"]}" : ""}',
                    ),
                  );
                },
              ),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
          ),
        );
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> fetchPredictions(String userId) async {
    final String url = 'https://d678-34-125-158-142.ngrok-free.app/predict-next';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final predictions = data['predictions'];

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Predictions'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  final test = predictions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Test: ${test["Test Name"]}\n'
                          '${test.containsKey("Predicted Value (Next 30 Days)") ? "Value: ${test["Predicted Value (Next 30 Days)"]}\nDate: ${test["Prediction Date"]}" : test["Message"]}',
                    ),
                  );
                },
              ),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
          ),
        );
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> deleteDropdown(int index) async {
    try {
      if (user == null) return;

      final docId = selections[index]['docId'];

      if (docId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('test_results')
            .doc(docId)
            .delete();
      }

      setState(() {
        selections.removeAt(index);
      });
    } catch (e) {
      print('Delete failed: $e');
    }
  }

  void onAnalyze() {
    if (user != null) {
      generateReport(user!.uid);
    }
  }

  void onMonitor() {
    if (user != null) {
      fetchMonitoringTrends(user!.uid);
    }
  }

  void onPredict() {
    if (user != null) {
      fetchPredictions(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blood Test')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: selections.length,
                itemBuilder: (context, index) {
                  bool isLast = index == selections.length - 1;
                  bool canDelete = selections.length > 1;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selections[index]['selected'],
                            hint: Text(
                              'Test',
                              style: TextStyle(fontSize: 14),
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              border: roundedBorder,
                              enabledBorder: roundedBorder,
                              focusedBorder: roundedBorder,
                            ),
                            items: dropdownItems.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selections[index]['selected'] = value;
                              });
                              saveOrUpdate(index);
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Enter value',
                              border: roundedBorder,
                              enabledBorder: roundedBorder,
                              focusedBorder: roundedBorder,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                            ),
                            onChanged: (val) {
                              selections[index]['value'] = val;

                              debounceTimers[index]
                                  ?.cancel(); // Cancel previous timer if any

                              debounceTimers[index] =
                                  Timer(Duration(milliseconds: 500), () {
                                    saveOrUpdate(index); // Save after 500ms pause
                                  });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        if (canDelete)
                          IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => deleteDropdown(index),
                            tooltip: 'Delete this test',
                            color: Colors.red,
                          )
                        else if (isLast)
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: addDropdown,
                            tooltip: 'Add another test',
                            color: Theme.of(context).primaryColor,
                          ),
                        if (isLast && canDelete)
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: addDropdown,
                            tooltip: 'Add another test',
                            color: Theme.of(context).primaryColor,
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAnalyze,
                    child: Text('Analyze'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onMonitor,
                    child: Text('Monitor'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onPredict,
                    child: Text('Predict'),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}