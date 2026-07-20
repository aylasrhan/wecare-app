import 'package:flutter/material.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/auth/login/data/models/user_model.dart'; // تأكدي من مسار الـ AuthService الصحيح لديكِ

class DoctorTodayAppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor's Today Appointments"),
        backgroundColor: Color(0xFF1E1E66),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Schedule",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            // هنا قمنا باستبدال الـ Expanded القديمة بالـ FutureBuilder
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: AuthService().getDoctorTodayAppointments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('خطأ: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('لا توجد مواعيد اليوم'));
                  }

                  final appointments = snapshot.data!;

                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final item = appointments[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF1E1E66),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            'موعد للمريض رقم: ${item['appointment_for'] ?? 'غير معروف'}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('الساعة: ${item['time'] ?? ''}'),
                          trailing: Chip(
                            label: Text(
                              'التاريخ: ${item['appointment_date'] ?? ''}',
                              style: TextStyle(color: Colors.green),
                            ),
                            backgroundColor: Colors.green.withOpacity(0.1),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}