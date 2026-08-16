
import 'package:flutter/material.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/doctor/presentation/ui/widgets/confirmed_appointment_card.dart';
import 'package:wecare/features/doctor/presentation/ui/widgets/pending_appointment_card.dart';
 

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

            // 🎯 فلترة البيانات
            final pendingAppointments = appointments.where((item) => item['status'] == 0).toList();
            final confirmedAppointments = appointments.where((item) => item['status'] == 1).toList();

            return TabBarView(
              children: [
                // التبويب الأول: الطلبات الجديدة
                pendingAppointments.isEmpty 
                  ? const Center(child: Text('لا توجد طلبات معلقة', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: pendingAppointments.length,
                      itemBuilder: (context, index) {
                        final item = pendingAppointments[index];
                        return PendingAppointmentCard(
                          item: item as Map<String, dynamic>,
                          onActionCompleted: () => setState(() {}), //    
                        );
                      },
                    ),
                
                confirmedAppointments.isEmpty
                  ? const Center(child: Text('لا توجد مواعيد مؤكدة', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: confirmedAppointments.length, 
                      itemBuilder: (context, index) {
                        final item = confirmedAppointments[index];
                        return ConfirmedAppointmentCard(
                          item: item as Map<String, dynamic>,
                        );
                      },
                    ),
              ],
            );
          },
        ),
      ),
    );
  }
}