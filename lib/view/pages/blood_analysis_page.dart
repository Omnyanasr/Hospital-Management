import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class BloodAnalysisPage extends StatefulWidget {
  @override
  _BloodAnalysisPageState createState() => _BloodAnalysisPageState();
}

class _BloodAnalysisPageState extends State<BloodAnalysisPage> {
  Map<int, Timer?> debounceTimers = {};
  DateTime? selectedDate; // <-- New field for the test date

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
          selection['value'].toString().isEmpty ||
          selectedDate == null) {
        return; // Don't save incomplete rows
      }

      final Map<String, dynamic> data = {
        'test_name': selection['selected'],
        'value': selection['value'],
        'user_id': user!.uid,
        'date': Timestamp.fromDate(selectedDate!), // Save selected date
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

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> deleteDropdown(int index) async {
    // your existing delete function
  }

  void onAnalyze() {
    print('Analyze clicked');
  }

  void onMonitor() {
    print('Monitor clicked');
  }

  void onPredict() {
    print('Predict clicked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blood Test')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => selectDate(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedDate == null
                            ? 'Select Test Date'
                            : '${selectedDate!.toLocal()}'.split(' ')[0],
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
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
                            hint: Text('Test', style: TextStyle(fontSize: 14)),
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
                                child:
                                    Text(item, style: TextStyle(fontSize: 12)),
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

                              debounceTimers[index]?.cancel();

                              debounceTimers[index] =
                                  Timer(Duration(milliseconds: 500), () {
                                saveOrUpdate(index);
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
            ),
          ],
        ),
      ),
    );
  }
}
