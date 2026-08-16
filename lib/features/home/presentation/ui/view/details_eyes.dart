
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/features/home/presentation/ui/view/doctor_profile_screen.dart';
import 'package:wecare/model/doctor_model.dart';

class DetailsEyeScreen extends StatefulWidget {
  final int clinicId;
  final String clinicName;

  DetailsEyeScreen({required this.clinicId, required this.clinicName});

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

    // التعديل هنا: التعامل مع كود 200 (نجاح) و 404 (لا يوجد أطباء)
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      
      setState(() {
        // نتحقق من وجود مفتاح 'doctors' في الرد
        doctors = data['doctors'] ?? []; 
        isLoading = false;
      });
    } else if (response.statusCode == 404) {
      // إذا كان الرد 404، يعني السيرفر يقول "لا يوجد أطباء"
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
    setState(() => isLoading = false);
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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.clinicName,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : doctors.isEmpty
              ? Center(child: Text("لا يوجد أطباء في هذه العيادة حالياً"))
              : ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
  var doctor = doctors[index];
  return _buildDoctorCard(
    context, // مررنا السياق لنتمكن من استخدام Navigator
    doctor,  // مررنا كائن الطبيب كاملاً لنأخذ منه الـ id والبيانات
  );
},
    //               itemBuilder: (context, index) {
    //                 var doctor = doctors[index];
    //                 return _buildDoctorCard(
    //                   doctor['name_ar'] ?? "غير معروف", // استخدمنا name_ar كما هو في قاعدة البيانات
    // doctor['total_rate']?.toString() ?? "0.0"
    //                 );
    //               },
                ),
    );
  }

  // Widget _buildDoctorCard(String name, String rating) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 20),
  //     padding: EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(25),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         Row(
  //           children: [
  //             CircleAvatar(
  //               radius: 35,
  //               backgroundColor: Colors.blue.shade600,
  //               child: Icon(Icons.person, size: 40, color: Colors.white),
  //             ),
  //             SizedBox(width: 15),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //                   Text(widget.clinicName, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
  //                   SizedBox(height: 5),
  //                   Row(
  //                     children: [
  //                       Icon(Icons.star, color: Colors.blue.shade300, size: 18),
  //                       SizedBox(width: 5),
  //                       Text(rating, style: TextStyle(fontWeight: FontWeight.bold)),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
 Widget _buildDoctorCard(BuildContext context, Map doctorMap) {
    // تحويل الـ Map إلى نموذج Doctor الذي تتوقعه شاشة البروفايل
Doctor doctor = Doctor.fromJson(Map<String, dynamic>.from(doctorMap));
    return GestureDetector(
      onTap: () {
        // الانتقال لشاشة البروفايل وتمرير كائن الـ Doctor مباشرة
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfileScreen(doctor: doctor),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blue.shade600,
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.nameAr, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(widget.clinicName, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.blue.shade300, size: 18),
                          SizedBox(width: 5),
Text(
  doctorMap['total_rate']?.toString() ?? "0.0", 
  style: TextStyle(fontWeight: FontWeight.bold),
),                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}