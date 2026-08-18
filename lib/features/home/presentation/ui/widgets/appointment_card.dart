// import 'package:flutter/material.dart';
// import 'package:wecare/features/home/presentation/ui/view/appointments_page.dart';

// class AppointmentCard extends StatelessWidget {
//   final dynamic appointment;

//   const AppointmentCard({super.key, required this.appointment});

//   @override
//   Widget build(BuildContext context) {
//     // 1. جلب اسم الطبيب ديناميكياً
//     // String doctorName = "طبيب غير محدد";
//     // if (appointment['doctor'] != null && appointment['doctor']['name'] != null) {
//     //   doctorName = appointment['doctor']['name'];
//     // } else if (appointment['doctor_name'] != null) {
//     //   doctorName = appointment['doctor_name'];
//     // }
//     print("APPOINTMENT DATA: $appointment");
// // 1. جلب اسم الطبيب ديناميكياً بدقة تامة
//    // 1. جلب اسم الطبيب ديناميكياً بكل الاحتمالات الممكنة
//     String doctorName = "طبيب غير محدد";
    
//     if (appointment['doctor'] != null) {
//       doctorName = appointment['doctor']['name_ar'] ?? appointment['doctor']['name'] ?? appointment['doctor']['name_en'] ?? "طبيب غير محدد";
//     } else if (appointment['doctor_info'] != null) {
//       doctorName = appointment['doctor_info']['name_ar'] ?? "طبيب غير محدد";
//     } else if (appointment['doctor_name'] != null) {
//       doctorName = appointment['doctor_name'];
//     } else if (appointment['name_ar'] != null) {
//       doctorName = appointment['name_ar'];
//     }
//     // 2. جلب التاريخ والوقت
//     String appointmentDate = appointment['appointment_date']?.toString() ?? "";
//     String appointmentTime = appointment['time']?.toString() ?? 
//                              appointment['available_slot']?.toString() ?? 
//                              appointment['available_time']?.toString() ?? "";
    
//     String fullDateTime = "$appointmentDate  $appointmentTime".trim();
//     if (fullDateTime.isEmpty) {
//       fullDateTime = "موعد قادم";
//     }

//     // 🔴 3. استخراج حالة الموعد (0 = معلق، 1 = مؤكد)
//     int status = appointment['status'] ?? 0;

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) =>  AppointmentsPage()),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
//         ),
//         child: Row(
//           children: [
//             const CircleAvatar(
//               radius: 25,
//               backgroundColor: Color(0xFFE8EAF6),
//               child: Icon(Icons.person, color: Color(0xFF1E1E66)),
//             ),
//             const SizedBox(width: 15),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctorName,
//                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       const Icon(Icons.calendar_today, size: 14, color: Color(0xFF1E1E66)),
//                       const SizedBox(width: 6),
//                       Text(
//                         fullDateTime,
//                         style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             // 🔴 4. إضافة العلامة (Badge) بناءً على الحالة
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               decoration: BoxDecoration(
//                 color: status == 0 ? Colors.orange.shade50 : Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: status == 0 ? Colors.orange.shade200 : Colors.green.shade200,
//                 )
//               ),
//               child: Text(
//                 status == 0 ? "قيد الانتظار" : "مؤكد",
//                 style: TextStyle(
//                   color: status == 0 ? Colors.orange : Colors.green,
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:wecare/features/home/presentation/ui/view/appointments_page.dart';
import 'package:wecare/features/home/presentation/ui/view/video_call_screen.dart';
// 🔴 لا تنسي استيراد صفحة الفيديو التي أنشأتيها:
// import 'video_call_screen.dart'; 

class AppointmentCard extends StatelessWidget {
  final dynamic appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    print("APPOINTMENT DATA: $appointment");

    String doctorName = "طبيب غير محدد";
    if (appointment['doctor'] != null) {
      doctorName = appointment['doctor']['name_ar'] ?? appointment['doctor']['name'] ?? appointment['doctor']['name_en'] ?? "طبيب غير محدد";
    } else if (appointment['doctor_info'] != null) {
      doctorName = appointment['doctor_info']['name_ar'] ?? "طبيب غير محدد";
    } else if (appointment['doctor_name'] != null) {
      doctorName = appointment['doctor_name'];
    } else if (appointment['name_ar'] != null) {
      doctorName = appointment['name_ar'];
    }

    String appointmentDate = appointment['appointment_date']?.toString() ?? "";
    String appointmentTime = appointment['time']?.toString() ?? 
                             appointment['available_slot']?.toString() ?? 
                             appointment['available_time']?.toString() ?? "";
    
    String fullDateTime = "$appointmentDate  $appointmentTime".trim();
    if (fullDateTime.isEmpty) {
      fullDateTime = "موعد قادم";
    }

    int status = appointment['status'] ?? 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AppointmentsPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Color(0xFFE8EAF6),
              child: Icon(Icons.person, color: Color(0xFF1E1E66)),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Color(0xFF1E1E66)),
                      const SizedBox(width: 6),
                      Text(
                        fullDateTime,
                        style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 🔴 4. زر المكالمة يظهر فقط إذا كان الموعد مؤكداً (status == 1)
            if (status == 1) ...[
              IconButton(
                icon: const Icon(Icons.videocam, color: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallScreen(
                        appointmentId: appointment['id'].toString(),
                        userName: "مريض", // يمكنك استبداله باسم المريض الحقيقي إن وجد
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 5),
            ],

            // 5. الـ Container الخاص بالحالة (Badge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: status == 0 ? Colors.orange.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: status == 0 ? Colors.orange.shade200 : Colors.green.shade200,
                )
              ),
              child: Text(
                status == 0 ? "قيد الانتظار" : "مؤكد",
                style: TextStyle(
                  color: status == 0 ? Colors.orange : Colors.green,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}