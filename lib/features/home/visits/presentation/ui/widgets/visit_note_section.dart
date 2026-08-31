import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class VisitNotesSection extends StatelessWidget {
  final dynamic notesList;

  const VisitNotesSection({super.key, required this.notesList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("ملاحظات وتوصيات المتابعة:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16.sp)),
        SizedBox(height: 8.h),
        (notesList is List && notesList.isNotEmpty)
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  final item = notesList[index];
                  final val = (item is Map) ? (item['val']?.toString() ?? '') : '';
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    child: ListTile(
                      leading: Icon(Icons.note_alt, color: Colors.blue, size: 24.sp),
                      title: Text(val, style: TextStyle(fontSize: 15.sp)),
                    ),
                  );
                },
              )
            : Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10.r)),
                child: Text("لا توجد ملاحظات مسجلة لهذه الزيارة.", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
              ),
      ],
    );
  }
}