
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/doctor/presentation/ui/widgets/confirmed_appointment_card.dart';
import 'package:wecare/features/doctor/presentation/ui/widgets/pending_appointment_card.dart';

import 'package:wecare/features/onboarding/presentation/ui/view/onboadring_contener/role_selection_page.dart';
 
class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() => _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, 
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RoleSelectionPage()), 
          (route) => false,
        );
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              "إدارة المواعيد",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp), 
            ),
            centerTitle: true,
            bottom: TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold), 
              unselectedLabelStyle: TextStyle(fontSize: 14.sp),
              tabs: const [
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
                return Center(child: Text('خطأ: ${snapshot.error}', style: TextStyle(fontSize: 16.sp))); 
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('لا توجد مواعيد مسجلة', style: TextStyle(fontSize: 16.sp))); 
              }

              final appointments = snapshot.data!;

              final pendingAppointments = appointments.where((item) => item['status'] == 0).toList();
              final confirmedAppointments = appointments.where((item) => item['status'] == 1).toList();

              return TabBarView(
                children: [
                  pendingAppointments.isEmpty 
                    ? Center(child: Text('لا توجد طلبات معلقة', style: TextStyle(color: Colors.grey, fontSize: 16.sp))) 
                    : ListView.builder(
                        padding: EdgeInsets.all(16.w), 
                        itemCount: pendingAppointments.length,
                        itemBuilder: (context, index) {
                          final item = pendingAppointments[index];
                          return PendingAppointmentCard(
                            item: item as Map<String, dynamic>,
                            onActionCompleted: () => setState(() {}),     
                          );
                        },
                      ),
                  
                  confirmedAppointments.isEmpty
                    ? Center(child: Text('لا توجد مواعيد مؤكدة', style: TextStyle(color: Colors.grey, fontSize: 16.sp))) 
                    : ListView.builder(
                        padding: EdgeInsets.all(16.w), 
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
      ),
    );
  }
}