import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VisitClinicInfoCard extends StatelessWidget {
  final String clinicName;
  final String visitDate;

  const VisitClinicInfoCard({super.key, required this.clinicName, required this.visitDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E66).withOpacity(0.05),
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "العيادة: $clinicName",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: const Color(0xFF1E1E66)),
          ),
          SizedBox(height: 5.h),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14.sp, color: Colors.grey),
              SizedBox(width: 5.w),
              Text(visitDate, style: TextStyle(color: Colors.grey[700], fontSize: 14.sp)),
            ],
          ),
        ],
      ),
    );
  }
}