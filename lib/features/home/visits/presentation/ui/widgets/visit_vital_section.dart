import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class VisitVitalsSection extends StatelessWidget {
  final Map vitals;

  const VisitVitalsSection({super.key, required this.vitals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("العلامات الحيوية للمريض:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16.sp)),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("الوزن: ${vitals['weight'] ?? '-'} كغ", style: TextStyle(fontSize: 14.sp)),
                  Text("الطول: ${vitals['height'] ?? '-'} سم", style: TextStyle(fontSize: 14.sp)),
                ],
              ),
              Divider(height: 15.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("النبض: ${vitals['pulse'] ?? '-'} نبضة/د", style: TextStyle(fontSize: 14.sp)),
                  Text("الضغط: ${vitals['systolic_pressure'] ?? '-'}/${vitals['diastolic_pressure'] ?? '-'}", style: TextStyle(fontSize: 14.sp)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}