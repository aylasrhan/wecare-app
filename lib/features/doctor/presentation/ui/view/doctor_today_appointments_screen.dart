

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

            // 🎯 هنا قمنا بإضافة الفلترة حسب الـ status
            final pendingAppointments = appointments.where((item) => item['status'] == 0).toList();
            final confirmedAppointments = appointments.where((item) => item['status'] == 1).toList();

            return TabBarView(
              children: [
                // التبويب الأول: الطلبات الجديدة (المعلقة status == 0)
                pendingAppointments.isEmpty 
                  ? const Center(child: Text('لا توجد طلبات معلقة', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: pendingAppointments.length,
                      itemBuilder: (context, index) {
                        final item = pendingAppointments[index];
                        return _buildPendingAppointmentCard(context, item);
                      },
                    ),
                
                // التبويب الثاني: المواعيد المؤكدة (المقبولة status == 1)
                confirmedAppointments.isEmpty
                  ? const Center(child: Text('لا توجد مواعيد مؤكدة', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: confirmedAppointments.length, 
                      itemBuilder: (context, index) {
                        final item = confirmedAppointments[index];
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

  // بطاقة الطلب المعلق
  Widget _buildPendingAppointmentCard(BuildContext context, Map<String, dynamic> item) {
    // 1. نأخذ الاسم أو الرقم فقط
    final patientNameOrId = item['patient'] != null && item['patient']['name'] != null
        ? '${item['patient']['name']}'
        : 'رقم ${item['appointment_for'] ?? 'غير معروف'}';

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
              
              title: Text.rich(
                TextSpan(
                  text: 'المريض: ',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'), // يمكنك تغيير 'Cairo' لاسم الخط الذي تستخدمينه
                  children: [
                    TextSpan(
                      text: patientNameOrId,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
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
                    onPressed: () async {
                      bool success = await AuthService().acceptAppointment(item['id']);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم قبول الموعد بنجاح')),
                        );
                        setState(() {}); 
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('فشل قبول الموعد، حاول مرة أخرى')),
                        );
                      }
                    },
                    child: const Text("قبول", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
           
                Expanded(
  child: OutlinedButton(
    style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
    onPressed: () async {
      bool success = await AuthService().rejectAppointment(item['id']);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم رفض الموعد وإلغاؤه')),
        );
        setState(() {}); // لتحديث الشاشة وإخفاء الموعد
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('فشل رفض الموعد، حاول مرة أخرى')),
        );
      }
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

  // بطاقة الموعد المؤكد
  Widget _buildConfirmedAppointmentCard(BuildContext context, Map<String, dynamic> item) {
    // 1. نأخذ الاسم أو الرقم فقط
    final patientNameOrId = item['patient'] != null && item['patient']['name'] != null
        ? '${item['patient']['name']}'
        : 'رقم ${item['appointment_for'] ?? 'غير معروف'}';

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
           
              title: Text.rich(
                TextSpan(
                  text: 'المريض: ',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cairo'), // يمكنك تغيير 'Cairo' لاسم الخط الذي تستخدمينه
                  children: [
                    TextSpan(
                      text: patientNameOrId,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
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