import 'package:flutter/material.dart';

class BloodAnalysisPage extends StatefulWidget {
  @override
  _BloodAnalysisPageState createState() => _BloodAnalysisPageState();
}

class _BloodAnalysisPageState extends State<BloodAnalysisPage> {
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
    {'selected': null, 'value': ''}
  ];

  void addDropdown() {
    setState(() {
      selections.add({'selected': null, 'value': ''});
    });
  }

  void deleteDropdown(int index) {
    setState(() {
      selections.removeAt(index);
    });
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

  OutlineInputBorder roundedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey),
  );

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
