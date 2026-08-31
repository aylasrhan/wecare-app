import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/doctor/presentation/ui/widgets/review_dialog.dart';
import 'package:wecare/features/home/visits/presentation/ui/view/visit_details.dart';

class VisitCard extends StatelessWidget {
  final Map visit;
  final VoidCallback onRefreshNeeded;

  const VisitCard({
    super.key,
    required this.visit,
    required this.onRefreshNeeded,
  });

  @override
  Widget build(BuildContext context) {
    String clinicName = visit['gnr_m_clinics']?['name_ar'] ?? "عيادة غير معروفة";
    
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
      margin: EdgeInsets.only(bottom: 20.h), 
      padding: EdgeInsets.all(20.w), 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r), 
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10.r)], 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            clinicName,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), 
          ),
          SizedBox(height: 5.h), 
          Row(
            children: [
              Icon(Icons.circle, size: 12.sp, color: statusColor),
              SizedBox(width: 5.w), 
              Text(statusText, style: TextStyle(color: statusColor, fontSize: 14.sp)), 
            ],
          ),
          Divider(height: 30.h), 
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey), 
              SizedBox(width: 5.w),
              Text(
                visit['d_start'] ?? "التاريخ غير متاح",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp), 
              ),
            ],
          ),
          SizedBox(height: 15.h), 
          
          Builder(
            builder: (context) {
              var rawDoctorId = visit['doctor_id'] ?? visit['doc'] ?? visit['doc_id'];
              int doctorId = (rawDoctorId != null) ? (int.tryParse(rawDoctorId.toString()) ?? (rawDoctorId is int ? rawDoctorId : 0)) : 0;

              var rawPatientId = visit['patient'] ?? visit['patient_id'];
              int patientId = (rawPatientId != null) ? (int.tryParse(rawPatientId.toString()) ?? (rawPatientId is int ? rawPatientId : 0)) : 0;

              return Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VisitDetailsPage(visitData: visit),
                          ),
                        );
                        onRefreshNeeded(); 
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E66),
                        padding: EdgeInsets.symmetric(vertical: 12.h), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text("View", style: TextStyle(color: Colors.white, fontSize: 14.sp)), 
                    ),
                  ),
                  
                  if (statusValue == 1 && doctorId > 0) ...[
                    SizedBox(width: 10.w), 
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showReviewDialog(context, doctorId, patientId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber, 
                          padding: EdgeInsets.symmetric(vertical: 12.h), 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r), 
                          ),
                        ),
                        child: Text(
                          "قيّم الطبيب", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp) 
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