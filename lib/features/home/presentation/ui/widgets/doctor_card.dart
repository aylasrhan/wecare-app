
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/features/home/presentation/ui/view/doctor_profile_screen.dart';
import 'package:wecare/model/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final Map doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfileScreen(
              doctor: Doctor.fromJson(Map<String, dynamic>.from(doctor)),
            ),
          ),
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
              radius: 35.r, 
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person, size: 40.sp), 
            ),
            SizedBox(width: 15.w), 
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor['name_ar'] ?? "غير معروف",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), 
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    doctor['specialization_ar'] ?? "طبيب",
                    style: TextStyle(color: Colors.grey, fontSize: 14.sp), 
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Icon(Icons.chat_bubble_outline, color: const Color(0xFF1E1E66), size: 24.sp), 
          ],
        ),
      ),
    );
  }
}