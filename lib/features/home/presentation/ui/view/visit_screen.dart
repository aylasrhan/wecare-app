// import 'package:flutter/material.dart';

// class VisitsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     List visits = [];
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Visits", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body:ListView.builder(
//   padding: EdgeInsets.all(20),
//   itemCount: visits.length, // نستخدم طول القائمة الحقيقي
//   itemBuilder: (context, index) {
//     return _buildVisitCard(visits[index]); // نمرر كل زيارة للكارد
//   },
// ),
//       //  ListView.builder(
//       //   padding: EdgeInsets.all(20),
//       //   itemCount: 2, // عدد الزيارات
//       //   itemBuilder: (context, index) {
//       //     return _buildVisitCard();
//       //   },
//       // ),
//     );
//   }

//   Widget _buildVisitCard() {
//     return Container(
//       margin: EdgeInsets.only(bottom: 20),
//       padding: EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(visit['clinic_name'] ?? "عيادة", style: ...),
//         Text(visit['d_start'] ?? "التاريخ غير متاح"),
//           // Text("جلدية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 5),
//           Row(
//             children: [
//               Icon(Icons.circle, size: 12, color: Colors.amber),
//               SizedBox(width: 5),
//               Text("UnCompleted", style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//           Divider(height: 30),
//           Row(
//             children: [
//               Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//               SizedBox(width: 5),
//               Text("2018-03-01 09:10 AM", style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//           SizedBox(height: 15),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF1E1E66),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               ),
//               child: Text("View", style: TextStyle(color: Colors.white)),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
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

  // Future<void> fetchVisits() async {
  //   // هنا يجب وضع كود الـ http.get لجلب البيانات من السيرفر
  //   // بعد الحصول على البيانات، قومي بتحديث المتغير visits
  //   setState(() {
  //     // visits = responseData['data']; // مثال
  //     isLoading = false;
  //   });
  // }
Future<void> fetchVisits() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  try {
    // تم تعديل الرابط ليطابق ما هو موجود في ملف الـ routes/api.php
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/visits'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("بيانات الزيارات: $data"); // للتحقق من هيكلية البيانات المستلمة
      
      setState(() {
        // تأكدي من المفتاح الذي يرسله السيرفر (هل هو 'visits' أم 'data'؟)
        // بناءً على رسالة الـ Log السابقة، قد تحتاجين لتغييره لـ 'data' أو ما يطابق استجابة الـ API
        visits = data['data']; 
        isLoading = false;
      });
    } else {
      print("خطأ في السيرفر: ${response.body}");
      setState(() => isLoading = false);
    }
  } catch (e) {
    print("خطأ في الاتصال: $e");
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
          Text(visit['clinic_name'] ?? "عيادة غير معروفة", 
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.circle, size: 12, color: Colors.amber),
              SizedBox(width: 5),
              Text("UnCompleted", style: TextStyle(color: Colors.grey)),
            ],
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