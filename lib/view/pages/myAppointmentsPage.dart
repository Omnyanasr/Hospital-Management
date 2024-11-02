import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyAppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final doctorName = Get.arguments['doctorName'] ?? "Doctor";
    final specialty = Get.arguments['specialty'] ?? "Specialty";
    final time = Get.arguments['time'] ?? "Time";
    final date = Get.arguments['date'] ?? "Date";
    final photo = Get.arguments['photo'] ?? 'assets/default_photo.png';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Appointments"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Upcoming"),
              Tab(text: "Completed"),
              Tab(text: "Cancelled"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AppointmentListSection(
              doctorName: doctorName,
              specialty: specialty,
              time: time,
              date: date,
              status: "Upcoming",
              photo: photo,
            ),
            AppointmentListSection(
              doctorName: doctorName,
              specialty: specialty,
              time: time,
              date: date,
              status: "Completed",
              photo: photo,
            ),
            AppointmentListSection(
              doctorName: doctorName,
              specialty: specialty,
              time: time,
              date: date,
              status: "Cancelled",
              photo: photo,
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentListSection extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String time;
  final String date;
  final String status;
  final String photo;

  AppointmentListSection({
    required this.doctorName,
    required this.specialty,
    required this.time,
    required this.date,
    required this.status,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        AppointmentCard(
          doctorName: doctorName,
          specialty: specialty,
          status: status,
          time: time,
          date: date,
          photo: photo,
        ),
      ],
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String status;
  final String time;
  final String date;
  final String photo;

  AppointmentCard({
    required this.doctorName,
    required this.specialty,
    required this.status,
    required this.time,
    required this.date,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(photo),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctorName, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(specialty),
                  Text("Date: $date"),
                  Text("Time: $time"),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    color: status == "Cancelled" ? Colors.red : (status == "Completed" ? Colors.green : Colors.blue),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (status == "Upcoming")
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.2), // Slightly colored background
                      ),
                      onPressed: () {},
                      child: Text("Reschedule", style: TextStyle(color: Colors.blue)), // Text color
                    ),
                  ),
                if (status == "Upcoming")
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.2), // Slightly colored background
                      ),
                      onPressed: () {},
                      child: Text("Cancel", style: TextStyle(color: Colors.red)), // Text color
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
