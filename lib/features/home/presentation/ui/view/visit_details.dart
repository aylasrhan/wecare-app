// import 'package:flutter/material.dart';

// class VisitDetailsPage extends StatelessWidget {
//   final Map visitData;

//   VisitDetailsPage({required this.visitData});

//   @override
//   Widget build(BuildContext context) {
//     print("Visit Data: $visitData");
//     var notesList = visitData['cln_x_prev_not'];
//     // استخراج الملاحظات أو التشخيص من العلاقات إذا كانت موجودة
//     String notes = visitData['cln_x_prev_not'] != null && (visitData['cln_x_prev_not'] as List).isNotEmpty
//         ? visitData['cln_x_prev_not'][0]['note'] ?? "لا توجد ملاحظات"
//         : "لا توجد ملاحظات";

//     return Scaffold(
//       appBar: AppBar(title: Text("تفاصيل الزيارة")),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("العيادة: ${visitData['gnr_m_clinics']?['name_ar'] ?? 'غير معروف'}", 
//                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             Text("الشكاية الرئيسية والتشخيص الطبي ", style: TextStyle(fontWeight: FontWeight.bold)),
//             (notesList != null && notesList is List && notesList.isNotEmpty)
//     ? ListView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: notesList.length,
//         itemBuilder: (context, index) {
//           return Card(
//             child: ListTile(
//               title: Text(notesList[index]['val'] ?? ""), // في جدولك الحقل اسمه val وليس note
//             ),
//           );
//         },
//       )
//     : Container(
//         margin: EdgeInsets.only(top: 10),
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//         child: Text("لا توجد ملاحظات طبية لهذه الزيارة حالياً."),
//       ),
        
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class VisitDetailsPage extends StatelessWidget {
  final Map visitData;

  VisitDetailsPage({required this.visitData});

  @override
  Widget build(BuildContext context) {
    print("Visit Data: $visitData");

    // 🔴 جلب الشكايات والملاحظات
    var notesList = visitData['cln_x_prev_not'] ?? [];
    // 🔴 جلب التشخيصات من الـ API مباشرة
    var diagnosesList = visitData['cln_x_prev_dia'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text("تفاصيل الزيارة")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "العيادة: ${visitData['gnr_m_clinics']?['name_ar'] ?? 'غير معروف'}", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 20),
            
            // --- قسم الشكايات / الملاحظات ---
            Text("الشكاية الرئيسية:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 5),
            notesList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(notesList[index]['val'] ?? ""),
                        ),
                      );
                    },
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: Text("لا توجد شكاية مسجلة لهذه الزيارة."),
                  ),

            SizedBox(height: 20),

            // --- قسم التشخيص الطبي ---
            Text("التشخيص الطبي:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 5),
            diagnosesList.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: diagnosesList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(diagnosesList[index]['val'] ?? ""),
                        ),
                      );
                    },
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                    child: Text("لا يوجد تشخيص مسجل لهذه الزيارة."),
                  ),
          ],
        ),
      ),
    );
  }
}