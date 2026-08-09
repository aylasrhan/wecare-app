import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/core/services/auth_service.dart';

// استيراد الودجتات اللي فصلناها
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
    fetchClinics();
    fetchFamousDoctors();
    fetchAppointments();
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
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // استدعاء الـ Header اللي فصلناه
            const HomeHeader(),
            
            const SizedBox(height: 25),
            SizedBox(
              height: 120,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: clinics.length,
                      // استدعاء ClinicTile وتمرير البيانات إله
                      itemBuilder: (context, index) => ClinicTile(clinic: clinics[index]),
                    ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Popular Doctor",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: famousDoctors.length,
              // استدعاء DoctorCard وتمرير البيانات إله
              itemBuilder: (context, index) => DoctorCard(doctor: famousDoctors[index]),
            ),
            const SizedBox(height: 25),
            const Text(
              "Upcoming Appointment",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            upcomingAppointments.isEmpty 
                ? const Text("لا توجد مواعيد قادمة") 
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: upcomingAppointments.length,
                    // استدعاء AppointmentCard وتمرير البيانات إله
                    itemBuilder: (context, index) => AppointmentCard(appointment: upcomingAppointments[index]),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}