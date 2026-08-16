

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/home/presentation/ui/view/home_screen.dart';

class BookAppointmentPage extends StatefulWidget {
  final dynamic doctor; // استقبال بيانات الطبيب المختار

  const BookAppointmentPage({Key? key, this.doctor}) : super(key: key);

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;
  bool _isLoading = false;
  List<String> _bookedTimes = [];
  
  final List<String> times = [
    "18:50",
    "19:05",
    "19:35",
    "19:50",
    "20:20",
    "20:35",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // التقويم
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2027, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) async {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedTime = null; 
                    _bookedTimes = [];
                  });
                  
                  String formattedDate = "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
 
                  // استخراج معرف الطبيب بأمان عند جلب الأوقات المحجوزة أيضاً
                  int doctorId = widget.doctor is Map ? widget.doctor['id'] : widget.doctor.id;

                  // استدعاء الأوقات المحجوزة من السيرفر
                  List<String> booked = await AuthService().getBookedTimes(doctorId, formattedDate);
                  
                  setState(() {
                    _bookedTimes = booked; 
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF5C6BC0),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Select Hour",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: times.map((time) {
                bool isBooked = _bookedTimes.contains(time);

                return ChoiceChip(
                  label: Text(
                    time,
                    style: TextStyle(
                      color: isBooked 
                          ? Colors.grey.shade500 
                          : (_selectedTime == time ? Colors.white : Colors.black),
                      decoration: isBooked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  selected: _selectedTime == time && !isBooked,
                  selectedColor: const Color(0xFF4FC3F7),
                  backgroundColor: isBooked ? Colors.grey.shade200 : Colors.white, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                      color: isBooked ? Colors.transparent : Colors.blueGrey,
                    ),
                  ),
                  onSelected: isBooked
                      ? null 
                      : (selected) => setState(() => _selectedTime = time),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // زر Next
            Center(
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _isLoading 
                    ? null 
                    : () async {
                        if (_selectedDay == null || _selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("الرجاء اختيار التاريخ والوقت أولاً"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          String formattedDate =
                              "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";

                          // استخراج معرف الطبيب بأمان سواء كان Map أو كائن Doctor
                          int doctorId = widget.doctor is Map ? widget.doctor['id'] : widget.doctor.id;

                          String result = await AuthService().bookAppointment(
  doctor: widget.doctor, // نمرر كائن الدكتور بالكامل لضمان التقاط الـ ID الصحيح من الـ AuthService
  date: formattedDate,
  time: _selectedTime!,
);

                          setState(() {
                            _isLoading = false;
                          });

                          if (result == "success") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("تم حجز الموعد بنجاح"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreenPage()),
                              (route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                          });
                          print("Error: $e");
                        }
                      },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Next",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}