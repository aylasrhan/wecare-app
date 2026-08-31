import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class VisitDiagnosesSection extends StatelessWidget {
  final dynamic diagnosesList;

  const VisitDiagnosesSection({super.key, required this.diagnosesList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("التشخيص الطبي:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16.sp)),
        SizedBox(height: 8.h),
        (diagnosesList is List && diagnosesList.isNotEmpty)
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: diagnosesList.length,
                itemBuilder: (context, index) {
                  final item = diagnosesList[index];
                  final val = (item is Map) 
                      ? (item['name_ar'] ?? item['val'] ?? item['text'] ?? item['code']?.toString() ?? '') 
                      : item.toString();
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    child: ListTile(
                      leading: Icon(Icons.medical_services, color: Colors.green, size: 24.sp),
                      title: Text(val, style: TextStyle(fontSize: 15.sp)),
                    ),
                  );
                },
              )
            : Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(color: Colors.grey[150], borderRadius: BorderRadius.circular(10.r)),
                child: Text("لا يوجد تشخيص مسجل لهذه الزيارة.", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
              ),
      ],
    );
  }
}