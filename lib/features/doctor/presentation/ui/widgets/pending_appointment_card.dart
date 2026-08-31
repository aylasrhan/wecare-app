
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/core/services/auth_service.dart';

class PendingAppointmentCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onActionCompleted; 

  const PendingAppointmentCard({
    super.key,
    required this.item,
    required this.onActionCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final patientNameOrId = item['patient'] != null && item['patient']['name'] != null
        ? '${item['patient']['name']}'
        : 'رقم ${item['appointment_for'] ?? 'غير معروف'}';

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16.h), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)), 
      child: Padding(
        padding: EdgeInsets.all(16.w), 
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 25.r, 
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white, size: 28.sp), 
              ),
              title: Text.rich(
                TextSpan(
                  text: 'المريض: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo', fontSize: 15.sp), 
                  children: [
                    TextSpan(
                      text: patientNameOrId,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp), 
                    ),
                  ],
                ),
              ),
              subtitle: Text("طلب استشارة إلكترونية", style: TextStyle(fontSize: 13.sp)), 
              trailing: Text(
                "قيد الانتظار",
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13.sp), 
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16.sp, color: Colors.blue), 
                    SizedBox(width: 8.w),
                    Text(item['appointment_date'] ?? '', style: TextStyle(fontSize: 14.sp)), 
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16.sp, color: Colors.blue), 
                    SizedBox(width: 8.w), 
                    Text(item['time'] ?? '', style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.h), 
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 10.h), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)), 
                    ),
                    onPressed: () async {
                      bool success = await AuthService().acceptAppointment(item['id']);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم قبول الموعد بنجاح')),
                        );
                        onActionCompleted(); 
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فشل قبول الموعد، حاول مرة أخرى')),
                        );
                      }
                    },
                    child: Text("قبول", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)), // 🔴 خط متجاوب
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red, 
                      side: const BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 10.h), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)), 
                    ),
                    onPressed: () async {
                      bool success = await AuthService().rejectAppointment(item['id']);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم رفض الموعد وإلغاؤه')),
                        );
                        onActionCompleted(); 
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فشل رفض الموعد، حاول مرة أخرى')),
                        );
                      }
                    },
                    child: Text("رفض", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)), 
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                },
                child: Text(
                  "تعديل الوقت (اقتراح موعد بديل)", 
                  style: TextStyle(color: Colors.grey, fontSize: 13.sp), 
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}