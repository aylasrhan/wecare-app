
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/features/doctor/presentation/ui/widgets/review_dialog.dart';
import 'package:wecare/features/home/presentation/ui/view/visit_details.dart';

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
    fetchVisits();
  }

  Future<void> fetchVisits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/visits'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (!mounted) return; 

        setState(() {
          if (data.containsKey('visits')) {
            visits = data['visits'];
          } else {
            visits = [];
          }
          isLoading = false;
        });
      } else {
        if (!mounted) return;
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
              : RefreshIndicator(
                  onRefresh: fetchVisits, // تفعيل السحب للتحديث
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    itemCount: visits.length,
                    itemBuilder: (context, index) {
                      return _buildVisitCard(visits[index]);
                    },
                  ),
                ),
    );
  }

  // Widget _buildVisitCard(Map visit) {
  //   String clinicName = visit['gnr_m_clinics']?['name_ar'] ?? "عيادة غير معروفة";
    
  //   // قراءة آمنة لقيمة الـ status (سواء كانت int أو String أو bool)
  //   var rawStatus = visit['status'];
  //   int statusValue = 0;
  //   if (rawStatus is int) {
  //     statusValue = rawStatus;
  //   } else if (rawStatus is String) {
  //     statusValue = int.tryParse(rawStatus) ?? (rawStatus.toLowerCase() == 'completed' ? 1 : 0);
  //   } else if (rawStatus is bool) {
  //     statusValue = rawStatus ? 1 : 0;
  //   }

  //   String statusText = statusValue == 1 ? "Completed" : "UnCompleted";
  //   Color statusColor = statusValue == 1 ? Colors.green : Colors.orange;

  //   return Container(
  //     margin: EdgeInsets.only(bottom: 20),
  //     padding: EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           clinicName,
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 5),
  //         Row(
  //           children: [
  //             Icon(Icons.circle, size: 12, color: statusColor),
  //             SizedBox(width: 5),
  //             Text(statusText, style: TextStyle(color: statusColor)),
  //           ],
  //         ),
  //         Divider(height: 30),
  //         Row(
  //           children: [
  //             Icon(Icons.calendar_today, size: 16, color: Colors.grey),
  //             SizedBox(width: 5),
  //             Text(
  //               visit['d_start'] ?? "التاريخ غير متاح",
  //               style: TextStyle(color: Colors.grey),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: 15),
  //         SizedBox(
  //           width: double.infinity,
  //           child: ElevatedButton(
  //             onPressed: () async {
  //               // الانتظار حتى العودة من صفحة التفاصيل ثم إعادة جلب البيانات لتحديث اللون
  //               await Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => VisitDetailsPage(visitData: visit),
  //                 ),
  //               );
  //               fetchVisits(); 
  //             },
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Color(0xFF1E1E66),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //             child: Text("View", style: TextStyle(color: Colors.white)),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
//   Widget _buildVisitCard(Map visit) {
//     String clinicName = visit['gnr_m_clinics']?['name_ar'] ?? "عيادة غير معروفة";
    
//     // قراءة آمنة لقيمة الـ status
//     var rawStatus = visit['status'];
//     int statusValue = 0;
//     if (rawStatus is int) {
//       statusValue = rawStatus;
//     } else if (rawStatus is String) {
//       statusValue = int.tryParse(rawStatus) ?? (rawStatus.toLowerCase() == 'completed' ? 1 : 0);
//     } else if (rawStatus is bool) {
//       statusValue = rawStatus ? 1 : 0;
//     }

//     String statusText = statusValue == 1 ? "Completed" : "UnCompleted";
//     Color statusColor = statusValue == 1 ? Colors.green : Colors.orange;

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
//           Text(
//             clinicName,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 5),
//           Row(
//             children: [
//               Icon(Icons.circle, size: 12, color: statusColor),
//               SizedBox(width: 5),
//               Text(statusText, style: TextStyle(color: statusColor)),
//             ],
//           ),
//           Divider(height: 30),
//           Row(
//             children: [
//               Icon(Icons.calendar_today, size: 16, color: Colors.grey),
//               SizedBox(width: 5),
//               Text(
//                 visit['d_start'] ?? "التاريخ غير متاح",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//           SizedBox(height: 15),
          
//           // 🔴 التعديل هنا: استخدام Row لوضع الأزرار بجانب بعضها
//           Row(
//             children: [
//               // زر View الأساسي (يأخذ مساحة متساوية)
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: () async {
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => VisitDetailsPage(visitData: visit),
//                       ),
//                     );
//                     fetchVisits(); 
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF1E1E66),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Text("View", style: TextStyle(color: Colors.white)),
//                 ),
//               ),
              
//               // 🔴 زر التقييم يظهر فقط إذا كانت الزيارة مكتملة
//               if (statusValue == 1) ...[
//                 SizedBox(width: 10), // مسافة بين الزرين
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // استخراج IDs من كائن الزيارة القادم من الـ API
//                       // (تأكدي من أن 'doctor_id' و 'patient_id' هي نفس الأسماء القادمة من الـ API لديكِ)
//                      // 1. استخراج رقم الطبيب بشكل آمن جداً
// var rawDoctorId = visit['doctor_id'] ?? visit['doc'] ?? visit['doc_id'];
// int doctorId = 0;
// if (rawDoctorId != null) {
//   doctorId = int.tryParse(rawDoctorId.toString()) ?? (rawDoctorId is int ? rawDoctorId : 0);
// }

// // 2. استخراج رقم المريض بشكل آمن جداً
// var rawPatientId = visit['patient'] ?? visit['patient_id'];
// int patientId = 0;
// if (rawPatientId != null) {
//   patientId = int.tryParse(rawPatientId.toString()) ?? (rawPatientId is int ? rawPatientId : 0);
// }

// // 3. طباعة للتأكد قبل الإرسال
// print("🎯 سيتم التقييم - طبيب رقم: $doctorId | مريض رقم: $patientId");
//                       // استدعاء نافذة التقييم
//                       showReviewDialog(context, doctorId, patientId);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.amber, // لون مميز للتقييم
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     child: Text(
//                       "قيّم الطبيب", 
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ],
//       ),
//     );
//   }
Widget _buildVisitCard(Map visit) {
    String clinicName = visit['gnr_m_clinics']?['name_ar'] ?? "عيادة غير معروفة";
    
    // قراءة آمنة لقيمة الـ status
    var rawStatus = visit['status'];
    int statusValue = 0;
    if (rawStatus is int) {
      statusValue = rawStatus;
    } else if (rawStatus is String) {
      statusValue = int.tryParse(rawStatus) ?? (rawStatus.toLowerCase() == 'completed' ? 1 : 0);
    } else if (rawStatus is bool) {
      statusValue = rawStatus ? 1 : 0;
    }

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
          Text(
            clinicName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.circle, size: 12, color: statusColor),
              SizedBox(width: 5),
              Text(statusText, style: TextStyle(color: statusColor)),
            ],
          ),
          Divider(height: 30),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              SizedBox(width: 5),
              Text(
                visit['d_start'] ?? "التاريخ غير متاح",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 15),
          
          // 1. استخراج رقم الطبيب والمريض بشكل آمن قبل رسم الأزرار
          Builder(
            builder: (context) {
              var rawDoctorId = visit['doctor_id'] ?? visit['doc'] ?? visit['doc_id'];
              int doctorId = (rawDoctorId != null) ? (int.tryParse(rawDoctorId.toString()) ?? (rawDoctorId is int ? rawDoctorId : 0)) : 0;

              var rawPatientId = visit['patient'] ?? visit['patient_id'];
              int patientId = (rawPatientId != null) ? (int.tryParse(rawPatientId.toString()) ?? (rawPatientId is int ? rawPatientId : 0)) : 0;

              print("🎯 زيارة عيادة ($clinicName) - طبيب رقم: $doctorId | مريض رقم: $patientId");

              return Row(
                children: [
                  // زر View الأساسي (يأخذ مساحة متساوية)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VisitDetailsPage(visitData: visit),
                          ),
                        );
                        fetchVisits(); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1E1E66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text("View", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  
                  // 🔴 زر التقييم يظهر فقط إذا كانت الزيارة مكتملة ويوجد طبيب حقيقي
                  if (statusValue == 1 && doctorId > 0) ...[
                    SizedBox(width: 10), // مسافة بين الزرين
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // استدعاء نافذة التقييم
                          showReviewDialog(context, doctorId, patientId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber, // لون مميز للتقييم
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "قيّم الطبيب", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}