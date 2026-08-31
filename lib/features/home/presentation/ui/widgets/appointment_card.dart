
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/features/home/presentation/ui/view/appointments_page.dart';
import 'package:wecare/features/home/presentation/ui/view/video_call_screen.dart';

class AppointmentCard extends StatelessWidget {
  final dynamic appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    print("APPOINTMENT DATA: $appointment");

    String doctorName = "طبيب غير محدد";
    if (appointment['doctor'] != null) {
      doctorName = appointment['doctor']['name_ar'] ?? appointment['doctor']['name'] ?? appointment['doctor']['name_en'] ?? "طبيب غير محدد";
    } else if (appointment['doctor_info'] != null) {
      doctorName = appointment['doctor_info']['name_ar'] ?? "طبيب غير محدد";
    } else if (appointment['doctor_name'] != null) {
      doctorName = appointment['doctor_name'];
    } else if (appointment['name_ar'] != null) {
      doctorName = appointment['name_ar'];
    }

    String appointmentDate = appointment['appointment_date']?.toString() ?? "";
    String appointmentTime = appointment['time']?.toString() ?? 
                            appointment['available_slot']?.toString() ?? 
                            appointment['available_time']?.toString() ?? "";
    
    String fullDateTime = "$appointmentDate  $appointmentTime".trim();
    if (fullDateTime.isEmpty) {
      fullDateTime = "موعد قادم";
    }

    int status = appointment['status'] ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentsPage()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(15.w), 
        margin: EdgeInsets.symmetric(vertical: 8.h), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r), 
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10.r), 
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundColor: const Color(0xFFE8EAF6),
              child: Icon(Icons.person, color: const Color(0xFF1E1E66), size: 24.sp), 
            ),
            SizedBox(width: 15.w), 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp), // 🔴 خط متجاوب
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14.sp, color: const Color(0xFF1E1E66)), // 🔴 أيقونة متجاوبة
                      SizedBox(width: 6.w),  
                      Expanded(
                        child: Text(
                          fullDateTime,
                          style: TextStyle(color: Colors.grey, fontSize: 13.sp, fontWeight: FontWeight.w500), // 🔴 خط متجاوب
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            if (status == 1) ...[
              IconButton(
                icon: Icon(Icons.videocam, color: Colors.blueAccent, size: 24.sp), // 🔴 أيقونة متجاوبة
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallScreen(
                        appointmentId: appointment['id'].toString(),
                        userName: "مريض", 
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 5.w), 
            ],

            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h), 
              decoration: BoxDecoration(
                color: status == 0 ? Colors.orange.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12.r), 
                border: Border.all(
                  color: status == 0 ? Colors.orange.shade200 : Colors.green.shade200,
                ),
              ),
              child: Text(
                status == 0 ? "قيد الانتظار" : "مؤكد",
                style: TextStyle(
                  color: status == 0 ? Colors.orange : Colors.green,
                  fontSize: 12.sp, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}