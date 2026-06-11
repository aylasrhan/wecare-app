// import 'package:flutter/material.dart';


// class SearchResultPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Search result"), elevation: 0),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // حقل البحث
//           TextField(
//   decoration: InputDecoration(
//     hintText: "Search about doctor",
//     // استخدمنا suffixIcon لتظهر الأيقونة على اليمين
//     suffixIcon: IconButton(
//       icon: Icon(Icons.search),
//       onPressed: () {
//         // ضع هنا الكود الخاص بعملية البحث أو الانتقال لصفحة النتائج
//         print("تم الضغط على أيقونة البحث");
//       },
//     ),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(15),
//     ),
//     contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//   ),
// ),
//             SizedBox(height: 20),
//             Text("38 Available Doctors", style: TextStyle(fontWeight: FontWeight.bold)),
//             SizedBox(height: 15),
//             // القائمة
//             Expanded(
//               child: ListView(
//                 children: [
//                   DoctorResultCard(doctorName: "samer ali", specialty: "Ophthalmology", rating: "4.8", fee: "20"),
//                   // يمكنك إضافة المزيد هنا
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//   Widget _buildDoctorSearchResultCard() {
//     return Container(
//       // تنسيق بطاقة النتيجة كما في الصورة
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(radius: 25, backgroundColor: Colors.blue),
//               SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("samer ali", style: TextStyle(fontWeight: FontWeight.bold)),
//                   Text("Textarea"),
//                   Row(children: [Icon(Icons.star, color: Colors.blue, size: 16), Text("4.8")]),
//                 ],
//               ),
//             ],
//           ),
//           Divider(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text("Fee Starts from \$20"),
//               ElevatedButton(onPressed: () {}, child: Text("Book Now")),
//             ],
//           ),
//         ],
//       ),
//     );
//   }


// class DoctorResultCard extends StatelessWidget {
//   final String doctorName;
//   final String specialty;
//   final String rating;
//   final String fee;

//   const DoctorResultCard({
//     required this.doctorName,
//     required this.specialty,
//     required this.rating,
//     required this.fee,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 15),
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(radius: 30, backgroundColor: Colors.blue.shade100, child: Icon(Icons.person, color: Colors.blue)),
//               SizedBox(width: 15),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(doctorName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                   Text(specialty, style: TextStyle(color: Colors.grey)),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: Colors.blue, size: 16),
//                       Text(" $rating", style: TextStyle(fontWeight: FontWeight.bold)),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           Divider(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Fee Starts from", style: TextStyle(fontSize: 12, color: Colors.grey)),
//                   Text("\$$fee", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF1E1E66),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: Text("Book Now"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Search result", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حقل البحث
            TextField(
              decoration: InputDecoration(
                hintText: "Search about doctor",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Color(0xFF1E1E66)),
                  onPressed: () {
                    // هنا ستقوم لاحقاً باستدعاء وظيفة البحث من MySQL
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            Text("38 Available Doctors", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 15),
            
            // القائمة - تم استخدام الكلاس المنظم
            Expanded(
              child: ListView(
                children: [
                  DoctorResultCard(
                    doctorName: "samer ali", 
                    specialty: "Ophthalmology", 
                    rating: "4.8", 
                    fee: "20"
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// الكلاس الخاص ببطاقة الطبيب (مستقل ونظيف)
class DoctorResultCard extends StatelessWidget {
  final String doctorName;
  final String specialty;
  final String rating;
  final String fee;

  const DoctorResultCard({
    required this.doctorName,
    required this.specialty,
    required this.rating,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 30, backgroundColor: Colors.blue.shade100, child: Icon(Icons.person, color: Colors.blue)),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctorName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(specialty, style: TextStyle(color: Colors.grey)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.blue, size: 16),
                      Text(" $rating", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Fee Starts from", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text("\$$fee", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E1E66),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("Book Now"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}