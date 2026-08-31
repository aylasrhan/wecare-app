import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const ProfileTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: TextStyle(color: Colors.grey, fontSize: 16.sp), 
        ),
        SizedBox(height: 5.h), 
        TextField(
          controller: controller,
          readOnly: true, 
          style: TextStyle(fontSize: 16.sp), 
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        SizedBox(height: 15.h), 
      ],
    );
  }
}