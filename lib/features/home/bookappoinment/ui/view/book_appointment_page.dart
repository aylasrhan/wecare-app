
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/home/presentation/ui/view/home_screen.dart';
import 'package:wecare/features/home/bookappoinment/ui/widgets/appointment_calendar_widget.dart'; 
import 'package:wecare/features/home/bookappoinment/ui/widgets/appointment_times_wrap.dart'; 

class BookAppointmentPage extends StatefulWidget {
  final dynamic doctor; 

  const BookAppointmentPage({super.key, this.doctor});

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
        title: Text("Book Appointment", style: TextStyle(fontSize: 20.sp)), 
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Date",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), 
            ),
            SizedBox(height: 10.h), 

            AppointmentCalendarWidget(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDaySelected: (selectedDay, focusedDay) async {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedTime = null; 
                  _bookedTimes = [];
                });
                
                String formattedDate = "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
 
                int doctorId = widget.doctor is Map ? widget.doctor['id'] : widget.doctor.id;

                List<String> booked = await AuthService().getBookedTimes(doctorId, formattedDate);
                
                if (!mounted) return;
                setState(() {
                  _bookedTimes = booked; 
                });
              },
            ),

            SizedBox(height: 20.h),
            Text(
              "Select Hour",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), 
            ),
            SizedBox(height: 15.h),

            AppointmentTimesWrap(
              times: times,
              bookedTimes: _bookedTimes,
              selectedTime: _selectedTime,
              onTimeSelected: (time) {
                setState(() => _selectedTime = time);
              },
            ),

            SizedBox(height: 30.h),

            Center(
              child: SizedBox(
                width: 250.w, 
                height: 50.h, 
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r), 
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

                          String result = await AuthService().bookAppointment(
                            doctor: widget.doctor, 
                            date: formattedDate,
                            time: _selectedTime!,
                          );

                          if (!mounted) return;
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
                          if (!mounted) return;
                          setState(() {
                            _isLoading = false;
                          });
                          print("Error: $e");
                        }
                      },
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Next",
                          style: TextStyle(fontSize: 18.sp, color: Colors.white), 
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