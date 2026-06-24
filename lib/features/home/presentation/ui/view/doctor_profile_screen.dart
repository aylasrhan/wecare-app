import 'package:flutter/material.dart';
import 'package:wecare/features/home/presentation/ui/view/book_appointment_page.dart';

class DoctorProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. الشريط العلوي
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // للرجوع للخلف
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
                backgroundImage: AssetImage("assets/images/doctor.png"), // تأكدي من المسار
              ),
            ),
            SizedBox(height: 15),
            // 3. الاسم والتخصص
            Text(
              "samer ali",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "عينية",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 30),

            // 4. ساعات العمل (From Time / To Time)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeInfo("From Time", "18:50:00"),
                  // خط فاصل عمودي
                  Container(height: 40, width: 1, color: Colors.grey.shade300),
                  _buildTimeInfo("To Time", "20:50:00"),
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
                    "Textarea\nهنا تكتب معلومات الطبيب بالتفصيل، السيرة الذاتية والخبرات الطبية.",
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700, height: 1.5),
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),

            // 6. منطقة زر الحجز (الخلفية الزرقاء الفاتحة)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
              decoration: BoxDecoration(
                color: Color(0xFFE3F2FD), // لون أزرق فاتح جداً
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
                      Text("Slot Time", style: TextStyle(color: Colors.grey.shade700, fontSize: 16)),
                      Text("15", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookAppointmentPage()),
    );                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E1E66), // الكحلي الغامق
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