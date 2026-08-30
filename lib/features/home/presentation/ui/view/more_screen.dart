
import 'package:flutter/material.dart';
import 'package:wecare/features/home/presentation/ui/view/profile_page.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Records", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              
              // قسم الـ Records مع الأيقونات والألوان الخاصة به
              _buildGridSection([
                {
                  "title": "Prescriptions", 
                  "icon": Icons.note_alt_rounded, 
                  "color": Colors.blue[900], 
                  "bgColor": Colors.blue[50]
                },
                {
                  "title": "Files", 
                  "icon": Icons.calendar_today_outlined, 
                  "color": Colors.blue, 
                  "bgColor": Colors.blue[50]
                },
                {
                  "title": "Photo", 
                  "icon": Icons.image_rounded, 
                  "color": Colors.deepOrange, 
                  "bgColor": Colors.orange[50]
                },
              ]),
              
              SizedBox(height: 30),
              Text("Consultancy", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              
              // قسم الـ Consultancy مطابَق تماماً للأول من حيث الأيقونات وتوزيع الألوان
              _buildGridSection([
                {
                  "title": "Previous", 
                  "icon": Icons.note, 
                  "color": Colors.black, 
                  "bgColor": Colors.blue[50]
                },
                {
                  "title": "Upcoming", 
                  "icon": Icons.calendar_month, 
                  "color": Colors.green, 
                  "bgColor": Colors.green[50]
                },
                {
                  "title": "Cancelled", 
                  "icon": Icons.photo_camera_back_rounded, 
                  "color": const Color.fromARGB(255, 187, 8, 8), 
                  "bgColor": Colors.orange[50]
                },
              ]),
              
              SizedBox(height: 30),
              
              // القائمة الزرقاء السفلى (تمت إزالة الارتفاع الثابت لتجنب الأخطاء وتأخذ حجمها الطبيعي)
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF1A237E), 
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    _buildListTile(context, Icons.person_outline, "Profile"),
                    _buildListTile(context, Icons.percent, "Other"),
                    _buildListTile(context, Icons.attach_money, "Payments"),
                    _buildListTile(context, Icons.calendar_month, "Appointments"),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // تم تعديل الدالة لتستقبل الألوان المخصصة لكل أيقونة وخلفية
  Widget _buildGridSection(List<Map<String, dynamic>> items) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        return Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: item['bgColor'],
              child: Icon(item['icon'], size: 30, color: item['color']),
            ),
            SizedBox(height: 8),
            Text(item['title'], style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        );
      }).toList(),
    );
  }

  // Widget _buildListTile(BuildContext context, IconData icon, String title) {
  //   return ListTile(
  //     leading: Icon(icon, color: Colors.white70),
  //     title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
  //     trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
  //     onTap: () {
  //       if (title == "Profile") {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => ProfilePage()),
  //         );
  //       }
  //     },
  //   );
  // }
  Widget _buildListTile(BuildContext context, IconData icon, String title) {
    return Material(
      color: Colors.transparent, 
      child: ListTile(
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
      ),
    );
  }
}