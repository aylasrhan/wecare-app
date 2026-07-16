
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
    fetchClinics();
  }

  // دالة جلب العيادات (التي تعمل لديك)
  Future<void> fetchClinics() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('$baseUrl/api/clinics'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );
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

 void _sendQuestion() {
  if (_questionController.text.isNotEmpty && selectedClinicId != null) {
    // جلب اسم العيادة من القائمة الموجودة عندك
    var selectedClinic = clinics.firstWhere((c) => c['id'] == selectedClinicId);
    
    setState(() {
      // إضافة السؤال للقائمة ليتم عرضه في الأعلى
      myQuestions.add(QuestionItem(
        clinicName: selectedClinic['name_ar'], 
        question: _questionController.text
      ));
    });
    
    _questionController.clear();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم الإرسال بنجاح")));
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 40),
          Text("Ask Question", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),

          // القائمة في الأعلى (تأخذ المساحة المتاحة)
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount:myQuestions.length, // هنا ستضع قائمة الأسئلة الخاصة بك
                    itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(myQuestions[index].clinicName, 
                    style: TextStyle(fontWeight: FontWeight.bold)), // اسم العيادة
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
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
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
                  onChanged: (int? newValue) => setState(() => selectedClinicId = newValue),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    hintText: "Question",
                    border: InputBorder.none,
                    suffixIcon: IconButton(icon: Icon(Icons.send), onPressed: _sendQuestion),
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