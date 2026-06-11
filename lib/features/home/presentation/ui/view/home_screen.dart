// import 'package:flutter/material.dart';
// import 'package:wecare/features/home/presentation/ui/view/details_eyes.dart';
// import 'package:wecare/features/home/presentation/ui/view/details_physical.dart';
// import 'package:wecare/features/home/presentation/ui/view/doctor_profile_screen.dart';
// import 'package:wecare/features/home/presentation/ui/view/search_result_page.dart';

// class HomeScreenPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: Color(0xFF1E1E66),
//         unselectedItemColor: Colors.grey,
//         currentIndex: 0,
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Visits"),
//           BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Medical"),
//           BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 20),
//               // Header: Title and Notification
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Find your", style: TextStyle(fontSize: 24, color: Colors.black54)),
//                       Text("Specialist", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
//                     ],
//                   ),
//                   Icon(Icons.notifications_none, size: 30, color: Color(0xFF1E1E66)),
//                 ],
//               ),
              
//               SizedBox(height: 25),
              
//               // Search Bar
//               // Container(
//               //   decoration: BoxDecoration(
//               //     color: Colors.grey[100],
//               //     borderRadius: BorderRadius.circular(15),
//               //   ),
//               //   child: TextField(
//               //     decoration: InputDecoration(
//               //       hintText: "Search doctor...",
//               //       prefixIcon: Icon(Icons.search, color: Color(0xFF1E1E66)),
//               //       border: InputBorder.none,
//               //       contentPadding: EdgeInsets.symmetric(vertical: 15),
//               //     ),
//               //   ),
//               // ),
//               // في ملف الصفحة الرئيسية:
// GestureDetector(
//   onTap: () {
//     // عند الضغط على حقل البحث، انتقل لصفحة النتائج
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => SearchResultPage()),
//     );
//   },
//   child: Container(
//     padding: EdgeInsets.symmetric(horizontal: 15),
//     height: 55,
//     decoration: BoxDecoration(
//       color: Colors.grey[100],
//       borderRadius: BorderRadius.circular(15),
//     ),
//     child: Row(
//       children: [
//         Icon(Icons.search, color: Colors.grey),
//         SizedBox(width: 10),
//         Text("Search doctor...", style: TextStyle(color: Colors.grey)),
//       ],
//     ),
//   ),
// ),
              
//               SizedBox(height: 25),
              
//               // Horizontal Categories
//               Container(
//                 height: 100,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     _buildCategoryTile(context,"أذن أنف حنجرة"),
//                     _buildCategoryTile(context,"عينية"),
//                     _buildCategoryTile(context,"العلاج الفيزيائي"),
//                   ],
//                 ),
//               ),
              
//               SizedBox(height: 25),
              
//               // Popular Doctor Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Popular Doctor", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                   Text("View all", style: TextStyle(color: Color(0xFF1E1E66), fontWeight: FontWeight.bold)),
//                 ],
//               ),
              
//               SizedBox(height: 15),
              
//               // Doctor Card
//               _buildDoctorCard(context),
              
//               SizedBox(height: 25),
              
//               // Upcoming Appointment Section
//               Text("Upcoming Appointment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              
//               SizedBox(height: 15),
              
//               // Appointment Card
//               _buildAppointmentCard(),
              
//               SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

 
// Widget _buildCategoryTile(BuildContext context, String title) {
//   return GestureDetector(
//     onTap: () {
//       // التحقق من أن المستخدم ضغط على "العلاج الفيزيائي"
//       if (title == "العلاج الفيزيائي") {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => PhysiotherapyPage()),
//         );
//       }
// else if (title == "عينية") {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => DetailsEyeScreen()),
//         );
//       }    },
//     child: Container(
//       width: 110,
//       margin: EdgeInsets.only(right: 15),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Center(
//         child: Text(
//           title, 
//           textAlign: TextAlign.center, 
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
//         ),
//       ),
//     ),
//   );
// }


// // Widget لبطاقة الطبيب المشهور
// Widget _buildDoctorCard() {
//   return GestureDetector( // أضفنا هذا السطر
//     onTap: () {
//       // هنا يتم الانتقال لصفحة البروفايل عند الضغط على الكارد
//      Navigator.push(
//         context, // الآن سيعرف الكود ما هو الـ context
//         MaterialPageRoute(builder: (context) => DoctorProfileScreen()),
//       );
//     },
//     child: Container(
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(radius: 35, backgroundColor: Colors.blue.shade100, child: Icon(Icons.person, size: 40)),
//           SizedBox(width: 15),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("samer ali", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text("Ophthalmology", style: TextStyle(color: Colors.grey)),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Icon(Icons.star, color: Colors.lightBlue, size: 20),
//                     SizedBox(width: 5),
//                     Text("1.25", style: TextStyle(fontWeight: FontWeight.bold)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Icon(Icons.chat_bubble_outline, color: Color(0xFF1E1E66)),
//         ],
//       ),
//     ),
//   );
// }
//   // Widget لبطاقة الموعد القادم
//   Widget _buildAppointmentCard() {
//     return Container(
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(radius: 25, backgroundColor: Colors.blue.shade200, child: Icon(Icons.person)),
//               SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("samer ali", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     Text("samerali@gmail.com", style: TextStyle(color: Colors.grey, fontSize: 12)),
//                   ],
//                 ),
//               ),
//               Icon(Icons.more_vert),
//             ],
//           ),
//           Divider(height: 25),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.access_time, size: 18, color: Colors.grey),
//                   SizedBox(width: 5),
//                   Text("2023-08-23", style: TextStyle(color: Colors.black87)),
//                 ],
//               ),
//               Icon(Icons.info_outline, color: Colors.grey),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:wecare/features/home/presentation/ui/view/details_eyes.dart';
import 'package:wecare/features/home/presentation/ui/view/details_physical.dart';
import 'package:wecare/features/home/presentation/ui/view/doctor_profile_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/search_result_page.dart';

class HomeScreenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF1E1E66),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Visits"),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Medical"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Find your", style: TextStyle(fontSize: 24, color: Colors.black54)),
                      Text("Specialist", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                  Icon(Icons.notifications_none, size: 30, color: Color(0xFF1E1E66)),
                ],
              ),
              SizedBox(height: 25),
              // Search Bar
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultPage()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 55,
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 10),
                      Text("Search doctor...", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),
              // Horizontal Categories
              Container(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryTile(context, "أذن أنف حنجرة"),
                    _buildCategoryTile(context, "عينية"),
                    _buildCategoryTile(context, "العلاج الفيزيائي"),
                  ],
                ),
              ),
              SizedBox(height: 25),
              // Popular Doctor Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Popular Doctor", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("View all", style: TextStyle(color: Color(0xFF1E1E66), fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 15),
              // Doctor Card
              _buildDoctorCard(context),
              SizedBox(height: 25),
              // Upcoming Appointment Section
              Text("Upcoming Appointment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              _buildAppointmentCard(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        if (title == "العلاج الفيزيائي") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PhysiotherapyPage()));
        } else if (title == "عينية") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsEyeScreen()));
        }
      },
      child: Container(
        width: 110,
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorProfileScreen()));
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 35, backgroundColor: Colors.blue.shade100, child: Icon(Icons.person, size: 40)),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("samer ali", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Ophthalmology", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.lightBlue, size: 20),
                      SizedBox(width: 5),
                      Text("1.25", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chat_bubble_outline, color: Color(0xFF1E1E66)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 25, backgroundColor: Colors.blue.shade200, child: Icon(Icons.person)),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("samer ali", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("samerali@gmail.com", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.more_vert),
            ],
          ),
          Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 18, color: Colors.grey),
                  SizedBox(width: 5),
                  Text("2023-08-23", style: TextStyle(color: Colors.black87)),
                ],
              ),
              Icon(Icons.info_outline, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}