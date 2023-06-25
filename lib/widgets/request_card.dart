import 'dart:developer';

import 'package:flutter/material.dart';

class BloodRequestCard extends StatelessWidget {
  final String id;
  final String hospital;
  final int units;
  final String bloodGroup;
  final String name;
  // final String phone;

  const BloodRequestCard({
    Key? key,
    required this.id,
    required this.hospital,
    required this.units,
    required this.bloodGroup,
    required this.name,
    // required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.red[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hospital,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$units units of $bloodGroup blood needed for $name',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // call the phone number
                    log("Phone Icon Pressed, call the phone number");
                  },
                  icon: const Icon(Icons.call),
                  label: Text("Call $name"),
                  style: ElevatedButton.styleFrom(
                    surfaceTintColor: Colors.red[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
