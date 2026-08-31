
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/home/presentation/ui/widgets/patient_appointment_card.dart'; // 🔴 استيراد البطاقة المنفصلة

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      var data = await AuthService().getPatientAppointments();
      if (!mounted) return;
      setState(() {
        appointments = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      print("Error loading appointments: $e");
    }
  }

  Future<void> _cancelAppointment(int appointmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');
    
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/cancel-appointment'),    
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'appointment': appointmentId, 
      }),
    );

    if (response.statusCode == 200) {
      _loadAppointments();
      if (!mounted) return;
      _showCancelDialog(context);
    } else {
      print("Failed: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointments", style: TextStyle(color: Colors.black, fontSize: 20.sp)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w), 
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15.h), 
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r), 
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Text(
                        "UpComing Appointments",
                        style: TextStyle(
                          color: Colors.grey, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 16.sp, 
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h), 
                  Expanded(
                    child: ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final app = appointments[index];
                        return PatientAppointmentCard(
                          app: app,
                          onCancel: (id) async {
                            await _cancelAppointment(id);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)), 
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40.r, 
              backgroundColor: Colors.green, 
              child: Icon(Icons.check, color: Colors.white, size: 50.sp) 
            ),
            SizedBox(height: 20.h),
            Text(
              "Success", 
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold) 
            ),
            SizedBox(height: 8.h),
            Text(
              "Cancelled Successfully", 
              style: TextStyle(fontSize: 16.sp) 
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text("Okay", style: TextStyle(fontSize: 16.sp)), 
            ),
          ],
        ),
      ),
    );
  }
}