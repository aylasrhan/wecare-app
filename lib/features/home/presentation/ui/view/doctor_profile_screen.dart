
import 'package:flutter/material.dart';
import 'package:wecare/features/home/presentation/ui/view/book_appointment_page.dart';
import 'package:wecare/model/doctor_model.dart';

class DoctorProfileScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    print("Data received in Profile: ${doctor.toJson()}");
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. الشريط العلوي
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            // 2. الصورة الشخصية
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue.shade100,
                backgroundImage: AssetImage("assets/images/doctor.png"),
              ),
            ),
            SizedBox(height: 15),
            // 3. الاسم والتخصص
            Text(
              doctor.nameAr,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor.specializationAr ?? "تخصص غير محدد",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),

            // 4. ساعات العمل
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeInfo("From Time", doctor.fromTime ?? "--:--"),
                  Container(height: 40, width: 1, color: Colors.grey.shade300),
                  _buildTimeInfo("To Time", doctor.toTime ?? "--:--"),
                ],
              ),
            ),

            SizedBox(height: 30),

            // 5. قسم "About"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About :",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "هنا تكتب معلومات الطبيب بالتفصيل، السيرة الذاتية والخبرات الطبية.",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // 6. منطقة زر الحجز
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Slot Time", style: TextStyle(color: Colors.grey)),
                      Text(
                        doctor.slotTime?.toString() ?? "0",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookAppointmentPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E1E66),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ودجت صغير لتنسيق الوقت
  Widget _buildTimeInfo(String label, String time) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 14)),
        SizedBox(height: 5),
        Text(time, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}