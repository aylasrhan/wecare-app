import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/features/doctor/presentation/ui/view/add_diagnosis_screen.dart'; // تأكد من إضافة حزمة http في pubspec.yaml

class PatientProfileScreen extends StatefulWidget {
  final int patientId; // استقبال رقم المريض عند الضغط على الزر
  final int visitId;
  const PatientProfileScreen({
    super.key,
    required this.patientId,
    required this.visitId,
  });

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  String complaintText = "جاري التحميل...";
String diagnosisText = "جاري التحميل...";
  bool isLoading = true;
  Map<String, dynamic>? patientData;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchPatientProfile();
  }

  // دالة جلب بيانات المريض من الـ API
Future<void> fetchPatientProfile() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse(
        'http://10.0.2.2:8000/api/patient/profile?patient_id=${widget.patientId}',
      ),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print("🚀 رد السيرفر: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true || jsonResponse['error'] == 'D00') {
        setState(() {
          patientData = jsonResponse['patient_profile'] ?? jsonResponse['data'];

          // 🔴 التعديل الجديد: استخراج آخر شكاية
          List complaints = patientData?['complaints'] ?? [];
          if (complaints.isNotEmpty) {
            complaintText = complaints.last['val']; 
          } else {
            complaintText = "لا توجد شكاية مسجلة";
          }

          // 🔴 التعديل الجديد: استخراج آخر تشخيص
          List diagnoses = patientData?['diagnoses'] ?? [];
          if (diagnoses.isNotEmpty) {
            diagnosisText = diagnoses.last['val']; 
          } else {
            diagnosisText = "لا يوجد تشخيص مسجل";
          }

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage =
              jsonResponse['msg'] ?? jsonResponse['message'] ?? "فشل في جلب البيانات";
          isLoading = false;
        });
      }
    } else if (response.statusCode == 401) {
      setState(() {
        errorMessage = "الجلسة غير صالحة أو التوكن مفقود، يرجى تسجيل الدخول مجدداً.";
        isLoading = false;
      });
    } else {
      setState(() {
        errorMessage = "خطأ في الاتصال بالخادم: ${response.statusCode}";
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      errorMessage = "حدث خطأ ما: $e";
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "ملف المريض",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. القسم الأول: المعلومات الأساسية
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade200, blurRadius: 5),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 35,
                          backgroundColor: Colors.blueGrey,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patientData?['full_name'] ?? "غير معروف",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "العمر: ${patientData?['age'] ?? '-'} | الجنس: ${patientData?['sex'] ?? '-'}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "زمرة الدم: ${patientData?['blood'] ?? 'غير متوفرة'}",
                              style: TextStyle(
                                color: Colors.red[400],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. القسم الثاني: المعلومات الطبية والشكاية
                  const Text(
                    "المعلومات الطبية",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // _buildInfoTile(
                  //   title: "الشكاية الرئيسية",
                  //   content:
                  //       (patientData?['complaints'] != null &&
                  //           (patientData?['complaints'] as List).isNotEmpty)
                  //       ? patientData!['complaints'][0]['val'] ??
                  //             "لا يوجد ملاحظات"
                  //       : "لا توجد شكاية مسجلة",
                  // ),
                  _buildInfoTile(
  title: "الشكاية الرئيسية",
  content: complaintText, // 🔴 تمرير المتغير الجاهز مباشرة بدون أي شروط إضافية
),
                  const SizedBox(height: 12),
                  _buildInfoTile(
                    title: "الأمراض المزمنة",
                    content: "سجل متابعة الأمراض المزمنة متوفر بالملف الطبي",
                  ),
                  const SizedBox(height: 12),
                  _buildInfoTile(
                    title: "رقم الهاتـف",
                    content: patientData?['mobile'] ?? "لا يوجد",
                  ),
                  const SizedBox(height: 24),

                  // 3. القسم الثالث: الزيارات السابقة للمركز
                  const Text(
                    "الزيارات السابقة للمركز",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        (patientData?['diagnoses'] as List?)?.length ?? 0,
                    itemBuilder: (context, index) {
                      var diag = patientData!['diagnoses'][index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const Icon(
                            Icons.history,
                            color: Colors.blue,
                          ),
                          title: Text(
                            "تشخيص زيارة رقم: ${diag['visit'] ?? index + 1}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "التشخيص: ${diag['val'] ?? 'غير متوفر'}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // كود عرض أو تحميل التقرير
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // زر لإضافة تشخيص جديد للزيارة الحالية
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDiagnosisScreen(
                              patientId: widget
                                  .patientId, // أخذنا رقم المريض من الشاشة الحالية
                              visitId: widget
                                  .visitId, // 🔴 مؤقتاً: حطيت رقم زيارة من الداتابيز تبعك للتجريب، لاحقاً لازم نمرر رقم الزيارة الحقيقي
                            ),
                          ),
                        ).then((value) {
                          // 🔴 هذه الدالة ستعمل فور العودة من شاشة الحفظ لعمل Refresh
                          fetchPatientProfile();
                        });
                      },
                      child: const Text(
                        "إضافة تشخيص للموعد الحالي",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // أداة مساعدة لرسم مربعات المعلومات الطبية
  Widget _buildInfoTile({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
