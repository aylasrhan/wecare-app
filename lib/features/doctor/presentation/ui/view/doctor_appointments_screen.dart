// import 'package:flutter/material.dart';
// import 'patient_profile_screen.dart'; // سنقوم بإنشائه في الخطوة التالية

// class DoctorAppointmentsScreen extends StatelessWidget {
//   const DoctorAppointmentsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           title: const Text(
//             "إدارة المواعيد",
//             style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//           bottom: const TabBar(
//             labelColor: Colors.blue,
//             unselectedLabelColor: Colors.grey,
//             indicatorColor: Colors.blue,
//             tabs: [
//               Tab(text: "طلبات جديدة (معلقة)"),
//               Tab(text: "مواعيد مؤكدة"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             // التبويب الأول: الطلبات المعلقة (قبول، رفض، تعديل)
//             ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: 3, // عدد تجريبي للطلبات المعلقة
//               itemBuilder: (context, index) {
//                 return _buildPendingAppointmentCard(context);
//               },
//             ),
//             // التبويب الثاني: المواعيد المؤكدة
//             ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: 2, // عدد تجريبي للمواعيد المؤكدة
//               itemBuilder: (context, index) {
//                 return _buildConfirmedAppointmentCard(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // بطاقة الطلب المعلق (تحتوي على أزرار القرار)
//   Widget _buildPendingAppointmentCard(BuildContext context) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ListTile(
//               contentPadding: EdgeInsets.zero,
//               leading: const CircleAvatar(
//                 radius: 25,
//                 backgroundColor: Colors.blueAccent,
//                 child: Icon(Icons.person, color: Colors.white),
//               ),
//               title: const Text("المريض: أحمد محمود", style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: const Text("طلب استشارة إلكترونية"),
//               trailing: const Text(
//                 "قيد الانتظار",
//                 style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const Divider(),
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Row(children: [Icon(Icons.calendar_today, size: 16, color: Colors.blue), SizedBox(width: 8), Text("15 آب 2026")]),
//                 Row(children: [Icon(Icons.access_time, size: 16, color: Colors.blue), SizedBox(width: 8), Text("10:30 صباحاً")]),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // أزرار التحكم بالموعد
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                     onPressed: () {
//                       // كود قبول الموعد
//                     },
//                     child: const Text("قبول", style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
//                     onPressed: () {
//                       // كود رفض الموعد
//                     },
//                     child: const Text("رفض"),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 onPressed: () {
//                   // كود تعديل الموعد (اقتراح وقت آخر)
//                 },
//                 child: const Text("تعديل الوقت (اقتراح موعد بديل)", style: TextStyle(color: Colors.grey)),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   // بطاقة الموعد المؤكد (تحتوي على زر استعراض بيانات المريض)
//   Widget _buildConfirmedAppointmentCard(BuildContext context) {
//     return Card(
//       elevation: 1,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.green.shade200)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             ListTile(
//               contentPadding: EdgeInsets.zero,
//               leading: const CircleAvatar(
//                 radius: 25,
//                 backgroundColor: Colors.green,
//                 child: Icon(Icons.person, color: Colors.white),
//               ),
//               title: const Text("المريض: خليل إبراهيم", style: TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: const Text("15 آب 2026 - 11:00 صباحاً"),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue.shade50,
//                   foregroundColor: Colors.blue,
//                   elevation: 0,
//                 ),
//                 icon: const Icon(Icons.folder_shared),
//                 label: const Text("استعراض بيانات المريض"),
//                 onPressed: () {
//                   // الانتقال لشاشة تفاصيل المريض
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const PatientProfileScreen()),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }