
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wecare/features/home/searchresult/presentation/ui/widgets/doctor_result_card.dart'; // 🔴 استيراد البطاقة المنفصلة

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final String baseUrl = "http://10.0.2.2:8000/api/";

  List<dynamic> filteredDoctors = [];
  bool isLoading = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _filterSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredDoctors = [];
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse("${baseUrl}search"); 

      final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('user_token') ?? ''; 

      print("التوكن المستخدم حالياً: $token");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'val': query,
        }),
      );

      print("الرد من السيرفر للبحث: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        setState(() {
          filteredDoctors = responseData['doctors'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          filteredDoctors = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Search result", 
          style: TextStyle(color: Colors.black, fontSize: 20.sp) 
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.sp), 
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: _filterSearch,
              style: TextStyle(fontSize: 16.sp), 
              decoration: InputDecoration(
                hintText: "Search about doctor",
                hintStyle: TextStyle(fontSize: 14.sp), 
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: const Color(0xFF1E1E66), size: 24.sp), 
                  onPressed: () {
                    _filterSearch(searchController.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.r), 
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h), 
              ),
            ),
            SizedBox(height: 20.h), 
            
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (filteredDoctors.isNotEmpty) ...[
                Text(
                  "${filteredDoctors.length} Available Doctors", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp) 
                ),
                SizedBox(height: 15.h), 
              ],
              
              Expanded(
                child: searchController.text.isEmpty
                    ? Center(
                        child: Text(
                          "Please search for a doctor by name or specialty",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey), 
                        ),
                      )
                    : filteredDoctors.isEmpty
                        ? Center(
                            child: Text(
                              "No Search Result",
                              style: TextStyle(fontSize: 18.sp, color: Colors.grey), 
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final doc = filteredDoctors[index];
                              return DoctorResultCard(
                                doctorName: doc['name_ar'] ?? '',
                                specialty: doc['specialization_ar'] ?? 'General',
                                rating: doc['total_rate']?.toString() ?? '4.8',
                                fee: "20",
                              );
                            },
                          ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}