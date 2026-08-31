
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/home/presentation/ui/view/details_eyes.dart';

class ClinicTile extends StatelessWidget {
  final Map clinic;
  
  const ClinicTile({super.key, required this.clinic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsEyeScreen(
            clinicId: clinic['id'],
            clinicName: clinic['name_ar'],
          ),
        ),
      ),
      child: Container(
        width: 110.w, 
        margin: EdgeInsets.only(right: 15.w), 
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20.r), 
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w), 
          child: Center(
            child: Text(
              clinic['name_ar'] ?? '', 
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp, 
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}