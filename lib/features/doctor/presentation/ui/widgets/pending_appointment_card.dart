import 'package:flutter/material.dart';
import 'package:wecare/core/services/auth_service.dart';

class PendingAppointmentCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onActionCompleted; // 👈 هذا المتغير لتحديث الشاشة الأم بعد القبول أو الرفض

  const PendingAppointmentCard({
    super.key,
    required this.item,
    required this.onActionCompleted,
  });

  @override
  Widget build(BuildContext context) {
    // 1. نأخذ الاسم أو الرقم فقط
    final patientNameOrId = item['patient'] != null && item['patient']['name'] != null
        ? '${item['patient']['name']}'
        : 'رقم ${item['appointment_for'] ?? 'غير معروف'}';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent,
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
              subtitle: const Text("طلب استشارة إلكترونية"),
              trailing: const Text(
                "قيد الانتظار",
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(item['appointment_date'] ?? '')
                ]),
                Row(children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(item['time'] ?? '')
                ]),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      bool success = await AuthService().acceptAppointment(item['id']);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم قبول الموعد بنجاح')),
                        );
                        onActionCompleted(); // 👈 استدعاء تحديث الشاشة
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فشل قبول الموعد، حاول مرة أخرى')),
                        );
                      }
                    },
                    child: const Text("قبول", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                    onPressed: () async {
                      bool success = await AuthService().rejectAppointment(item['id']);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم رفض الموعد وإلغاؤه')),
                        );
                        onActionCompleted(); // 👈 استدعاء تحديث الشاشة
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فشل رفض الموعد، حاول مرة أخرى')),
                        );
                      }
                    },
                    child: const Text("رفض"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // كود تعديل الموعد
                },
                child: const Text("تعديل الوقت (اقتراح موعد بديل)", style: TextStyle(color: Colors.grey)),
              ),
            )
          ],
        ),
      ),
    );
  }
}