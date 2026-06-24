
// import 'package:flutter/material.dart';

// class MedicalPage extends StatefulWidget {
//   @override
//   _MedicalPageState createState() => _MedicalPageState();
// }

// class _MedicalPageState extends State<MedicalPage> {
//     final TextEditingController _questionController = TextEditingController();

//   // المتغير الذي سيخزن العيادة المختارة
//   String? selectedClinic;
// @override
//   void dispose() {
//     _questionController.dispose(); // تنظيف الذاكرة
//     super.dispose();
//   }
//   // قائمة العيادات
//   final List<String> clinics = [
//     "العلاج الفيزيائي",
//     "عينية",
//     "أذن أنف حنجرة",
//     "صدرية",
//     "توليد و نسائية",
//     "عصبية",
//     "عظمية",
//     "أطفال",
//     "تجميل",
//     "قلبية"
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(height: 40),
//           Center(
//             child: Text(
//               "Ask Question",
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           SizedBox(height: 30),
          
//           // الكاردات
//           _buildQuestionCard("أذن أنف حنجرة", "jgzfjtjtisutsitditstsjtditxtkdk"),
//           SizedBox(height: 20),
//           _buildQuestionCard("أذن أنف حنجرة", "hfjfjfudufifififofifififfkfif"),
          
//           Spacer(), // لدفع العناصر للأسفل
          
//           // حقل اختيار العيادة (قائمة منسدلة)
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               color: Colors.grey[200], 
//               borderRadius: BorderRadius.circular(10)
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButtonFormField<String>(
//                 hint: Text("choose clinic"),
//                 value: selectedClinic,
//                 isExpanded: true,
//                 items: clinics.map((String clinic) {
//                   return DropdownMenuItem<String>(
//                     value: clinic,
//                     child: Text(clinic),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedClinic = newValue;
//                   });
//                 },
//               ),
//             ),
//           ),
          
//           SizedBox(height: 10),
          
//           // حقل السؤال
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
//             child: TextField(
//               controller: _questionController, // ربط الـ Controller
//               textDirection: TextDirection.rtl, // لضبط اتجاه الكتابة من اليمين
//     // textAlign: TextAlign.right,
//               decoration: InputDecoration(
//                 hintText: "Question", 
//                 border: InputBorder.none, 
//                 suffixIcon: IconButton(
//         icon: Icon(Icons.send),
//         onPressed: () {
//           // هنا نضع كود الإرسال
//           if (_questionController.text.isNotEmpty) {
//             print("تم إرسال السؤال: ${_questionController.text}");
//             // يمكنك إضافة استدعاء دالة API هنا لإرسال السؤال للخادم
//             ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Question send successfully.."),
//         backgroundColor: Colors.green, // لون الخلفية الأخضر كما في الصورة
//         duration: Duration(seconds: 2), // مدة بقاء الرسالة
//       ),
//     );
//             // مسح الحقل بعد الإرسال
//             _questionController.clear();
//           }
//         },
//       ),
//               )
//             ),
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   // كود بناء الكارد
//   Widget _buildQuestionCard(String title, String content) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: Colors.white, 
//         borderRadius: BorderRadius.circular(15), 
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           Text(content),
//           SizedBox(height: 10),
//           Text("There is No answer", style: TextStyle(color: Colors.grey)),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

// 1. نموذج بيانات بسيط للسؤال
class QuestionModel {
  final String clinic;
  final String question;
  QuestionModel({required this.clinic, required this.question});
}

class MedicalPage extends StatefulWidget {
  @override
  _MedicalPageState createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  final TextEditingController _questionController = TextEditingController();
  String? selectedClinic;
  
  // قائمة لتخزين الأسئلة المرسلة
  List<QuestionModel> myQuestions = [];

  final List<String> clinics = [
    "العلاج الفيزيائي", "عينية", "أذن أنف حنجرة", "صدرية", 
    "توليد و نسائية", "عصبية", "عظمية", "أطفال", "تجميل", "قلبية"
  ];

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  // دالة الإرسال وتحديث القائمة
  void _sendQuestion() {
    if (_questionController.text.isNotEmpty && selectedClinic != null) {
      setState(() {
        // إضافة السؤال الجديد للقائمة (يظهر في الأعلى)
        myQuestions.insert(0, QuestionModel(
          clinic: selectedClinic!,
          question: _questionController.text,
        ));
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Question send successfully.."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      _questionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Center(child: Text("Ask Question", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
          SizedBox(height: 30),
          
          // عرض قائمة الأسئلة المرسلة
          Expanded(
            child: ListView.builder(
              itemCount: myQuestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _buildQuestionCard(myQuestions[index].clinic, myQuestions[index].question),
                );
              },
            ),
          ),
          
          // حقل اختيار العيادة
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                hint: Text("choose clinic"),
                value: selectedClinic,
                isExpanded: true,
                items: clinics.map((String clinic) {
                  return DropdownMenuItem<String>(value: clinic, child: Text(clinic));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() { selectedClinic = newValue; });
                },
              ),
            ),
          ),
          
          SizedBox(height: 10),
          
          // حقل السؤال
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: _questionController,
              textDirection: TextDirection.rtl,
              // textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "Question",
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendQuestion, // استدعاء الدالة المحدثة
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String title, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15), 
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(content),
          SizedBox(height: 10),
          Text("There is No answer", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}