
import 'package:flutter/material.dart';

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
final diagnosesList = visitData['cln_x_prev_dia'] ?? visitData['diagnoses'] ?? visitData['icd10'] ?? visitData['diagnoses_list'];    final vitals = visitData['vitals'];
    final prescription = visitData['issued_prescription'];

    // محاولة جلب عناصر الأدوية من الوصفة إن وجدت بأي من المسميات المحتملة
    List prescriptionItems = [];
    if (prescription is Map) {
      prescriptionItems = prescription['items'] ?? prescription['prescription_items'] ?? prescription['details'] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الزيارة", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. معلومات العيادة والتاريخ
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E66).withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "العيادة: $clinicName",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E66)),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(visitDate, style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. التشخيص الطبي
            // const Text("التشخيص الطبي:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
            // const SizedBox(height: 8),
            // (diagnosesList is List && diagnosesList.isNotEmpty)
            //     ? ListView.builder(
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         itemCount: diagnosesList.length,
            //         itemBuilder: (context, index) {
            //           final item = diagnosesList[index];
            //           final val = (item is Map) ? (item['val']?.toString() ?? '') : '';
            //           return Card(
            //             elevation: 1,
            //             child: ListTile(
            //               leading: const Icon(Icons.medical_services, color: Colors.green),
            //               title: Text(val),
            //             ),
            //           );
            //         },
            //       )
            //     : Container(
            //         padding: const EdgeInsets.all(12),
            //         decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
            //         child: const Text("لا يوجد تشخيص مسجل لهذه الزيارة.", style: TextStyle(color: Colors.grey)),
            //       ),

// 2. التشخيص الطبي
const Text("التشخيص الطبي:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
const SizedBox(height: 8),
(diagnosesList is List && diagnosesList.isNotEmpty)
    ? ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: diagnosesList.length,
        itemBuilder: (context, index) {
          final item = diagnosesList[index];
          final val = (item is Map) 
              ? (item['name_ar'] ?? item['val'] ?? item['text'] ?? item['code']?.toString() ?? '') 
              : item.toString();
          return Card(
            elevation: 1,
            child: ListTile(
              leading: const Icon(Icons.medical_services, color: Colors.green),
              title: Text(val),
            ),
          );
        },
      )
    : Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.grey[150], borderRadius: BorderRadius.circular(10)),
        child: const Text("لا يوجد تشخيص مسجل لهذه الزيارة.", style: TextStyle(color: Colors.grey)),
      ),
            const SizedBox(height: 20),

            // 3. ملاحظات وتوصيات الطبيب
            const Text("ملاحظات وتوصيات المتابعة:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16)),
            const SizedBox(height: 8),
            (notesList is List && notesList.isNotEmpty)
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      final item = notesList[index];
                      final val = (item is Map) ? (item['val']?.toString() ?? '') : '';
                      return Card(
                        elevation: 1,
                        child: ListTile(
                          leading: const Icon(Icons.note_alt, color: Colors.blue),
                          title: Text(val),
                        ),
                      );
                    },
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                    child: const Text("لا توجد ملاحظات مسجلة لهذه الزيارة.", style: TextStyle(color: Colors.grey)),
                  ),

            const SizedBox(height: 20),

            // 4. الوصفة الطبية والأدوية
            const Text("الوصفة الطبية والأدوية:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple, fontSize: 16)),
            const SizedBox(height: 8),
            prescriptionItems.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: prescriptionItems.length,
                    itemBuilder: (context, index) {
                      final med = prescriptionItems[index];
                      final medName = med['medication_name'] ?? med['name'] ?? 'دواء';
                      final dosage = med['dosage'] ?? '';
                      final frequency = med['frequency'] ?? '';
                      final duration = med['duration'] ?? '';

                      return Card(
                        elevation: 1,
                        color: Colors.purple[50],
                        child: ListTile(
                          leading: const Icon(Icons.medication, color: Colors.purple),
                          title: Text(medName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("الجرعة: $dosage | التكرار: $frequency | المدة: $duration"),
                        ),
                      );
                    },
                  )
                : prescription != null
                    ? Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.purple.shade200),
                        ),
                        child: const Text("تم إصدار وصفة طبية بنجاح.", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                      )
                    : Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                        child: const Text("لا توجد وصفة طبية لهذه الزيارة.", style: TextStyle(color: Colors.grey)),
                      ),

            const SizedBox(height: 20),

            // 5. العلامات الحيوية
            if (vitals is Map) ...[
              const Text("العلامات الحيوية للمريض:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("الوزن: ${vitals['weight'] ?? '-'} كغ"),
                        Text("الطول: ${vitals['height'] ?? '-'} سم"),
                      ],
                    ),
                    const Divider(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("النبض: ${vitals['pulse'] ?? '-'} نبضة/د"),
                        Text("الضغط: ${vitals['systolic_pressure'] ?? '-'}/${vitals['diastolic_pressure'] ?? '-'}"),
                      ],
                    ),
                    
                  ],
                ),
              ),
            ],
            
            if (invoice != null) ...[
  const Padding(
    padding: EdgeInsets.only(top: 20),
    child: Text("معلومات الفاتورة:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 16)),
  ),
  const SizedBox(height: 8),
  Card(
    color: Colors.indigo[50],
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("الإجمالي:"),
            Text("${invoice['total'] ?? 0} ل.س", style: const TextStyle(fontWeight: FontWeight.bold)),
          ]),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("المدفوع:"),
            Text("${invoice['paid'] ?? 0} ل.س", style: const TextStyle(color: Colors.green)),
          ]),
          const Divider(),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text("المتبقي:"),
            Text("${invoice['balance'] ?? 0} ل.س", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ]),
        ],
      ),
    ),
  ),
] else ...[
  const Padding(
    padding: EdgeInsets.symmetric(vertical: 20),
    child: Text("لا توجد فاتورة مرتبطة بهذه الزيارة بعد.", style: TextStyle(color: Colors.grey)),
  ),
],
          ],
        ),
      ),
    );
  }
}