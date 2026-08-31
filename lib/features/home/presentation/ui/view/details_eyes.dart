
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/features/home/presentation/ui/widgets/clinic_doctor_card.dart';    

class DetailsEyeScreen extends StatefulWidget {
  final int clinicId;
  final String clinicName;

  const DetailsEyeScreen({super.key, required this.clinicId, required this.clinicName});

  @override
  _DetailsEyeScreenState createState() => _DetailsEyeScreenState();
}

class _DetailsEyeScreenState extends State<DetailsEyeScreen> {
  List doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<void> fetchDoctors() async {
    String? token = await getToken();
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/doctors_by_department'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {'subgrp': widget.clinicId.toString()},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        
        setState(() {
          doctors = data['doctors'] ?? []; 
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          doctors = [];
          isLoading = false;
        });
        print("لا يوجد أطباء لهذا التخصص");
      } else {
        print("فشل الاتصال، كود الحالة: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp), 
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.clinicName,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18.sp), 
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctors.isEmpty
              ? Center(child: Text("لا يوجد أطباء في هذه العيادة حالياً", style: TextStyle(fontSize: 16.sp))) 
              : ListView.builder(
                  padding: EdgeInsets.all(15.w), 
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    var doctor = doctors[index];
                    return ClinicDoctorCard(
                      doctorMap: doctor,
                      clinicName: widget.clinicName,
                    );
                  },
                ),
    );
  }
}