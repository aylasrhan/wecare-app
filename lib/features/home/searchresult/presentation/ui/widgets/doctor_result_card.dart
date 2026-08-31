import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorResultCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String rating;
  final String fee;
  final VoidCallback? onBookPressed; 

  const DoctorResultCard({
    super.key,
    required this.doctorName,
    required this.specialty,
    required this.rating,
    required this.fee,
    this.onBookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h), 
      padding: EdgeInsets.all(16.w), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), 
            blurRadius: 10.r, 
            offset: Offset(0, 5.h), 
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r, 
                backgroundColor: Colors.blue.shade100, 
                child: Icon(Icons.person, color: Colors.blue, size: 30.sp), 
              ),
              SizedBox(width: 15.w),
              Expanded( 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName, 
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold), 
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      specialty, 
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp), 
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue, size: 16.sp), 
                        Text(
                          " $rating", 
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: 30.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fee Starts from", 
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey), 
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "\$$fee", 
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold), 
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: onBookPressed ?? () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E66),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r), 
                  ),
                ),
                child: Text(
                  "Book Now", 
                  style: TextStyle(color: Colors.white, fontSize: 14.sp), 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}