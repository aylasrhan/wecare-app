
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/features/home/presentation/ui/widgets/more_grid_section.dart'; // 🔴 استيراد شبكة الأيقونات
import 'package:wecare/features/home/presentation/ui/widgets/more_menu_container.dart'; // 🔴 استيراد القائمة الزرقاء

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MoreGridSection(
                title: "Records",
                items: [
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
                ],
              ),
              
              SizedBox(height: 30.h), 
              
              MoreGridSection(
                title: "Consultancy",
                items: [
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
                ],
              ),
              
              SizedBox(height: 30.h), 
              
              const MoreMenuContainer(),
              
              SizedBox(height: 20.h), 
            ],
          ),
        ),
      ),
    );
  }
}