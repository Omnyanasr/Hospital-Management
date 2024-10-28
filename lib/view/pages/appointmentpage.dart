import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  // Sample data for available dates
  final List<String> availableDates = [
    "October \n29",
    "October \n30",
    "October \n31",
    "November \n1",
  ];

  // Sample data for available time slots
  final List<String> availableTimes = [
    "8:00 AM",
    "9:00 AM",
    "10:00 AM",
    "11:00 AM",
    "1:00 PM",
  ];

  int selectedDateIndex = 0; // Default selected date index
  int selectedTimeIndex = 0; // Default selected time index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor information
            Row(
              children: [
                Container(
                  width: 140,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), // Square shape with rounded corners
                    image: DecorationImage(
                      image: AssetImage('assets/doctor.png'), // Replace with your image asset
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Dr. Irum Khan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("Surgical Superintendent"),
                    Text("5k Patients | 5 Years Experience"),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Biography", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Doctor's biography and background \ninformation goes here."),
            SizedBox(height: 30),
            // Date selection
            Text("Select Date", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availableDates.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDateIndex = index;
                      });
                    },
                    child: Container(
                      width: 80, // Fixed width for better alignment
                      padding: EdgeInsets.symmetric(vertical: 12),
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: selectedDateIndex == index
                            ? const Color.fromARGB(255, 101, 154, 247)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          availableDates[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: selectedDateIndex == index ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),
            // Time selection
            Text("Select Time", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20, // Horizontal spacing between buttons
              runSpacing: 10, // Vertical spacing between rows
              children: availableTimes
                  .asMap()
                  .entries
                  .map((entry) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTimeIndex = entry.key;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedTimeIndex == entry.key
                        ? const Color.fromARGB(255, 101, 154, 247)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: selectedTimeIndex == entry.key ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ))
                  .toList(),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    // Implement chat functionality
                    // For example: Get.toNamed('/chat', arguments: {'doctorId': '123'});
                  },
                  icon: Icon(Icons.chat),
                  iconSize: 30,
                  color: const Color.fromARGB(255, 101, 154, 247),
                ),
                SizedBox(width: 20),
                // Book Appointment Button
                ElevatedButton(
                  onPressed: () {
                    // Implement booking logic, e.g., send selectedDate and selectedTime to the server
                  },
                  child: Text("Book an Appointment"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
