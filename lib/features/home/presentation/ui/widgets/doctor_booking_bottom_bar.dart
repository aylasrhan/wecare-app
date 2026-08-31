import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/home/bookappoinment/ui/view/book_appointment_page.dart';
import 'package:wecare/model/doctor_model.dart';

class DoctorBookingBottomBar extends StatelessWidget {
  final Doctor doctor;

  const DoctorBookingBottomBar({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r), 
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Slot Time", style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
              Text(
                doctor.slotTime?.toString() ?? "0",
                style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookAppointmentPage(doctor: doctor),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E1E66),
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)), 
            ),
            child: Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
          ),
        ],
      ),
    );
  }
}