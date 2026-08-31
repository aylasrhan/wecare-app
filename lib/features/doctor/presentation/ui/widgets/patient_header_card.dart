import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientHeaderCard extends StatelessWidget {
  final Map<String, dynamic>? patientData;

  const PatientHeaderCard({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r), 
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 5.r), 
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35.r, 
            backgroundColor: Colors.blueGrey,
            child: Icon(
              Icons.person,
              size: 40.sp, 
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16.w), 
          Expanded( 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientData?['full_name'] ?? "غير معروف",
                  style: TextStyle(
                    fontSize: 20.sp, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h), 
                Text(
                  "العمر: ${patientData?['age'] ?? '-'} | الجنس: ${patientData?['sex'] ?? '-'}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14.sp), 
                ),
                SizedBox(height: 4.h),
                Text(
                  "زمرة الدم: ${patientData?['blood'] ?? 'غير متوفرة'}",
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp, 
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}