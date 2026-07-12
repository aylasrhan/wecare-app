// import 'package:flutter/material.dart';
<<<<<<< HEAD

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
=======

// class VisitsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Visits", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(20),
//         itemCount: 2, // عدد الزيارات
//         itemBuilder: (context, index) {
//           return _buildVisitCard();
//         },
//       ),
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
//           Text("جلدية", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
import 'package:flutter/material.dart';
import 'package:wecare/core/services/auth_service.dart';

class VisitsPage extends StatefulWidget {
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  final AuthService authService = AuthService();
// غيري هذا السطر في تعريف المتغيرات داخل الـ State
late Future<Map<String, dynamic>> futureVisits;
  @override
  void initState() {
    super.initState();
    // جلب البيانات عند فتح الصفحة
    futureVisits = authService.getPatientVisits();
  }

>>>>>>> 6479177afc8f71b8333fec09e0b3f3813a70e82e
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Visits", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
<<<<<<< HEAD
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
=======
       ),
       body: FutureBuilder<Map<String, dynamic>>( // هنا التعديل الأول
  future: futureVisits,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text("خطأ: ${snapshot.error}"));
    } 
    // هنا نتأكد من وجود البيانات داخل مفتاح 'visits'
    else if (!snapshot.hasData || snapshot.data!['visits'] == null) {
      return Center(child: Text("لا توجد زيارات."));
    }

    // هنا نستخرج القائمة من الـ Map
    List<dynamic> visits = snapshot.data!['visits'];

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: visits.length,
      itemBuilder: (context, index) {
        return _buildVisitCard(visits[index]);
      },
    );
  },
),
      // body: FutureBuilder<Map<String, dynamic>>( // ننتظر خريطة (Map) لأن الرد يحتوي على "visits"
      //   future: authService.getPatientVisits(), // دالة الـ API التي تجلب الرد كامل
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     } else if (snapshot.hasError) {
      //       return Center(child: Text("خطأ: ${snapshot.error}"));
      //     } else if (!snapshot.hasData || snapshot.data!['visits'] == null) {
      //       return Center(child: Text("لا توجد زيارات."));
      //     }

      //     // هنا نصل للبيانات الفعلية من مفتاح 'visits'
      //     List<dynamic> visits = snapshot.data!['visits'];

      //     return ListView.builder(
      //       padding: EdgeInsets.all(20),
      //       itemCount: visits.length,
      //       itemBuilder: (context, index) {
      //         return _buildVisitCard(visits[index]);
      //       },
      //     );
      //   },
      // ),
    );
  }

  Widget _buildVisitCard(Map<String, dynamic> visit) {
    // تنسيق الحالة من لارافيل
    String statusText = (visit['type'] == 1) ? "Completed" : "UnCompleted";
    Color statusColor = (visit['type'] == 1) ? Colors.green : Colors.amber;

>>>>>>> 6479177afc8f71b8333fec09e0b3f3813a70e82e
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
<<<<<<< HEAD
          // عرض اسم العيادة من السيرفر
          Text(visit['clinic_name'] ?? "عيادة غير معروفة", 
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
=======
          // جلب اسم العيادة من العلاقة gnr_m_clinics
          Text(visit['gnr_m_clinics']?['name'] ?? "عيادة عامة", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
>>>>>>> 6479177afc8f71b8333fec09e0b3f3813a70e82e
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.circle, size: 12, color: statusColor),
              SizedBox(width: 5),
              Text(statusText, style: TextStyle(color: Colors.grey)),
            ],
          ),
          Divider(height: 30),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              SizedBox(width: 5),
<<<<<<< HEAD
              // عرض التاريخ من السيرفر
              Text(visit['d_start'] ?? "التاريخ غير متاح", 
                   style: TextStyle(color: Colors.grey)),
=======
              // التاريخ الذي قمتِ بتنسيقه في لارافيل
              Text(visit['d_start'].toString(), style: TextStyle(color: Colors.grey)),
>>>>>>> 6479177afc8f71b8333fec09e0b3f3813a70e82e
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