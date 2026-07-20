
// import 'package:flutter/material.dart';

// class SearchResultPage extends StatefulWidget {
//   @override
//   _SearchResultPageState createState() => _SearchResultPageState();
// }

// class _SearchResultPageState extends State<SearchResultPage> {
//   // القائمة الكاملة والستاتيك للأطباء
//   final List<Map<String, String>> allDoctors = [
//     {
//       "doctorName": "samer ali",
//       "specialty": "Ophthalmology",
//       "rating": "4.8",
//       "fee": "20"
//     },
//     {
//       "doctorName": "Bakr Al-Rifai",
//       "specialty": "Cardiology",
//       "rating": "4.9",
//       "fee": "30"
//     },
//     {
//       "doctorName": "Ahmad Hassan",
//       "specialty": "Neurology",
//       "rating": "4.7",
//       "fee": "25"
//     },
//   ];

//   // القائمة التي ستتغير بناءً على عملية البحث
//   late List<Map<String, String>> filteredDoctors;
//   final TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     filteredDoctors = allDoctors; // بالبداية عرض الكل
//   }

//   // دالة الفلترة والبحث
//   void _filterSearch(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         filteredDoctors = allDoctors;
//       } else {
//         filteredDoctors = allDoctors.where((doctor) {
//           final name = doctor['doctorName']!.toLowerCase();
//           final specialty = doctor['specialty']!.toLowerCase();
//           final input = query.toLowerCase();
//           return name.contains(input) || specialty.contains(input);
//         }).toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Search result", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // حقل البحث التفاعلي
//             TextField(
//               controller: searchController,
//               onChanged: _filterSearch, // التحديث الفوري عند الكتابة
//               decoration: InputDecoration(
//                 hintText: "Search about doctor",
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search, color: Color(0xFF1E1E66)),
//                   onPressed: () {
//                     _filterSearch(searchController.text);
//                   },
//                 ),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
//                 contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//               ),
//             ),
//             SizedBox(height: 20),
            
//             // عدّاد الأطباء المتوفرين بناءً على نتيجة البحث
//             Text(
//               "${filteredDoctors.length} Available Doctors", 
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
//             ),
//             SizedBox(height: 15),
            
//             // القائمة أو رسالة عدم وجود نتائج
//             Expanded(
//               child: filteredDoctors.isEmpty
//                   ? Center(
//                       child: Text(
//                         "No Search Result",
//                         style: TextStyle(fontSize: 18, color: Colors.grey),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: filteredDoctors.length,
//                       itemBuilder: (context, index) {
//                         final doc = filteredDoctors[index];
//                         return DoctorResultCard(
//                           doctorName: doc['doctorName']!,
//                           specialty: doc['specialty']!,
//                           rating: doc['rating']!,
//                           fee: doc['fee']!,
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // الكلاس الخاص ببطاقة الطبيب (كما هو تماماً بدون تغيير)
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
//                 child: Text("Book Now", style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SearchResultPage extends StatefulWidget {

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
    final String baseUrl = "http://10.0.2.2:8000/api/";

  List<dynamic> filteredDoctors = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();

  // دالة البحث عبر الـ API بالاعتماد على POST و Token
  Future<void> _filterSearch(String query) async {
  if (query.isEmpty) {
    setState(() {
      filteredDoctors = [];
      isLoading = false;
    });
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    final url = Uri.parse("${baseUrl}search"); 

    // 1. جلب التوكن المخزن عند تسجيل الدخول
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('user_token') ?? ''; 

    print("التوكن المستخدم حالياً: $token"); // للتأكد في الـ Console هل التوكن موجود أم فارغ؟

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // 2. إرسال التوكن مع الطلب بصورة إجبارية
      },
      body: json.encode({
        'val': query, // المفتاح الذي ينتظره الـ Controller في الـ Laravel
      }),
    );

    print("الرد من السيرفر للبحث: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      
      setState(() {
        filteredDoctors = responseData['doctors'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        filteredDoctors = [];
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    print("Error: $e");
  }
}
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
            TextField(
              controller: searchController,
              onChanged: _filterSearch,
              decoration: InputDecoration(
                hintText: "Search about doctor",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Color(0xFF1E1E66)),
                  onPressed: () {
                    _filterSearch(searchController.text);
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            
            if (isLoading)
              Center(child: CircularProgressIndicator())
            else ...[
              if (filteredDoctors.isNotEmpty) ...[
                Text(
                  "${filteredDoctors.length} Available Doctors", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                ),
                SizedBox(height: 15),
              ],
              
              Expanded(
                child: searchController.text.isEmpty
                    ? Center(
                        child: Text(
                          "Please search for a doctor by name or specialty",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : filteredDoctors.isEmpty
                        ? Center(
                            child: Text(
                              "No Search Result",
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final doc = filteredDoctors[index];
                              return DoctorResultCard(
                                doctorName: doc['name_ar'] ?? '',
                                specialty: doc['specialization_ar'] ?? 'General',
                                rating: doc['total_rate']?.toString() ?? '4.8',
                                fee: "20",
                              );
                            },
                          ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

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
                child: Text("Book Now", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}