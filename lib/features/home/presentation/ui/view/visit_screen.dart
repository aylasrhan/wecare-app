
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// تأكدي من استيراد مكتبة الاتصال بالسيرفر (مثل http أو dio)
// import 'package:http/http.dart' as http; 

class VisitsPage extends StatefulWidget {
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  List visits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVisits(); // استدعاء البيانات عند فتح الصفحة
  }

  
Future<void> fetchVisits() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/visits'), // تأكدي من هذا الرابط
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
print("Response Body: ${response.body}"); // هذا السطر سيخبرنا بالحقيقة
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      if (!mounted) return; 

      setState(() {
        // التعديل هنا: استخدام المفتاح 'visits' بدلاً من 'upcoming_Appointment'
        if (data.containsKey('visits')) {
          visits = data['visits'];
        } else {
          visits = [];
        }
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  } catch (e) {
    if (!mounted) return;
    setState(() => isLoading = false);
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Visits", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : visits.isEmpty
              ? Center(child: Text("لا توجد زيارات"))
              : ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: visits.length,
                  itemBuilder: (context, index) {
                    return _buildVisitCard(visits[index]);
                  },
                ),
    );
  }

  Widget _buildVisitCard(Map visit) {
   String clinicName = visit['gnr_m_clinics']?['name_ar'] ?? "عيادة غير معروفة";
  // Color statusColor = statusText == "Completed" ? Colors.green : Colors.orange;
  int statusValue = visit['status'] ?? 0;
  String statusText = statusValue == 1 ? "Completed" : "UnCompleted";
  Color statusColor = statusValue == 1 ? Colors.green : Colors.orange;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عرض اسم العيادة من السيرفر
          // Text(visit['clinic_name'] ?? "عيادة غير معروفة", 
          Text(clinicName,
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.circle, size: 12, color: statusColor),
              SizedBox(width: 5),
Text(statusText, style: TextStyle(color: statusColor)),            ],
          ),
          Divider(height: 30),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              SizedBox(width: 5),
              // عرض التاريخ من السيرفر
              Text(visit['d_start'] ?? "التاريخ غير متاح", 
                   style: TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E1E66),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("View", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}