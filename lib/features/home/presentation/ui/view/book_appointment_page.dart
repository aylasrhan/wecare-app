import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookAppointmentPage extends StatefulWidget {
  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;

  final List<String> times = ["18:50", "19:05", "19:35", "19:50", "20:20", "20:35"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment"), elevation: 0, backgroundColor: Colors.white, foregroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            // تنسيق التقويم ليشبه الصورة
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
              child: TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2027, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(color: Color(0xFF5C6BC0), shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle),
                ),
              ),
            ),
            
            SizedBox(height: 20),
            Text("Select Hour", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            
            Wrap(
              spacing: 10, runSpacing: 10,
              children: times.map((time) => ChoiceChip(
                label: Text(time, style: TextStyle(color: _selectedTime == time ? Colors.white : Colors.black)),
                selected: _selectedTime == time,
                selectedColor: Color(0xFF4FC3F7), // لون الأزرق الفاتح عند الاختيار
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.blueGrey)),
                onSelected: (selected) => setState(() => _selectedTime = time),
              )).toList(),
            ),
            
            SizedBox(height: 30),
            
            // زر Next غير ممتد (بناءً على طلبك)
            Center(
              child: SizedBox(
                width: 250, // عرض محدد للزر
                height: 50,
                child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF1A237E),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  onPressed: () {
    // 1. هنا يفضل إضافة كود إرسال البيانات لقاعدة البيانات (Firebase)
    
    // 2. إظهار رسالة النجاح
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Appointment Successfully"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // 3. العودة لصفحة بروفايل الطبيب
    // Navigator.pop تعود للصفحة السابقة في التاريخ (وهي البروفايل)
    Navigator.pop(context);
  },
  child: Text("Next", style: TextStyle(fontSize: 18, color: Colors.white)),
),
              ),
            ),
          ],
        ),
      ),
    );
  }
}