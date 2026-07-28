
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // لجلب الـ Token
import 'package:wecare/core/services/auth_service.dart';
import 'package:wecare/features/home/presentation/ui/view/home_screen.dart';

class BookAppointmentPage extends StatefulWidget {
  final dynamic doctor; // 1. إضافة متغير لاستقبال بيانات الطبيب المختار

  const BookAppointmentPage({Key? key, this.doctor}) : super(key: key);

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;
  bool _isLoading = false; // لمؤشر التحميل عند الضغط على الزر
List<String> _bookedTimes = [];
  final List<String> times = [
    "18:50",
    "19:05",
    "19:35",
    "19:50",
    "20:20",
    "20:35",
  ];

  // دالة إرسال الموعد لقاعدة البيانات في Laravel
  Future<bool> _bookAppointment() async {
    setState(() => _isLoading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token'); // جلب توكين المستخدم المسجل

      // تنسيق التاريخ بالشكل المتوافق مع الداتابيز (YYYY-MM-DD)
      String formattedDate =
          "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";

      // استخراج معرّف الطبيب من الكائن المُمرر
      int doctorId = widget.doctor != null ? widget.doctor['id'] : 1;

      // ⚠️ قم بتعديل الرابط ليطابق مسار API الحجز عندك في Laravel
      final response = await http.post(
        Uri.parse('https://your-domain.com/api/book-appointment'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'doctor_id': doctorId,
          'appointment_date': formattedDate,
          'time': _selectedTime,
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        print("Error response: ${response.body}");
        return false;
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Exception while booking: $e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // التقويم
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2027, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay)async {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _selectedTime = null; // تفريغ الوقت المختار القديم
    _bookedTimes = [];
                  });
                  String formattedDate = "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";
  
  // استدعاء الأوقات المحجوزة من السيرفر
  List<String> booked = await AuthService().getBookedTimes(widget.doctor.id, formattedDate);
  
  setState(() {
    _bookedTimes = booked; // تحديث الواجهة بالأوقات المحجوزة الجديدة
  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF5C6BC0),
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Select Hour",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              // children: times
              //     .map(
              //       (time) => ChoiceChip(
              //         label: Text(
              //           time,
              //           style: TextStyle(
              //             color: _selectedTime == time
              //                 ? Colors.white
              //                 : Colors.black,
              //           ),
              //         ),
              //         selected: _selectedTime == time,
              //         selectedColor: const Color(0xFF4FC3F7),
              //         backgroundColor: Colors.white,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15),
              //           side: const BorderSide(color: Colors.blueGrey),
              //         ),
              //         onSelected: (selected) =>
              //             setState(() => _selectedTime = time),
              //       ),
              //     )
              //     .toList(),
              children: times.map((time) {
  // فحص هل الوقت الحالي محجوز؟
  bool isBooked = _bookedTimes.contains(time);

  return ChoiceChip(
    label: Text(
      time,
      style: TextStyle(
        // إذا كان محجوزاً نجعله رمادي باهت، وإذا مختاراً نجعله أبيض، وإلا أسود
        color: isBooked 
            ? Colors.grey.shade500 
            : (_selectedTime == time ? Colors.white : Colors.black),
        // وضع خط شطب فوق الوقت المحجوز لمزيد من التوضيح (اختياري)
        decoration: isBooked ? TextDecoration.lineThrough : null,
      ),
    ),
    selected: _selectedTime == time && !isBooked,
    selectedColor: const Color(0xFF4FC3F7),
    // لون الخلفية رمادي باهت إذا محجوز
    backgroundColor: isBooked ? Colors.grey.shade200 : Colors.white, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(
        color: isBooked ? Colors.transparent : Colors.blueGrey,
      ),
    ),
    // 🔴 الأهم: تعطيل الضغط عبر إرجاع null إذا كان محجوزاً
    onSelected: isBooked
        ? null 
        : (selected) => setState(() => _selectedTime = time),
  );
}).toList(),
            ),

            const SizedBox(height: 30),

            // زر Next
            Center(
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                 
onPressed: _isLoading 
  ? null 
  : () async {
      if (_selectedDay == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("الرجاء اختيار التاريخ والوقت أولاً"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // تشغيل مؤشر التحميل
      setState(() {
        _isLoading = true;
      });

      try {
        // تنسيق التاريخ للشكل YYYY-MM-DD
        String formattedDate =
            "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";

        // 🔴 التعديل هنا: رجعناها مثل الكود القديم الشغال تماماً
        String result = await AuthService().bookAppointment(
          doctorId: widget.doctor.id, 
          date: formattedDate,
          time: _selectedTime!,
        );

        if (result == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تم حجز الموعد بنجاح"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          // الانتقال للصفحة الرئيسية وتجديد البيانات
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreenPage()),
            (route) => false,
          );
        } else {
          // سيقوم هنا بطباعة الخطأ القادم من السيرفر (مثلاً: الموعد محجوز مسبقاً)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } catch (e) {
        // طباعة الخطأ في حال حدوث مشكلة بالاتصال
        print("Error: $e");
      } finally {
        // إيقاف مؤشر التحميل دائماً حتى لو حصل خطأ
        setState(() {
          _isLoading = false;
        });
      }
},

// onPressed: () async {
//   if (_selectedDay == null || _selectedTime == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("الرجاء اختيار التاريخ والوقت أولاً"),
//         backgroundColor: Colors.red,
//       ),
//     );
//     return;
//   }

//   // تنسيق التاريخ للشكل YYYY-MM-DD
//   String formattedDate =
//       "${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}";

//   // استدعاء API الحجز الحقيقي
//   bool isSuccess = await AuthService().bookAppointment(
//     doctorId: widget.doctor.id,
//     date: formattedDate,
//     time: _selectedTime!,
//   );

//   if (isSuccess) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Appointment Successfully"),
//         backgroundColor: Colors.green,
//         duration: Duration(seconds: 2),
//       ),
//     );
//     // الانتقال للصفحة الرئيسية وتجديد البيانات
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => HomeScreenPage()),
//       (route) => false,
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("فشل في حفظ الموعد، حاول مرة أخرى"),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Next",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
