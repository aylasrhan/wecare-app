import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/home/presentation/ui/view/profile_page.dart';

class MoreMenuContainer extends StatelessWidget {
  const MoreMenuContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A237E), 
        borderRadius: BorderRadius.circular(20.r), 
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h), 
      child: Column(
        children: [
          _buildListTile(context, Icons.person_outline, "Profile"),
          _buildListTile(context, Icons.percent, "Other"),
          _buildListTile(context, Icons.attach_money, "Payments"),
          _buildListTile(context, Icons.calendar_month, "Appointments"),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title) {
    return Material(
      color: Colors.transparent, 
      child: ListTile(
        leading: Icon(icon, color: Colors.white70, size: 24.sp), 
        title: Text(title, style: TextStyle(color: Colors.white, fontSize: 18.sp)), 
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16.sp), 
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