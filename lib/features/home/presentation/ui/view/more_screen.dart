
import 'package:flutter/material.dart';
import 'package:wecare/features/home/presentation/ui/view/profile_page.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // استخدمنا SafeArea لضمان عدم تداخل العناصر مع حواف الهاتف
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Records", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              _buildGridSection([
                {"title": "Prescriptions", "icon": Icons.note},
                {"title": "Files", "icon": Icons.calendar_today},
                {"title": "Photo", "icon": Icons.image},
              ]),
              SizedBox(height: 30),
              Text("Consultancy", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              _buildGridSection([
                {"title": "Previous", "icon": Icons.note},
                {"title": "Upcoming", "icon": Icons.calendar_today},
                {"title": "Cancelled", "icon": Icons.image},
              ]),
              SizedBox(height: 30),
              
              // القائمة الزرقاء التي تحتوي على جميع العناصر
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1A237E), 
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    _buildListTile(context,Icons.person_outline, "Profile"),
                    _buildListTile(context,Icons.percent, "Other"),
                    _buildListTile(context,Icons.attach_money, "Payments"),
                    _buildListTile(context,Icons.calendar_month, "Appointments"), // تمت إضافة زر Appointments هنا
                  ],
                ),
              ),
              SizedBox(height: 20), // مسافة إضافية في الأسفل لتجنب التداخل مع الـ BottomNavBar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridSection(List<Map<String, dynamic>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        return Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue[50],
              child: Icon(item['icon'], size: 30, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(item['title'], style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildListTile(BuildContext context,IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
      onTap: () {
        if (title == "Profile") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
      },
    );
  }
}