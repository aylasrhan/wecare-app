import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalInputSection extends StatelessWidget {
  final List clinics;
  final int? selectedClinicId;
  final ValueChanged<int?> onClinicChanged;
  final TextEditingController questionController;
  final VoidCallback onSendPressed;

  const MedicalInputSection({
    super.key,
    required this.clinics,
    required this.selectedClinicId,
    required this.onClinicChanged,
    required this.questionController,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.h, bottom: 20.h), 
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w), 
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15.r), 
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                hint: Text(
                  clinics.isEmpty
                      ? "جارِ التحميل أو لا توجد عيادات..."
                      : "اختر العيادة",
                  style: TextStyle(fontSize: 14.sp), 
                ),
                value: selectedClinicId,
                isExpanded: true,
                items: clinics.isEmpty
                    ? [
                        DropdownMenuItem<int>(
                          value: null,
                          child: Text("لا توجد بيانات", style: TextStyle(fontSize: 14.sp)),
                        ),
                      ]
                    : clinics.map((clinic) {
                        return DropdownMenuItem<int>(
                          value: clinic['id'],
                          child: Text(clinic['name_ar'] ?? "غير معروف", style: TextStyle(fontSize: 14.sp)), 
                        );
                      }).toList(),
                onChanged: clinics.isEmpty ? null : onClinicChanged,
              ),
            ),
          ),
          SizedBox(height: 10.h), 
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w), 
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15.r), 
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: questionController,
              style: TextStyle(fontSize: 15.sp), 
              decoration: InputDecoration(
                hintText: "Question",
                hintStyle: TextStyle(fontSize: 14.sp), 
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.send, color: const Color(0xFF1E1E66), size: 24.sp), 
                  onPressed: onSendPressed,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}