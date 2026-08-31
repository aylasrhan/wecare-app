
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/home/presentation/ui/widgets/question_item_card.dart'; // 🔴 استيراد بطاقة السؤال
import 'package:wecare/features/home/presentation/ui/widgets/medical_input_section.dart'; // 🔴 استيراد قسم الإدخال

class QuestionItem {
  final String clinicName;
  final String question;
  final String? answer;

  QuestionItem({required this.clinicName, required this.question, this.answer});
}

class MedicalPage extends StatefulWidget {
  const MedicalPage({super.key});

  @override
  _MedicalPageState createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  final TextEditingController _questionController = TextEditingController();
  List<QuestionItem> myQuestions = [];

  int? selectedClinicId;
  List clinics = [];
  bool isLoading = true;

  final String baseUrl = "http://10.0.2.2:8000/api";

  @override
  void initState() {
    super.initState();
    fetchClinics().then((_) {
      fetchQuestions();
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> fetchClinics() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      String url = '$baseUrl/clinics';
      print("🌐 جاري طلب العيادات من: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (!mounted) return;

        if (jsonResponse['status'] == 'success') {
          setState(() {
            clinics = jsonResponse['data'] ?? [];
          });
        }
      }
    } catch (e) {
      print("❌ خطأ برمجي أو انقطاع شبكة في جلب العيادات: $e");
    }
  }

  Future<void> fetchQuestions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      final response = await http.get(
        Uri.parse('$baseUrl/patient_questions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (!mounted) return;

        if (jsonResponse['success'] == true &&
            jsonResponse['questions'] != null) {
          setState(() {
            myQuestions = (jsonResponse['questions'] as List).map((q) {
              String clinicName = "غير معروف";
              if (q['gnr_m_clinics'] != null &&
                  q['gnr_m_clinics']['name_ar'] != null) {
                clinicName = q['gnr_m_clinics']['name_ar'];
              }

              return QuestionItem(
                clinicName: clinicName,
                question: q['Question'] ?? "",
                answer: q['answer'],
              );
            }).toList();
          });
        }
      }
    } catch (e) {
      print("Error fetching questions: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _sendQuestion() async {
    if (_questionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء كتابة السؤال")),
      );
      return;
    }
    if (selectedClinicId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء اختيار العيادة")),
      );
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ask'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
        body: {
          'Question': _questionController.text.trim(),
          'section': selectedClinicId.toString(),
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          _questionController.clear();
          setState(() => selectedClinicId = null);
          fetchQuestions();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(jsonResponse['msg'] ?? "تم الإرسال بنجاح"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("خطأ: ${jsonResponse['msg']}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("Error sending question: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("فشل الاتصال بالسيرفر"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w), 
      child: Column(
        children: [
          SizedBox(height: 40.h), 
          Text(
            "Ask Question",
            style: TextStyle(
              fontSize: 24.sp, 
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E1E66),
            ),
          ),
          SizedBox(height: 20.h),

          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1E1E66)),
                  )
                : myQuestions.isEmpty
                    ? Center(
                        child: Text(
                          "لا توجد أسئلة سابقة",
                          style: TextStyle(color: Colors.grey, fontSize: 16.sp), 
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchQuestions,
                        color: const Color(0xFF1E1E66),
                        child: ListView.builder(
                          itemCount: myQuestions.length,
                          itemBuilder: (context, index) {
                            return QuestionItemCard(item: myQuestions[index]);
                          },
                        ),
                      ),
          ),

          MedicalInputSection(
            clinics: clinics,
            selectedClinicId: selectedClinicId,
            onClinicChanged: (newValue) {
              setState(() {
                selectedClinicId = newValue;
              });
            },
            questionController: _questionController,
            onSendPressed: _sendQuestion,
          ),
        ],
      ),
    );
  }
}