
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/features/doctor/presentation/ui/view/patient_profile_screen.dart';

class ConfirmedAppointmentCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const ConfirmedAppointmentCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final patientNameOrId = item['patient'] != null && item['patient']['name'] != null
        ? '${item['patient']['name']}'
        : 'رقم ${item['appointment_for'] ?? 'غير معروف'}';

    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 16.h), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r), 
        side: BorderSide(color: Colors.green.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w), 
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 25.r, 
                backgroundColor: Colors.green,
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
              subtitle: Text(
                "${item['appointment_date'] ?? ''} - ${item['time'] ?? ''}",
                style: TextStyle(fontSize: 13.sp),
              ),
            ),
            SizedBox(height: 8.h), 
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.blue,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 10.h), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r), 
                  ),
                ),
                icon: Icon(Icons.folder_shared, size: 20.sp), 
                label: Text(
                  "استعراض بيانات المريض",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold), 
                ),
                onPressed: () {
                  final int patientId = item['patient_id'] ?? item['appointment_for'] ?? 0;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientProfileScreen(
                        patientId: patientId,
                        visitId: item['id'],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}