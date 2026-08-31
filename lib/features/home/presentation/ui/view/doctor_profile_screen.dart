
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/features/home/presentation/ui/widgets/doctor_booking_bottom_bar.dart'; // 🔴 استيراد شريط الحجز السفلي
import 'package:wecare/model/doctor_model.dart';

class DoctorProfileScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    print("Data received in Profile: ${doctor.toJson()}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Profile", style: TextStyle(color: Colors.black, fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h), 
            Center(
              child: CircleAvatar(
                radius: 60.r, 
                backgroundColor: Colors.blue.shade100,
                backgroundImage: const AssetImage("assets/images/doctor.png"),
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              doctor.nameAr,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor.specializationAr ?? "تخصص غير محدد",
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 30.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeInfo("From Time", doctor.fromTime ?? "--:--"),
                  Container(height: 40.h, width: 1.w, color: Colors.grey.shade300),
                  _buildTimeInfo("To Time", doctor.toTime ?? "--:--"),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About :",
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "هنا تكتب معلومات الطبيب بالتفصيل، السيرة الذاتية والخبرات الطبية.",
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade700, height: 1.5),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40.h),

            DoctorBookingBottomBar(doctor: doctor),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
        SizedBox(height: 5.h),
        Text(time, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}