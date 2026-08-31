import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreGridSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const MoreGridSection({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, 
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            return Column(
              children: [
                CircleAvatar(
                  radius: 35.r, 
                  backgroundColor: item['bgColor'],
                  child: Icon(item['icon'], size: 30.sp, color: item['color']), 
                ),
                SizedBox(height: 8.h), 
                Text(
                  item['title'], 
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp), 
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}