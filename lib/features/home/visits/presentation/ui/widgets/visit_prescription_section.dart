import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class VisitPrescriptionSection extends StatelessWidget {
  final List prescriptionItems;
  final dynamic prescription;

  const VisitPrescriptionSection({super.key, required this.prescriptionItems, required this.prescription});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("الوصفة الطبية والأدوية:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 16.sp)),
        SizedBox(height: 8.h),
        prescriptionItems.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: prescriptionItems.length,
                itemBuilder: (context, index) {
                  final med = prescriptionItems[index];
                  final medName = med['medication_name'] ?? med['name'] ?? 'دواء';
                  final dosage = med['dosage'] ?? '';
                  final frequency = med['frequency'] ?? '';
                  final duration = med['duration'] ?? '';

                  return Card(
                    elevation: 1,
                    color: Colors.purple[50],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    child: ListTile(
                      leading: Icon(Icons.medication, color: Colors.purple, size: 24.sp),
                      title: Text(medName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
                      subtitle: Text(
                        "الجرعة: $dosage | التكرار: $frequency | المدة: $duration", 
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                  );
                },
              )
            : prescription != null
                ? Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.purple[50],
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Text("تم إصدار وصفة طبية بنجاح.", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  )
                : Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10.r)),
                    child: Text("لا توجد وصفة طبية لهذه الزيارة.", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                  ),
      ],
    );
  }
}