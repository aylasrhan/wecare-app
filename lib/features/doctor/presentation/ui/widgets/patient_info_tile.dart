import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientInfoTile extends StatelessWidget {
  final String title;
  final String content;

  const PatientInfoTile({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r), 
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp, 
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h), 
          Text(content, style: TextStyle(fontSize: 16.sp)), 
        ],
      ),
    );
  }
}