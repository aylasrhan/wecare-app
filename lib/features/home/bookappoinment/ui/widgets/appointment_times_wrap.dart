import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppointmentTimesWrap extends StatelessWidget {
  final List<String> times;
  final List<String> bookedTimes;
  final String? selectedTime;
  final ValueChanged<String> onTimeSelected;

  const AppointmentTimesWrap({
    super.key,
    required this.times,
    required this.bookedTimes,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w, 
      runSpacing: 10.h, 
      children: times.map((time) {
        bool isBooked = bookedTimes.contains(time);

        return ChoiceChip(
          label: Text(
            time,
            style: TextStyle(
              fontSize: 14.sp, 
              color: isBooked 
                  ? Colors.grey.shade500 
                  : (selectedTime == time ? Colors.white : Colors.black),
              decoration: isBooked ? TextDecoration.lineThrough : null,
            ),
          ),
          selected: selectedTime == time && !isBooked,
          selectedColor: const Color(0xFF4FC3F7),
          backgroundColor: isBooked ? Colors.grey.shade200 : Colors.white, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r), 
            side: BorderSide(
              color: isBooked ? Colors.transparent : Colors.blueGrey,
            ),
          ),
          onSelected: isBooked
              ? null 
              : (selected) => onTimeSelected(time),
        );
      }).toList(),
    );
  }
}