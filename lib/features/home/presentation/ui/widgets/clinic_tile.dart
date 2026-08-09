import 'package:flutter/material.dart';
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
        width: 110,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(clinic['name_ar'], textAlign: TextAlign.center),
        ),
      ),
    );
  }
}