
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 

import 'package:wecare/features/home/presentation/ui/widgets/appointment_card.dart';
import 'package:wecare/features/home/presentation/ui/widgets/clinic_tile.dart';
import 'package:wecare/features/home/presentation/ui/widgets/doctor_card.dart';
import 'package:wecare/features/home/presentation/ui/widgets/home_header.dart';

class HomePageContent extends StatefulWidget {
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List famousDoctors = [];
  List clinics = [];
  bool isLoading = true;
  final String baseUrl = "http://10.0.2.2:8000/api";
  List upcomingAppointments = [];

  @override
  void initState() {
    super.initState();
    _fetchAllData(); 
  }

  Future<void> _fetchAllData() async {
    setState(() => isLoading = true);
    await Future.wait([
      fetchClinics(),
      fetchFamousDoctors(),
      fetchAppointments(),
    ]);
    setState(() => isLoading = false);
  }

  Future<void> fetchAppointments() async {
    try {
      AuthService authService = AuthService();
      List<dynamic> appointments = await authService.getPatientAppointments();
      
      setState(() {
        upcomingAppointments = appointments;
        print("عدد المواعيد التي وصلت من السيرفر: ${upcomingAppointments.length}");
      });
    } catch (e) {
      print("Error fetching appointments: $e");
    }
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<void> fetchFamousDoctors() async {
    String? token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/famous_doctors'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(
          utf8.decode(response.bodyBytes, allowMalformed: true),
        );
        setState(() => famousDoctors = data['data']);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchClinics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clinics'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          clinics = jsonResponse['data'] ?? [];
        });
      }
    } catch (e) {
      print("Error fetching clinics: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: const Color(0xFF1E1E66),
        onRefresh: _fetchAllData, 
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), 
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              
              const HomeHeader(),
              
              SizedBox(height: 25.h),
              SizedBox(
                height: 120.h, 
                child: isLoading && clinics.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: clinics.length,
                        itemBuilder: (context, index) => ClinicTile(clinic: clinics[index]),
                      ),
              ),
              SizedBox(height: 25.h),
              Text(
                "Popular Doctor",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15.h),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: famousDoctors.length,
                itemBuilder: (context, index) => DoctorCard(doctor: famousDoctors[index]),
              ),
              SizedBox(height: 25.h),
              Text(
                "Upcoming Appointment",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15.h),
              upcomingAppointments.isEmpty 
                  ? Text("لا توجد مواعيد قادمة", style: TextStyle(fontSize: 16.sp)) 
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: upcomingAppointments.length,
                      itemBuilder: (context, index) => AppointmentCard(appointment: upcomingAppointments[index]),
                    ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}