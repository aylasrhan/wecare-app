// import 'package:flutter/material.dart';

// class AppointmentsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Appointments", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             // زر Upcoming Appointments
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.symmetric(vertical: 15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Center(
//                 child: Text("UpComing Appointments", 
//                   style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
//               ),
//             ),
//             SizedBox(height: 20),
//             // قائمة المواعيد
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildAppointmentItem(context, "samer ali", "19:50:00"),
//                   _buildAppointmentItem(context, "samer ali", "20:05:00"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAppointmentItem(BuildContext context, String doctorName, String time) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 20),
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(radius: 30, backgroundColor: Colors.blue),
//               SizedBox(width: 15),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(doctorName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                   Text("samerali@gmail.com", style: TextStyle(color: Colors.grey)),
//                   Row(children: [Icon(Icons.star, color: Colors.lightBlue, size: 16), Text(" 4.8")]),
//                 ],
//               ),
//             ],
//           ),
//           Divider(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(children: [Icon(Icons.calendar_today, size: 16), Text(" 2023-08-23")]),
//               Row(children: [Icon(Icons.access_time, size: 16), Text(" $time")]),
//               CircleAvatar(radius: 8, backgroundColor: Colors.orange.shade300),
//             ],
//           ),
//           SizedBox(height: 15),
//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton(
//                   onPressed: () => _showCancelDialog(context),
//                   child: Text("Cancel", style: TextStyle(color: Colors.black)),
//                 ),
//               ),
//               // زر إعادة الجدولة
//               SizedBox(width: 10),
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E1E66)),
//                   child: Text("Reschedule", style: TextStyle(color: Colors.white)),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _showCancelDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CircleAvatar(radius: 40, backgroundColor: Colors.green, child: Icon(Icons.check, color: Colors.white, size: 50)),
//             SizedBox(height: 20),
//             Text("Success", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//             Text("Cancelled Successfully"),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text("Okay"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/core/services/auth_service.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  // دالة جلب المواعيد
  Future<void> _loadAppointments() async {
    try {
      var data = await AuthService().getUpcomingAppointments();
      setState(() {
        appointments = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error loading appointments: $e");
    }
  }

  // دالة إلغاء الموعد
  Future<void> _cancelAppointment(int appointmentId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');
  
  // تأكدي أن هذا الرابط يطابق الرابط في api.php
  // لاحظي هنا أننا نرسل الطلب إلى cancel-appointment بدون id في الرابط
  final response = await http.post(
Uri.parse('http://10.0.2.2:8000/api/cancel-appointment'),    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'appointment': appointmentId, // هذا هو الحقل الذي ينتظره الـ validator في اللارفل
    }),
  );

  if (response.statusCode == 200) {
    _loadAppointments(); // تحديث القائمة بعد النجاح
  } else {
    print("Failed: ${response.body}");
  }
  }

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
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final app = appointments[index];
                        return _buildAppointmentItem(context, app);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildAppointmentItem(BuildContext context, Map app) {
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
                  Text(app['doctor_name'] ?? 'Unknown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text("Doctor", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [Icon(Icons.calendar_today, size: 16), Text(" ${app['appointment_date']}")]),
              Row(children: [Icon(Icons.access_time, size: 16), Text(" ${app['time']}")]),
              CircleAvatar(radius: 8, backgroundColor: Colors.orange.shade300),
            ],
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    // استدعاء دالة الإلغاء
                    await _cancelAppointment(app['id']);
                    // إظهار رسالة النجاح
                    _showCancelDialog(context);
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.black)),
                ),
              ),
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