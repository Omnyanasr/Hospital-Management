import 'package:flutter/material.dart';
import 'package:hospital_managment_project/components/treatment_card.dart';

class TreatmentRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TreatmentCard(name: "Ibuprofen", dosage: "1 pill / day", time: "8:00"),
        TreatmentCard(name: "Magnequin", dosage: "2 pills / day", time: "8:00"),
        TreatmentCard(
            name: "Rotalphen", dosage: "1 prick / day", time: "16:00"),
      ],
    );
  }
}
