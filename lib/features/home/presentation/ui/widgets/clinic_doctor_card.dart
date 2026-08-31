import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/home/presentation/ui/view/doctor_profile_screen.dart';
import 'package:wecare/model/doctor_model.dart';

class ClinicDoctorCard extends StatelessWidget {
  final Map doctorMap;
  final String clinicName;

  const ClinicDoctorCard({
    super.key,
    required this.doctorMap,
    required this.clinicName,
  });

  @override
  Widget build(BuildContext context) {
    Doctor doctor = Doctor.fromJson(Map<String, dynamic>.from(doctorMap));
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfileScreen(doctor: doctor),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h), 
        padding: EdgeInsets.all(20.w), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r, 
              offset: Offset(0, 5.h), 
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35.r, 
                  backgroundColor: Colors.blue.shade600,
                  child: Icon(Icons.person, size: 40.sp, color: Colors.white), 
                ),
                SizedBox(width: 15.w), 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.nameAr, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)), 
                      Text(clinicName, style: TextStyle(color: Colors.grey[600], fontSize: 14.sp)), 
                      SizedBox(height: 5.h), 
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.blue.shade300, size: 18.sp), 
                          SizedBox(width: 5.w), 
                          Text(
                            doctorMap['total_rate']?.toString() ?? "0.0", 
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp), 
                          ),            
                        ],
                      ),
                    ],
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