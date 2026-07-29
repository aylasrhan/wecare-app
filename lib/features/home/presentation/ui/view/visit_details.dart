import 'package:flutter/material.dart';

class VisitDetailsPage extends StatelessWidget {
  final Map visitData;

  VisitDetailsPage({required this.visitData});

  @override
  Widget build(BuildContext context) {
    print("Visit Data: $visitData");
    var notesList = visitData['cln_x_prev_not'];
    // استخراج الملاحظات أو التشخيص من العلاقات إذا كانت موجودة
    String notes = visitData['cln_x_prev_not'] != null && (visitData['cln_x_prev_not'] as List).isNotEmpty
        ? visitData['cln_x_prev_not'][0]['note'] ?? "لا توجد ملاحظات"
        : "لا توجد ملاحظات";

    return Scaffold(
      appBar: AppBar(title: Text("تفاصيل الزيارة")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("العيادة: ${visitData['gnr_m_clinics']?['name_ar'] ?? 'غير معروف'}", 
                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text("ملاحظات الطبيب:", style: TextStyle(fontWeight: FontWeight.bold)),
            (notesList != null && notesList is List && notesList.isNotEmpty)
    ? ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: notesList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(notesList[index]['val'] ?? ""), // في جدولك الحقل اسمه val وليس note
            ),
          );
        },
      )
    : Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
        child: Text("لا توجد ملاحظات طبية لهذه الزيارة حالياً."),
      ),
        
          ],
        ),
      ),
    );
  }
}