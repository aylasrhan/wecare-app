
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/home/visits/presentation/ui/widgets/visit_clinicinf_section.dart';
import 'package:wecare/features/home/visits/presentation/ui/widgets/visit_dignoses_section.dart';
import 'package:wecare/features/home/visits/presentation/ui/widgets/visit_invoice_section.dart';
import 'package:wecare/features/home/visits/presentation/ui/widgets/visit_note_section.dart';
import 'package:wecare/features/home/visits/presentation/ui/widgets/visit_prescription_section.dart';
import 'package:wecare/features/home/visits/presentation/ui/widgets/visit_vital_section.dart'; 


class VisitDetailsPage extends StatelessWidget {
  final Map visitData;

  const VisitDetailsPage({super.key, required this.visitData});

  @override
  Widget build(BuildContext context) {
    final clinics = visitData['gnr_m_clinics'];
    final clinicName = (clinics is Map) ? (clinics['name_ar']?.toString() ?? 'غير معروف') : 'غير معروف';
    final visitDate = visitData['d_start']?.toString() ?? '';
    final invoice = visitData['invoice'];
    final notesList = visitData['cln_x_prev_not'];
    final diagnosesList = visitData['cln_x_prev_dia'] ?? visitData['diagnoses'] ?? visitData['icd10'] ?? visitData['diagnoses_list'];    
    final vitals = visitData['vitals'];
    final prescription = visitData['issued_prescription'];

    List prescriptionItems = [];
    if (prescription is Map) {
      prescriptionItems = prescription['items'] ?? prescription['prescription_items'] ?? prescription['details'] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل الزيارة", style: TextStyle(color: Colors.black, fontSize: 20.sp)), 
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 24.sp), 
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VisitClinicInfoCard(clinicName: clinicName, visitDate: visitDate),
            SizedBox(height: 20.h),

            VisitDiagnosesSection(diagnosesList: diagnosesList),
            SizedBox(height: 20.h),

            VisitNotesSection(notesList: notesList),
            SizedBox(height: 20.h),

            VisitPrescriptionSection(prescriptionItems: prescriptionItems, prescription: prescription),
            SizedBox(height: 20.h),

            if (vitals is Map) ...[
              VisitVitalsSection(vitals: vitals),
              SizedBox(height: 20.h),
            ],
            
            VisitInvoiceSection(invoice: invoice),
          ],
        ),
      ),
    );
  }
}