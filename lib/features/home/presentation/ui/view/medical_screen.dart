
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// class QuestionItem {
//   final String clinicName;
//   final String question;
//   QuestionItem({required this.clinicName, required this.question});
// }
// class MedicalPage extends StatefulWidget {
//   @override
//   _MedicalPageState createState() => _MedicalPageState();
// }

// class _MedicalPageState extends State<MedicalPage> {
//   final TextEditingController _questionController = TextEditingController();
//   List<QuestionItem> myQuestions = [];
//   // المتغيرات الخاصة بالبيانات الديناميكية
//   int? selectedClinicId;
//   List clinics = [];
//   bool isLoading = true;
//   final String baseUrl = "http://10.0.2.2:8000";

//   @override
//   void initState() {
//     super.initState();
//     fetchClinics().then((_) {
//     fetchQuestions();
//   });
//     // fetchClinics();
//     // fetchQuestions();
//   }
//   String getClinicName(int id) {
//   // نبحث في قائمة العيادات عن العيادة التي تطابق الـ id
//   final clinic = clinics.firstWhere(
//     (c) => c['id'] == id, 
//     orElse: () => {'name_ar': 'غير معروف'}
//   );
//   return clinic['name_ar'];
// }
// Future<void> fetchQuestions() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('user_token');
    
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/api/patient_questions'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(response.body);
//         if (jsonResponse['questions'] != null) {
//           setState(() {
          
// myQuestions = (jsonResponse['questions'] as List).map((q) {
//   // تحويل الـ section إلى int للبحث
//   int clinicId = int.tryParse(q['section'].toString()) ?? 0;
  
//   return QuestionItem(
//     // هنا نستخدم الدالة لجلب الاسم
//     clinicName: getClinicName(clinicId), 
//     question: q['Question'] ?? ""
//   );
// }).toList();
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching questions: $e");
//     }
//     setState(() => isLoading = false);
//   }
//   // دالة جلب العيادات (التي تعمل لديك)
//   Future<void> fetchClinics() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('user_token');
//       final response = await http.get(
//         Uri.parse('$baseUrl/api/clinics'),
//         headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
//       );
//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(response.body);
//         setState(() {
//           clinics = jsonResponse['data'] ?? [];
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() => isLoading = false);
//     }
//   }
// Future<void> _sendQuestion() async {
//   if (_questionController.text.isNotEmpty && selectedClinicId != null) {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? token = prefs.getString('user_token');

//     // طباعة التوكين للتأكد من أنه موجود
//     print("Token being used: $token");

//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/api/ask'),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Accept': 'application/json'
//         },
//         body: {
//           'Question': _questionController.text,
//           'section': selectedClinicId.toString(),
//         },
//       );

//       print("Response Code: ${response.statusCode}");
//       print("Response Body: ${response.body}"); // هذا السطر هو الأهم!

//       if (response.statusCode == 200) {
//         _questionController.clear();
//         setState(() => selectedClinicId = null);
//         fetchQuestions();
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم الإرسال بنجاح")));
//       } else {
//         // عرض الخطأ القادم من السيرفر بالتفصيل
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("خطأ: ${response.body}")),
//         );
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("فشل الاتصال بالسيرفر")));
//     }
//   }
// }


//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         children: [
//           SizedBox(height: 40),
//           Text("Ask Question", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           SizedBox(height: 20),

//           // القائمة في الأعلى (تأخذ المساحة المتاحة)
//           Expanded(
//             child: isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     itemCount:myQuestions.length, // هنا ستضع قائمة الأسئلة الخاصة بك
//                     itemBuilder: (context, index) {
//             return Card(
//               margin: EdgeInsets.all(10),
//               child: ListTile(
//                 title: Text(myQuestions[index].clinicName, 
//                     style: TextStyle(fontWeight: FontWeight.bold)), // اسم العيادة
//                 subtitle: Text(myQuestions[index].question), // السؤال
//               ),
//             );
//           },
//                   ),
//           ),

//           // حقول الإدخال في الأسفل
//           Column(
//             children: [
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//                 child: DropdownButtonFormField<int>(
//                   hint: Text("choose clinic"),
//                   value: selectedClinicId,
//                   isExpanded: true,
//                   items: clinics.map((clinic) {
//                     return DropdownMenuItem<int>(
//                       value: clinic['id'],
//                       child: Text(clinic['name_ar'] ?? "Unknown"),
//                     );
//                   }).toList(),
//                   onChanged: (int? newValue) => setState(() => selectedClinicId = newValue),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//                 child: TextField(
//                   controller: _questionController,
//                   decoration: InputDecoration(
//                     hintText: "Question",
//                     border: InputBorder.none,
//                     suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: _sendQuestion),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
///كود الاسئلة 
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuestionItem {
  final String clinicName;
  final String question;
  final String? answer;

  QuestionItem({required this.clinicName, required this.question, this.answer});
}

class MedicalPage extends StatefulWidget {
  @override
  _MedicalPageState createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  final TextEditingController _questionController = TextEditingController();
  List<QuestionItem> myQuestions = [];

  int? selectedClinicId;
  List clinics = [];
  bool isLoading = true;

  // 💡 تم تصحيح الـ baseUrl ليطابق السيرفر الصحيح لديك
  final String baseUrl =
      "http://10.0.2.2:8000/api";

  @override
  void initState() {
    super.initState();
    fetchClinics().then((_) {
      fetchQuestions();
    });
  }

  // دالة جلب العيادات (الأقسام)
  Future<void> fetchClinics() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('user_token');

      // تأكد أن الرابط هنا صحيح، هل هو clinics أم departments في الباك إند؟
      String url = '$baseUrl/clinics';
      print("🌐 جاري طلب العيادات من: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("📦 كود حالة العيادات: ${response.statusCode}");
      print("📦 الرد القادم للعيادات: ${response.body}");

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (!mounted) return;

        // 🛑 التعديل هنا: فحص 'status' بدلاً من 'success'
        if (jsonResponse['status'] == 'success') {
          setState(() {
            // 🛑 التعديل هنا: قراءة المصفوفة من 'data' بدلاً من 'departments'
            clinics = jsonResponse['data'] ?? [];
          });
          print("✅ تم تحميل ${clinics.length} عيادات بنجاح");
        }
      } else {
        print("❌ فشل تحميل العيادات، كود الخطأ: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ خطأ برمجي أو انقطاع شبكة في جلب العيادات: $e");
    }
  }

  // دالة جلب الأسئلة
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

  // دالة إرسال السؤال
  Future<void> _sendQuestion() async {
    if (_questionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("الرجاء كتابة السؤال")));
      return;
    }
    if (selectedClinicId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("الرجاء اختيار العيادة")));
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Ask Question",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E66),
            ),
          ),
          const SizedBox(height: 20),

          // قائمة الأسئلة
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1E1E66)),
                  )
                : myQuestions.isEmpty
                ? const Center(
                    child: Text(
                      "لا توجد أسئلة سابقة",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: myQuestions.length,
                    itemBuilder: (context, index) {
                      final item = myQuestions[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.clinicName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E66),
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "س: ${item.question}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const Divider(),
                              if (item.answer != null &&
                                  item.answer!.isNotEmpty)
                                Text("ج: ${item.answer}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                )
                              else
                                const Text(
                                  "⏳ بانتظار رد الطبيب...",
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // منطقة إدخال السؤال والعيادة
          Container(
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Column(
              children: [
                // Dropdown للعيادات (تم تصحيح جلب العناصر وتفعيلها)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      hint: Text(
                        clinics.isEmpty
                            ? "جارِ التحميل أو لا توجد عيادات..."
                            : "اختر العيادة",
                      ),
                      value: selectedClinicId,
                      isExpanded: true,
                      // إذا كانت القائمة فارغة، نضع عنصر وهمي غير قابل للاختيار
                      items: clinics.isEmpty
                          ? [
                              const DropdownMenuItem<int>(
                                value: null,
                                child: Text("لا توجد بيانات"),
                              ),
                            ]
                          : clinics.map((clinic) {
                              return DropdownMenuItem<int>(
                                value: clinic['id'],
                                child: Text(clinic['name_ar'] ?? "غير معروف"),
                              );
                            }).toList(),
                      onChanged: clinics.isEmpty
                          ? null
                          : (int? newValue) {
                              setState(() {
                                selectedClinicId = newValue;
                              });
                            },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // حقل السؤال
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    controller: _questionController,
                    decoration: InputDecoration(
                      hintText: "Question",
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFF1E1E66)),
                        onPressed: _sendQuestion,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}