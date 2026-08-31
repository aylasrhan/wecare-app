import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatientAppointmentCard extends StatelessWidget {
  final Map app;
  final Future<void> Function(int appointmentId) onCancel;

  const PatientAppointmentCard({
    super.key,
    required this.app,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h), 
      padding: EdgeInsets.all(15.w), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r), 
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10.r) 
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.r, 
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white, size: 30.sp), 
              ),
              SizedBox(width: 15.w), 
              Expanded( 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app['doctor_name'] ?? 'Unknown', 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp), 
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Doctor", 
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp), 
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
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16.sp), 
                  Text(" ${app['appointment_date']}", style: TextStyle(fontSize: 14.sp)) 
                ]
              ),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16.sp), 
                  Text(" ${app['time']}", style: TextStyle(fontSize: 14.sp)) 
                ]
              ),
              CircleAvatar(radius: 8.r, backgroundColor: Colors.orange.shade300), 
            ],
          ),
          SizedBox(height: 15.h), 
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  onPressed: () async {
                    await onCancel(app['id']);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 14.sp)), 
                ),
              ),
              SizedBox(width: 10.w), 
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E66),
                    padding: EdgeInsets.symmetric(vertical: 12.h), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                  child: Text("Reschedule", style: TextStyle(color: Colors.white, fontSize: 14.sp)), 
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}