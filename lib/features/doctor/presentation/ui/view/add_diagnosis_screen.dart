
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 

class AddDiagnosisScreen extends StatefulWidget {
  final int patientId;
  final int visitId;

  const AddDiagnosisScreen({
    super.key,
    required this.patientId,
    required this.visitId,
  });

  @override
  State<AddDiagnosisScreen> createState() => _AddDiagnosisScreenState();
}

class _AddDiagnosisScreenState extends State<AddDiagnosisScreen> {
  final TextEditingController _complaintController = TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _complaintController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }

  Future<void> _saveDiagnosis() async {
    if (_diagnosisController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء كتابة التشخيص على الأقل')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/add-diagnosis'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'patient_id': widget.patientId.toString(),
          'visit_id': widget.visitId.toString(),
          'complaint': _complaintController.text.trim(),
          'diagnosis': _diagnosisController.text.trim(),
        },
      );

      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200 && (jsonResponse['success'] == true || jsonResponse['errNum'] == 'S000')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم الحفظ بنجاح!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(jsonResponse['msg'] ?? 'فشل في الحفظ'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ بالاتصال: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isSaving = false;
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
          "إضافة فحص سريري",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.sp), 
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الشكاية الرئيسية للمريض",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold), 
            ),
            SizedBox(height: 8.h), 
            TextField(
              controller: _complaintController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "مثال: ألم مستمر أسفل الظهر...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r), 
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r), 
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 24.h), 
            Text(
              "التشخيص الطبي (مطلوب)",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold), 
            ),
            SizedBox(height: 8.h), 
            TextField(
              controller: _diagnosisController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "اكتب التشخيص هنا...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r), 
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r), 
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            SizedBox(height: 40.h), 
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
                onPressed: _isSaving ? null : _saveDiagnosis,
                child: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "حفظ البيانات",
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}