import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VisitInvoiceSection extends StatelessWidget {
  final Map? invoice;

  const VisitInvoiceSection({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    if (invoice != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Text(
              "معلومات الفاتورة:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                fontSize: 16.sp,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Card(
            color: Colors.indigo[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(15.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("الإجمالي:", style: TextStyle(fontSize: 14.sp)),
                      Text(
                        "${invoice!['total'] ?? 0} ل.س",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("المدفوع:", style: TextStyle(fontSize: 14.sp)),
                      Text(
                        "${invoice!['paid'] ?? 0} ل.س",
                        style: TextStyle(color: Colors.green, fontSize: 14.sp),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("المتبقي:", style: TextStyle(fontSize: 14.sp)),
                      Text(
                        "${invoice!['balance'] ?? 0} ل.س",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Text(
          "لا توجد فاتورة مرتبطة بهذه الزيارة بعد.",
          style: TextStyle(color: Colors.grey, fontSize: 14.sp),
        ),
      );
    }
  }
}
