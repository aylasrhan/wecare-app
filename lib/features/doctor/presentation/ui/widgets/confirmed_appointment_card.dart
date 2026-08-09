import 'package:flutter/material.dart';

class ConfirmedAppointmentCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ConfirmedAppointmentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // 1. نأخذ الاسم أو الرقم فقط
    final patientNameOrId = item['patient'] != null && item['patient']['name'] != null
        ? '${item['patient']['name']}'
        : 'رقم ${item['appointment_for'] ?? 'غير معروف'}';

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.green.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.green,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text.rich(
                TextSpan(
                  text: 'المريض: ',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                  children: [
                    TextSpan(
                      text: patientNameOrId,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              subtitle: Text("${item['appointment_date'] ?? ''} - ${item['time'] ?? ''}"),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.blue,
                  elevation: 0,
                ),
                icon: const Icon(Icons.folder_shared),
                label: const Text("استعراض بيانات المريض"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('عرض ملف المريض رقم: ${item['appointment_for']}')),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}