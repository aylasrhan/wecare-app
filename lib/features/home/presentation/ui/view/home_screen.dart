import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/home/presentation/ui/view/appointments_page.dart';
import 'package:wecare/features/home/presentation/ui/view/details_eyes.dart';
import 'package:wecare/features/home/presentation/ui/view/doctor_profile_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/medical_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/more_screen.dart';
import 'package:wecare/features/home/presentation/ui/view/search_result_page.dart';
import 'package:wecare/features/home/presentation/ui/view/visit_screen.dart';
import 'package:wecare/model/doctor_model.dart';

class HomeScreenPage extends StatefulWidget {
  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePageContent(),
    VisitsPage(),
    MedicalPage(),
    MorePage(),
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
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Visits",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: "Medical",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List famousDoctors = [];
  List clinics = [];
  bool isLoading = true;
  final String baseUrl = "http://10.0.2.2:8000/api";
List upcomingAppointments = [];
  @override
  void initState() {
    super.initState();
    fetchClinics();
    fetchFamousDoctors();
    fetchAppointments();
  }
// في ملف الـ Home
Future<void> fetchAppointments() async {
  try {
    // إنشاء كائن من AuthService
    AuthService authService = AuthService();
    
    // استدعاء الدالة الصحيحة التي كتبناها في الـ AuthService
    List<dynamic> appointments = await authService.getPatientAppointments();
    
    setState(() {
      upcomingAppointments = appointments; // الآن هذه القائمة ستحتوي على البيانات الصحيحة
      print("عدد المواعيد التي وصلت من السيرفر: ${upcomingAppointments.length}");
    });
  } catch (e) {
    print("Error fetching appointments: $e");
  }
}


  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  Future<void> fetchFamousDoctors() async {
    String? token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/famous_doctors'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(
          utf8.decode(response.bodyBytes, allowMalformed: true),
        );
        setState(() => famousDoctors = data['data']);
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchClinics() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/clinics'));
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          clinics = jsonResponse['data'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Find your",
                      style: TextStyle(fontSize: 24, color: Colors.black54),
                    ),
                    Text(
                      "Specialist",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.notifications_none,
                  size: 30,
                  color: Color(0xFF1E1E66),
                ),
              ],
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchResultPage()),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      "Search doctor...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              height: 120,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: clinics.length,
                      itemBuilder: (context, index) =>
                          _buildCategoryTile(clinics[index]),
                    ),
            ),
            SizedBox(height: 25),
            Text(
              "Popular Doctor",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: famousDoctors.length,
              itemBuilder: (context, index) =>
                  _buildDoctorCard(famousDoctors[index]),
            ),
            SizedBox(height: 25),
            Text(
              "Upcoming Appointment",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            // _buildAppointmentCard(context,upcomingAppointments[index]),
           upcomingAppointments.isEmpty 
  ? Text("لا توجد مواعيد قادمة") 
  : ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: upcomingAppointments.length,
      itemBuilder: (context, index) => _buildAppointmentCard(context, upcomingAppointments[index]),
    ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(Map doctor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorProfileScreen(
              doctor: Doctor.fromJson(Map<String, dynamic>.from(doctor)),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person, size: 40),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor['name_ar'] ?? "غير معروف",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    doctor['specialization_ar'] ?? "طبيب",
                    style: TextStyle(color: Colors.grey),
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

  Widget _buildCategoryTile(Map clinic) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsEyeScreen(
            clinicId: clinic['id'],
            clinicName: clinic['name_ar'],
          ),
        ),
      ),
      child: Container(
        width: 110,
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(clinic['name_ar'], textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(BuildContext context,dynamic appointment) {
    // String doctorName = appointment['doctor_name'] ?? "غير معروف";
    String doctorName = appointment['doctor_name']?.toString() ?? "طبيب غير معروف";
    // String clinicName = appointment['gnr_m_clinics']?['name_ar'] ?? "غير معروف";
  // String dateTime = appointment['d_start'] ?? "غير محدد";
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppointmentsPage()),
      ),
      child: Container(
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
                CircleAvatar(radius: 25, child: Icon(Icons.person)),
                SizedBox(width: 15),
                
                                Text(doctorName),

              ],
            ),
            Divider(height: 25),
      
          ],
        ),
      ),
    );
  }
}
