// import 'package:flutter/material.dart';

// class PhysiotherapyPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Text(
//           "العلاج الفيزيائي",
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         padding: EdgeInsets.all(15),
//         itemCount: 3, // عدد المواعيد
//         itemBuilder: (context, index) {
//           // بيانات تجريبية
//           List<String> names = ["أحمد الرفاعي", "ضياء محمد", "بكر الرفاعي"];
//           return _buildAppointmentCard(names[index]);
//         },
//       ),
//     );
//   }

//   Widget _buildAppointmentCard(String doctorName) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             // القسم العلوي: معلومات الطبيب
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 35,
//                   backgroundColor: Colors.blue[100],
//                   child: Icon(Icons.person, size: 40, color: Colors.blue[800]),
//                 ),
//                 SizedBox(width: 15),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         doctorName,
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         "العلاج الفيزيائي",
//                         style: TextStyle(color: Colors.grey[600]),
//                       ),
//                       SizedBox(height: 5),
//                       Row(
//                         children: [
//                           Icon(Icons.star, color: Colors.blue, size: 20),
//                           SizedBox(width: 5),
//                           Text(
//                             "4.8",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
            
//             SizedBox(height: 20),
//             Divider(height: 1),
//             SizedBox(height: 20),

//             // القسم الأوسط: الوقت والحالة
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
//                     SizedBox(width: 8),
//                     Text("10 Dec 2022", style: TextStyle(color: Colors.grey[700])),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.access_time, size: 18, color: Colors.grey),
//                     SizedBox(width: 8),
//                     Text("10:30 AM", style: TextStyle(color: Colors.grey[700])),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Icon(Icons.check_circle, size: 18, color: Colors.green),
//                     SizedBox(width: 5),
//                     Text("Confirmed", style: TextStyle(color: Colors.grey[700])),
//                   ],
//                 ),
//               ],
//             ),

//             SizedBox(height: 20),

//             // القسم السفلي: الأزرار
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[200],
//                       foregroundColor: Colors.black,
//                       elevation: 0,
//                       padding: EdgeInsets.symmetric(vertical: 15),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//                 SizedBox(width: 15),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color(0xFF1E1E66),
//                       foregroundColor: Colors.white,
//                       elevation: 0,
//                       padding: EdgeInsets.symmetric(vertical: 15),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: Text("Reschedule", style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// Widget _buildCategoryTile(BuildContext context, String title) { // أضف context هنا
//   return GestureDetector(
//     onTap: () {
//       if (title == "العلاج الفيزيائي") {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => PhysiotherapyPage()),
//         );
//       }
//     },
//     child: Container(
//       // ... باقي تنسيق الـ Container كما هو
//     ),
//   );
// }

