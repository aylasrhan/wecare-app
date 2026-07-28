// import 'package:flutter/material.dart';
// import 'package:wecare/core/services/auth_service.dart';
// import 'package:wecare/features/auth/login/data/models/user_model.dart'; // تأكدي من مسار الـ AuthService الصحيح لديكِ

// class DoctorTodayAppointmentsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Doctor's Today Appointments"),
//         backgroundColor: Color(0xFF1E1E66),
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Today's Schedule",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
            
//             // هنا قمنا باستبدال الـ Expanded القديمة بالـ FutureBuilder
//             Expanded(
//               child: FutureBuilder<List<dynamic>>(
//                 future: AuthService().getDoctorTodayAppointments(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('خطأ: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return Center(child: Text('لا توجد مواعيد اليوم'));
//                   }

//                   final appointments = snapshot.data!;

//                   return ListView.builder(
//                     itemCount: appointments.length,
//                     itemBuilder: (context, index) {
//                       final item = appointments[index];
//                       return Card(
//                         margin: EdgeInsets.only(bottom: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 3,
//                         child: ListTile(
//                           leading: CircleAvatar(
//                             backgroundColor: Color(0xFF1E1E66),
//                             child: Icon(Icons.person, color: Colors.white),
//                           ),
//                           title: Text(
//                             'موعد للمريض رقم: ${item['appointment_for'] ?? 'غير معروف'}',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Text('الساعة: ${item['time'] ?? ''}'),
//                           trailing: Chip(
//                             label: Text(
//                               'التاريخ: ${item['appointment_date'] ?? ''}',
//                               style: TextStyle(color: Colors.green),
//                             ),
//                             backgroundColor: Colors.green.withOpacity(0.1),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'patient_profile_screen.dart'; // تأكدي من مسار شاشة الملف الشخصي للمريض

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() => _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "إدارة المواعيد",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "طلبات جديدة (معلقة)"),
              Tab(text: "مواعيد مؤكدة"),
            ],
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: AuthService().getDoctorTodayAppointments(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('خطأ: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('لا توجد مواعيد اليوم'));
            }

            final appointments = snapshot.data!;

            return TabBarView(
              children: [
                // التبويب الأول: الطلبات الجديدة (نفس البيانات الحقيقية أو المفلترة)
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final item = appointments[index];
                    return _buildPendingAppointmentCard(context, item);
                  },
                ),
                // التبويب الثاني: المواعيد المؤكدة
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: appointments.length, // يمكنك فلترتها لاحقاً حسب حالة الموعد
                  itemBuilder: (context, index) {
                    final item = appointments[index];
                    return _buildConfirmedAppointmentCard(context, item);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // بطاقة الطلب المعلق (تأخذ البيانات ديناميكياً من السيرفر)
  Widget _buildPendingAppointmentCard(BuildContext context, Map<String, dynamic> item) {
    // استخراج اسم المريض من الـ Map القادمة من السيرفر (مع قيمة افتراضية في حال عدم وضوح المفتاح)
    final patientName = item['patient'] != null && item['patient']['name'] != null
        ? 'المريض: ${item['patient']['name']}'
        : 'المريض رقم: ${item['appointment_for'] ?? 'غير معروف'}';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(patientName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("طلب استشارة إلكترونية"),
              trailing: const Text(
                "قيد الانتظار",
                style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(item['appointment_date'] ?? '')
                ]),
                Row(children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(item['time'] ?? '')
                ]),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      // كود قبول الموعد
                    },
                    child: const Text("قبول", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                    onPressed: () {
                      // كود رفض الموعد
                    },
                    child: const Text("رفض"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // كود تعديل الموعد
                },
                child: const Text("تعديل الوقت (اقتراح موعد بديل)", style: TextStyle(color: Colors.grey)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // بطاقة الموعد المؤكد (مع زر استعراض الملف الشخصي)
  Widget _buildConfirmedAppointmentCard(BuildContext context, Map<String, dynamic> item) {
    final patientName = item['patient'] != null && item['patient']['name'] != null
        ? 'المريض: ${item['patient']['name']}'
        : 'المريض رقم: ${item['appointment_for'] ?? 'غير معروف'}';

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.green.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: Colors.green,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(patientName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${item['appointment_date'] ?? ''} - ${item['time'] ?? ''}"),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.blue,
                  elevation: 0,
                ),
                icon: const Icon(Icons.folder_shared),
                label: const Text("استعراض بيانات المريض"),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const PatientProfileScreen()),
                  // );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('عرض ملف المريض رقم: ${item['appointment_for']}')),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}