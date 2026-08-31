import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/home/presentation/ui/view/medical_screen.dart'; 

class QuestionItemCard extends StatelessWidget {
  final QuestionItem item;

  const QuestionItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8.h), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r), 
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.clinicName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E1E66),
                fontSize: 16.sp, 
              ),
            ),
            SizedBox(height: 8.h), 
            Text(
              "س: ${item.question}",
              style: TextStyle(
                fontSize: 15.sp, 
                color: Colors.black87,
              ),
            ),
            const Divider(),
            if (item.answer != null && item.answer!.isNotEmpty)
              Text(
                "ج: ${item.answer}",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp, 
                ),
              )
            else
              Text(
                "⏳ بانتظار رد الطبيب...",
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 13.sp, 
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}