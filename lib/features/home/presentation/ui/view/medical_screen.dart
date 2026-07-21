import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuestionItem {
  final String clinicName;
  final String question;
  QuestionItem({required this.clinicName, required this.question});
}

class MedicalPage extends StatefulWidget {
  @override
  _MedicalPageState createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  final TextEditingController _questionController = TextEditingController();
  List<QuestionItem> myQuestions = [];
  // المتغيرات الخاصة بالبيانات الديناميكية
  int? selectedClinicId;
  List clinics = [];
  bool isLoading = true;
  final String baseUrl = "http://10.0.2.2:8000";

  @override
  void initState() {
    super.initState();
    fetchClinics().then((_) {
      fetchQuestions();
    });
    // fetchClinics();
    // fetchQuestions();
  }

  String getClinicName(int id) {
    // نبحث في قائمة العيادات عن العيادة التي تطابق الـ id
    final clinic = clinics.firstWhere(
      (c) => c['id'] == id,
      orElse: () => {'name_ar': 'غير معروف'},
    );
    return clinic['name_ar'];
  }

  Future<void> fetchQuestions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/patient_questions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['questions'] != null) {
          setState(() {
            // myQuestions = (jsonResponse['questions'] as List).map((q) {
            //   return QuestionItem(
            //     // نقوم بتحويل section (ID) إلى نص أو نستخدم الاسم إذا كان متاحاً
            //     clinicName: "العيادة رقم: ${q['section']}",
            //     question: q['Question'] ?? ""
            //   );
            // }).toList();
            // داخل دالة fetchQuestions:
            myQuestions = (jsonResponse['questions'] as List).map((q) {
              // تحويل الـ section إلى int للبحث
              int clinicId = int.tryParse(q['section'].toString()) ?? 0;

              return QuestionItem(
                // هنا نستخدم الدالة لجلب الاسم
                clinicName: getClinicName(clinicId),
                question: q['Question'] ?? "",
              );
            }).toList();
          });
        }
      }
    } catch (e) {
      print("Error fetching questions: $e");
    }
    setState(() => isLoading = false);
  }

  // دالة جلب العيادات (التي تعمل لديك)
  Future<void> fetchClinics() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');
      final response = await http.get(
        Uri.parse('$baseUrl/api/clinics'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        setState(() {
          clinics = jsonResponse['data'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => isLoading = false);
    }
  }

  Future<void> _sendQuestion() async {
    if (_questionController.text.isNotEmpty && selectedClinicId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      // طباعة التوكين للتأكد من أنه موجود
      print("Token being used: $token");

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/ask'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          body: {
            'Question': _questionController.text,
            'section': selectedClinicId.toString(),
          },
        );

        print("Response Code: ${response.statusCode}");
        print("Response Body: ${response.body}"); // هذا السطر هو الأهم!

        if (response.statusCode == 200) {
          _questionController.clear();
          setState(() => selectedClinicId = null);
          fetchQuestions();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("تم الإرسال بنجاح")));
        } else {
          // عرض الخطأ القادم من السيرفر بالتفصيل
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("خطأ: ${response.body}")));
        }
      } catch (e) {
        print("Error: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("فشل الاتصال بالسيرفر")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 40),
          Text(
            "Ask Question",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          // القائمة في الأعلى (تأخذ المساحة المتاحة)
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount:
                        myQuestions.length, // هنا ستضع قائمة الأسئلة الخاصة بك
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            myQuestions[index].clinicName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ), // اسم العيادة
                          subtitle: Text(myQuestions[index].question), // السؤال
                        ),
                      );
                    },
                  ),
          ),

          // حقول الإدخال في الأسفل
          Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonFormField<int>(
                  hint: Text("choose clinic"),
                  value: selectedClinicId,
                  isExpanded: true,
                  items: clinics.map((clinic) {
                    return DropdownMenuItem<int>(
                      value: clinic['id'],
                      child: Text(clinic['name_ar'] ?? "Unknown"),
                    );
                  }).toList(),
                  onChanged: (int? newValue) =>
                      setState(() => selectedClinicId = newValue),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: "Question",
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sendQuestion,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
