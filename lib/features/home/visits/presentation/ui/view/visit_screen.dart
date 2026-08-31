
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/features/home/visits/presentation/ui/widgets/visit_card.dart'; // 🔴 استيراد الودجت الجديد

class VisitsPage extends StatefulWidget {
  @override
  _VisitsPageState createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  List visits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVisits();
  }

  Future<void> fetchVisits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/api/visits'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (!mounted) return; 

        setState(() {
          if (data.containsKey('visits')) {
            visits = data['visits'];
          } else {
            visits = [];
          }
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() => isLoading = false);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Visits", style: TextStyle(color: Colors.black, fontSize: 20.sp)), 
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : visits.isEmpty
              ? Center(child: Text("لا توجد زيارات", style: TextStyle(fontSize: 16.sp))) 
              : RefreshIndicator(
                  onRefresh: fetchVisits, 
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(20.w), 
                    itemCount: visits.length,
                    itemBuilder: (context, index) {
                      return VisitCard(
                        visit: visits[index],
                        onRefreshNeeded: fetchVisits,
                      );
                    },
                  ),
                ),
    );
  }
}