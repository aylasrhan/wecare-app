
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:wecare/core/networking/api_constants.dart';
import 'package:wecare/features/doctor/presentation/ui/view/add_diagnosis_screen.dart';
import 'package:wecare/features/doctor/presentation/ui/widgets/patient_header_card.dart';
import 'package:wecare/features/doctor/presentation/ui/widgets/patient_info_tile.dart'; 

class PatientProfileScreen extends StatefulWidget {
  final int patientId; 
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

  Future<void> fetchPatientProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.get(
        ApiConstants.endpoint(
          'patient/profile',
          queryParameters: {'patient_id': widget.patientId.toString()},
        ),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (!mounted) return;
      print("🚀 رد السيرفر: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true || jsonResponse['error'] == 'D00') {
          setState(() {
            patientData = jsonResponse['patient_profile'] ?? jsonResponse['data'];

            List complaints = patientData?['complaints'] ?? [];
            if (complaints.isNotEmpty) {
              complaintText = complaints.last['val']; 
            } else {
              complaintText = "لا توجد شكاية مسجلة";
            }

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
      if (!mounted) return;
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
        title: Text(
          "ملف المريض",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp), 
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp), 
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.w), 
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PatientHeaderCard(patientData: patientData),
                      SizedBox(height: 24.h), 

                      Text(
                        "المعلومات الطبية",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), 
                      ),
                      SizedBox(height: 12.h),
                      PatientInfoTile(title: "الشكاية الرئيسية", content: complaintText),
                      SizedBox(height: 12.h),
                      const PatientInfoTile(
                        title: "الأمراض المزمنة",
                        content: "سجل متابعة الأمراض المزمنة متوفر بالملف الطبي",
                      ),
                      SizedBox(height: 12.h),
                      PatientInfoTile(
                        title: "رقم الهاتـف",
                        content: patientData?['mobile'] ?? "لا يوجد",
                      ),
                      SizedBox(height: 24.h),

                      Text(
                        "الزيارات السابقة للمركز",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold), 
                      ),
                      SizedBox(height: 12.h),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (patientData?['diagnoses'] as List?)?.length ?? 0,
                        itemBuilder: (context, index) {
                          var diag = patientData!['diagnoses'][index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 8.h), 
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)), 
                            child: ListTile(
                              leading: Icon(
                                Icons.history,
                                color: Colors.blue,
                                size: 28.sp, 
                              ),
                              title: Text(
                                "تشخيص زيارة رقم: ${diag['visit'] ?? index + 1}",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp), 
                              ),
                              subtitle: Text(
                                "التشخيص: ${diag['val'] ?? 'غير متوفر'}",
                                style: TextStyle(fontSize: 14.sp), 
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.picture_as_pdf,
                                  color: Colors.red,
                                  size: 24.sp, 
                                ),
                                onPressed: () {
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 24.h), 

                      SizedBox(
                        width: double.infinity,
                        height: 50.h, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r), 
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddDiagnosisScreen(
                                  patientId: widget.patientId, 
                                  visitId: widget.visitId, 
                                ),
                              ),
                            ).then((value) {
                              fetchPatientProfile();
                            });
                          },
                          child: Text(
                            "إضافة تشخيص للموعد الحالي",
                            style: TextStyle(
                              fontSize: 16.sp, 
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
}
