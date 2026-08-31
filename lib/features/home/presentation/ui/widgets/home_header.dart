
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/features/home/searchresult/presentation/ui/view/search_result_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Find your",
                  style: TextStyle(fontSize: 24.sp, color: Colors.black54), 
                ),
                Text(
                  "Specialist",
                  style: TextStyle(
                    fontSize: 32.sp, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.notifications_none,
              size: 30.sp, 
              color: const Color(0xFF1E1E66),
            ),
          ],
        ),
        SizedBox(height: 25.h), 
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchResultPage()),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w), 
            height: 55.h, 
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15.r), 
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey, size: 24.sp), 
                SizedBox(width: 10.w),
                Text(
                  "Search doctor...",
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp), 
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}