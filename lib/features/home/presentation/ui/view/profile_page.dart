import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage("https://via.placeholder.com/150"), // استبدليها بصورة المستخدم
              ),
            ),
            TextButton(onPressed: () {}, child: Text("Change Photo")),
            SizedBox(height: 20),
            _buildTextField("Name", "jgjhgj"),
            _buildTextField("Email", "w71@gmail.com"),
            _buildTextField("Mobile Number", "Your Mobile Number"),
            _buildTextField("Address", "مشروع دمر"),
            Spacer(),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text("Log Out", style: TextStyle(color: Colors.red, fontSize: 18)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 16)),
        SizedBox(height: 5),
        TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.grey[100],
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}