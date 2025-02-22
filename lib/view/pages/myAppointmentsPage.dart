import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_managment_project/components/appointment_card.dart';

class MyAppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .where('patientId',
                  isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<Map<String, dynamic>> upcoming = [];
            List<Map<String, dynamic>> completed = [];
            List<Map<String, dynamic>> cancelled = [];

            for (var doc in snapshot.data!.docs) {
              var data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              if (data['status'] == "Upcoming") {
                upcoming.add(data);
              } else if (data['status'] == "Completed") {
                completed.add(data);
              } else if (data['status'] == "Cancelled") {
                cancelled.add(data);
              }
            }

            return TabBarView(
              children: [
                AppointmentListSection(appointments: upcoming),
                AppointmentListSection(appointments: completed),
                AppointmentListSection(appointments: cancelled),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AppointmentListSection extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;

  const AppointmentListSection({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const Center(child: Text("No appointments found."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        var data = appointments[index];

        return AppointmentCard(
          doctorName: data['doctorName'],
          specialty: data['specialty'],
          status: data['status'],
          time: data['time'],
          date: data['date'],
          photo: data['photo'],
          onCancel: () async {
            try {
              print("Attempting to cancel appointment with ID: ${data['id']}");

              await FirebaseFirestore.instance
                  .collection('appointments')
                  .doc(data['id']) // Get the correct document
                  .update(
                      {'status': 'Cancelled'}); // Change status to "Cancelled"

              print("Appointment moved to 'Cancelled'!");

              // 🔹 Show a success message
              Get.snackbar(
                "Success",
                "Appointment cancelled successfully!",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            } catch (e) {
              print("Error canceling appointment: $e");

              // 🔹 Show an error message
              Get.snackbar(
                "Error",
                "Failed to cancel appointment.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
        );
      },
    );
  }
}
