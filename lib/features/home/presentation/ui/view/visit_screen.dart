// import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Visits", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
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
          // جلب اسم العيادة من العلاقة gnr_m_clinics
          Text(visit['gnr_m_clinics']?['name'] ?? "عيادة عامة", 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
              // التاريخ الذي قمتِ بتنسيقه في لارافيل
              Text(visit['d_start'].toString(), style: TextStyle(color: Colors.grey)),
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