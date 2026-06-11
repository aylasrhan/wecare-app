import 'package:flutter/material.dart';

class DetailsEyeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "عينية",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(15),
        children: [
          _buildAppointmentCard("رشا الرياحي", "4.8"),
          _buildAppointmentCard("samer ali", "4.8"),
          _buildAppointmentCard("أنس ملص", "4.8"),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(String name, String rating) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // زوايا منحنية كتير متل الصورة
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. القسم العلوي: الصورة والاسم والتقييم
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue.shade600, // لون أزرق متل الصورة
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "عينية",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue.shade300, size: 18),
                        SizedBox(width: 5),
                        Text(rating, style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 20),
          Divider(color: Colors.grey[200], thickness: 1), // الخط الفاصل
          SizedBox(height: 15),

          // 2. القسم الأوسط: التاريخ، الوقت، والحالة (بالأيقونات الرمادية)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                  SizedBox(width: 5),
                  Text("10 Dec 2022", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 5),
                  Text("10:30 AM", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text("Confirmed", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ],
          ),

          SizedBox(height: 20),

          // 3. القسم السفلي: الأزرار (Cancel و Reschedule)
          Row(
            children: [
              // زر Cancel
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Cancel", style: TextStyle(color: Colors.black)),
                ),
              ),
              SizedBox(width: 15),
              // زر Reschedule
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E1E66), // الكحلي الغامق متل الصورة
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: Text("Reschedule", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
