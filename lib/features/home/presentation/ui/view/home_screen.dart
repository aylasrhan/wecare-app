
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/features/home/presentation/ui/view/appointments_page.dart';
import 'package:wecare/features/home/presentation/ui/view/details_eyes.dart';
import 'package:wecare/features/home/presentation/ui/view/details_physical.dart';
import 'package:wecare/features/home/presentation/ui/view/doctor_profile_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/medical_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/more_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/search_result_page.dart';
import 'package:wecare/features/home/presentation/ui/view/visit_screen.dart'; // تأكدي من مسار ملف الزيارات

class HomeScreenPage extends StatefulWidget {
  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  int _currentIndex = 0;

  // قائمة الصفحات
  final List<Widget> _pages = [
    HomePageContent(),
    VisitsPage(),
    MedicalPage(), 
    MorePage(), // MorePage
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF1E1E66),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Visits"),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Medical"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
    );
  }
}

// كود محتوى الصفحة الرئيسية (بدون الـ Scaffold والـ NavBar)
class HomePageContent extends StatefulWidget {
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List famousDoctors = [];
  List clinics = [];
  bool isLoading = true;
  final String baseUrl = "http://10.0.2.2:8000/api";
  @override
  void initState() {
    super.initState();
    fetchClinics();
    fetchFamousDoctors();
  }
  // هذه الدالة وظيفتها جلب التوكين المحفوظ في ذاكرة الهاتف
Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_token');
}
  Future<void> fetchFamousDoctors() async {
  String? token = await getToken();
  
  try {
    // تأكدي أن baseUrl ينتهي بـ /api
    final response = await http.get(
      Uri.parse('$baseUrl/famous_doctors'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // نستخدم utf8.decode لتجنب مشاكل الحروف العربية
      String responseString = utf8.decode(response.bodyBytes, allowMalformed: true);
      
      // نتحقق إذا كان الرد هو JSON وليس HTML
      if (responseString.trim().startsWith('{')) {
        var data = json.decode(responseString);
        setState(() {
          famousDoctors = data['data']; 
        });
        print("تم جلب الأطباء بنجاح: ${famousDoctors.length} طبيب");
      } else {
        print("خطأ: السيرفر أرسل HTML وليس JSON. الرابط قد يكون خاطئاً.");
      }
    } else {
      print("فشل الاتصال، كود الحالة: ${response.statusCode}");
    }
  } catch (e) {
    print("خطأ في جلب الأطباء: $e");
  }
}

Future<void> fetchClinics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clinics'));
      
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        
        setState(() {
          if (jsonResponse['data'] != null) {
            clinics = jsonResponse['data'];
          } else {
            clinics = [];
          }
          isLoading = false;
        });
        print("تم تحديث قائمة العيادات: ${clinics.length} عيادة");
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    print("عدد العيادات الموجودة حالياً: ${clinics.length}");
    return SafeArea(
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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultPage())),
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
            // Horizontal Categories (الآن ديناميكي)
            Container(
              height: 120,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: clinics.length,
                      itemBuilder: (context, index) {
                        // return _buildCategoryTile(context, clinics[index]['name_ar']);
                        return _buildCategoryTile(context, clinics[index]);
                      },
                    ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Popular Doctor", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("View all", style: TextStyle(color: Color(0xFF1E1E66), fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 15),
            _buildDoctorCard(context),
            SizedBox(height: 25),
            Text("Upcoming Appointment", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            _buildAppointmentCard(context),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

 

  Widget _buildDoctorCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorProfileScreen())),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
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
                  Row(children: [Icon(Icons.star, color: Colors.lightBlue, size: 20), SizedBox(width: 5), Text("1.25", style: TextStyle(fontWeight: FontWeight.bold))]),
                ],
              ),
            ),
            Icon(Icons.chat_bubble_outline, color: Color(0xFF1E1E66)),
          ],
        ),
      ),
    );
  }
Widget _buildCategoryTile(BuildContext context, Map clinic) { // استقبال الـ clinic بالكامل وليس فقط العنوان
  return GestureDetector(
    onTap: () {
      // هنا نقوم بالتنقل ونمرر الـ id والاسم ديناميكياً
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => DetailsEyeScreen(
            clinicId: clinic['id'], 
            clinicName: clinic['name_ar']
          )
        )
      );
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
        child: Text(
          clinic['name_ar'], // عرض الاسم من الـ Map
          textAlign: TextAlign.center, 
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
        )
      ),
    ),
  );
}
  Widget _buildAppointmentCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentsPage())),
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(radius: 25, backgroundColor: Colors.blue.shade200, child: Icon(Icons.person)),
                SizedBox(width: 15),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("samer ali", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text("samerali@gmail.com", style: TextStyle(color: Colors.grey, fontSize: 12))])),
                Icon(Icons.more_vert),
              ],
            ),
            Divider(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [Icon(Icons.access_time, size: 18, color: Colors.grey), SizedBox(width: 5), Text("2023-08-23", style: TextStyle(color: Colors.black87))]),
                Icon(Icons.info_outline, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }   }
