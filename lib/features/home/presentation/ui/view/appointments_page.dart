import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // زر Upcoming Appointments
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Center(
                child: Text("UpComing Appointments", 
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20),
            // قائمة المواعيد
            Expanded(
              child: ListView(
                children: [
                  _buildAppointmentItem(context, "samer ali", "19:50:00"),
                  _buildAppointmentItem(context, "samer ali", "20:05:00"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItem(BuildContext context, String doctorName, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 30, backgroundColor: Colors.blue),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctorName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("samerali@gmail.com", style: TextStyle(color: Colors.grey)),
                  Row(children: [Icon(Icons.star, color: Colors.lightBlue, size: 16), Text(" 4.8")]),
                ],
              ),
            ],
          ),
          Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Icon(Icons.calendar_today, size: 16), Text(" 2023-08-23")]),
              Row(children: [Icon(Icons.access_time, size: 16), Text(" $time")]),
              CircleAvatar(radius: 8, backgroundColor: Colors.orange.shade300),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showCancelDialog(context),
                  child: Text("Cancel", style: TextStyle(color: Colors.black)),
                ),
              ),
              // زر إعادة الجدولة
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E1E66)),
                  child: Text("Reschedule", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 40, backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white, size: 50)),
            SizedBox(height: 20),
            Text("Success", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Cancelled Successfully"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Okay"),
            ),
          ],
        ),
      ),
    );
  }
}