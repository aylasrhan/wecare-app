
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/features/auth/login/data/models/user_model.dart';
import 'package:wecare/model/doctor_model.dart';
import 'package:wecare/model/visit_model.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000/api/";


Future<String> bookAppointment({
  required dynamic doctor, // نقبل الطبيب كاملاً (سواء كان كائن Doctor أو Map) لضمان استخراج الـ ID الصحيح
  required String date,
  required String time,
}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token') ?? prefs.getString('user_token'); 

    // استخراج الـ ID الحقيقي للطبيب بغض النظر عن شكل البيانات القادمة
    int doctorId;
    if (doctor is int) {
      doctorId = doctor;
    } else if (doctor is Map) {
      doctorId = doctor['id'];
    } else {
      doctorId = doctor.id; // إذا كان كائن Doctor أو DoctorModel
    }

    print("🚨 [FINAL FIX] Booking with true Doctor ID: $doctorId for Date: $date, Time: $time");

    final response = await http.post(
      Uri.parse('${baseUrl}appointment-store'), 
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'appointment_with': doctorId, // الـ ID الحقيقي والصحيح حصراً
        'available_slot': time, 
        'appointment_date': date,
        'doctor_id': doctorId,
        'time': time,
      }),
    );

    print("Booking Response Status: ${response.statusCode}");
    print("Booking Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      if (data['success'] == true || data['error'] == "D00" || data['status'] == 'success') {
        return "success"; 
      } else {
        return data['msg'] ?? data['message'] ?? "خطأ غير معروف في السيرفر"; 
      }
    }
    return "خطأ في الاتصال: ${response.statusCode}"; 
  } catch (e) {
    print("Booking Error: $e");
    return "حدث خطأ في الاتصال بالخادم";
  }
}


Future<List<String>> getBookedTimes(int doctorId, String date) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    // تأكد من وضع الرابط الصحيح حسب ما سميته في ملف api.php
    final response = await http.get(
      Uri.parse('${baseUrl}booked-times?doctor_id=$doctorId&date=$date'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        // تحويل المصفوفة القادمة إلى List<String>
        return List<String>.from(data['booked_times']);
      }
    }
    return []; // إذا فشل نرجع قائمة فارغة
  } catch (e) {
    print("Error fetching booked times: $e");
    return [];
  }
}



Future<UserModel> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('${baseUrl}Api_login'),
    body: {'email': email, 'password': password},
  );
  
  final responseData = json.decode(response.body);
  
  if (response.statusCode == 200) {
    // الوصول إلى البيانات داخل مفتاح 'data'
    final data = responseData['data']; 
    
    // 🔴 التعديل هنا: فحصنا أن الـ data موجودة وليست null
    if (data != null && data is Map) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
     
      // 1. حفظ التوكين بالاسمين معاً لضمان توافقه مع كل الدوال
      if (data.containsKey('user_token')) { 
        String tokenValue = data['user_token'];
        await prefs.setString('token', tokenValue);      // لأجل شاشات الطبيب
        await prefs.setString('user_token', tokenValue); // لأجل شاشات المريض وباقي التطبيق
        print("تم حفظ التوكين بنجاح بالاسمين");
      }
      
      // 2. حفظ الدور (roles_name)
      // if (data.containsKey('roles_name')) {
      //   await prefs.setString('roles_name', data['roles_name']);
      //   print("تم حفظ الدور: ${data['roles_name']}");
      // }
      // 2. حفظ الدور (roles_name)
      if (data.containsKey('roles_name')) {
        var roleData = data['roles_name'];
        String roleStr = '';
        if (roleData is List && roleData.isNotEmpty) {
          roleStr = roleData[0].toString();
        } else {
          roleStr = roleData.toString();
        }
        await prefs.setString('roles_name', roleStr);
        print("تم حفظ الدور بنجاح: $roleStr");
      }
      
      return UserModel.fromJson(responseData);
    } else {
      // إذا رد السيرفر بـ 200 ولكن الداتا كانت فارغة
      print("🚨 البيانات القادمة من السيرفر فارغة! الرد بالكامل: $responseData");
      throw Exception(responseData['message'] ?? 'بيانات الحساب غير موجودة');
    }
    
  } else {
    throw Exception(responseData['message'] ?? 'Failed to login');
  }
}
 Future<Map<String, dynamic>> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('user_token');

    final response = await http.get(
      Uri.parse('${baseUrl}profile'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('فشل جلب بيانات الملف الشخصي: ${response.statusCode}');
    }
  }

Future<Map<String, dynamic>> register({
  required String name,
  required String email,
  required String password,
  required String passwordConfirmation,
  required String role,
  String? motherName,
  String? mobile,
  String? birthDate,
  int? sex,          // 🔴 التعديل هنا: جعلناه int
  String? blood,
  int? city,         // 🔴 التعديل هنا: جعلناه int (معرّف المدينة ID)
  int? nationality,  // 🔴 التعديل هنا: جعلناه int (معرّف الجنسية ID)
  String? address,
  String? specialization,
}) async {
  
  Map<String, String> body = {
    'name': name,
    'email': email,
    'password': password,
    'c_password': passwordConfirmation,
    'roles_name': role,
  };

  if (motherName != null) body['mother_name'] = motherName;
  if (mobile != null) body['mobile'] = mobile;
  if (birthDate != null) body['birth_date'] = birthDate;
  if (sex != null) body['sex'] = sex.toString();
  if (blood != null) body['blood'] = blood;
  if (city != null) body['p_city'] = city.toString();         // يرسل رقم الـ ID
  if (nationality != null) body['nationality'] = nationality.toString(); // يرسل رقم الـ ID
  if (address != null) body['address'] = address;
  if (specialization != null) body['specialization'] = specialization;

  final response = await http.post(
    Uri.parse('${baseUrl}register'),
    body: body,
  );

  print("Register Status: ${response.statusCode}");
  print("Register Body: ${response.body}");

  final data = json.decode(response.body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    if (data.containsKey('user_token')) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', data['user_token']);
      await prefs.setString('roles_name', role);
      print("تم حفظ التوكين بنجاح: ${data['user_token']}");
    }
    return data;
  } else {
    String errorMessage = data['message'] ?? 'Failed to register';
    if (data.containsKey('errors')) {
      errorMessage = data['errors'].toString();
    }
    throw Exception(errorMessage);
  }
}
Future<List<String>> getNationalities() async {
  try {
    print("جاري الاتصال بـ: ${baseUrl}get-nationalities");
    
    final response = await http.get(Uri.parse('${baseUrl}get-nationalities'));
    
    // طباعة كل شيء بوضوح
    print("الحالة: ${response.statusCode}");
    print("الرد: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      List<dynamic> list = responseData['data']['nationalities'];
      return list.map((item) => item['name_en'].toString()).toList();
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  } catch (e) {
    print("خطأ كشف الاتصال: $e"); // هنا سنعرف هل المشكلة SocketException أم غيره
    throw e;
  }
}
Future<List<String>> getCities() async {
  // تأكدي أن الرابط هنا هو 'cities' وليس 'get-nationalities'
  final response = await http.get(Uri.parse('${baseUrl}cities')); 
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    
    // تأكدي من طباعة responseData لترين ما الذي يصل فعلاً
    print("الرد من السيرفر للمدن: $responseData");
    
    List<dynamic> list = responseData['data']['cities'];
    return list.map((item) => item['name'].toString()).toList();
  } else {
    throw Exception('Failed to load cities');
  }
}

Future<Map<String, dynamic>> verifyCode(String code) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  print("إرسال الكود: $code مع التوكين: $token");

  final response = await http.post(
    Uri.parse('${baseUrl}email/verify'), // التعديل هنا: إضافة email/
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
    body: {'code': code},
  );

  print("نتيجة التحقق: ${response.statusCode} - ${response.body}");

  if (response.statusCode != 200) {
    throw Exception('الكود غير صحيح أو انتهت صلاحيته');
  }
  return jsonDecode(response.body);
}

// دالة إعادة إرسال الكود
Future<void> resendCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  final response = await http.post(
    Uri.parse('${baseUrl}email/resend'), // التعديل هنا: إضافة email/
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );  
  
  if (response.statusCode != 200) {
    throw Exception('فشل في إعادة إرسال الكود');
  }
}

Future<List<Doctor>> getDoctors(int subgrp) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token'); 

  final response = await http.post(
    Uri.parse('${baseUrl}doctors_by_department'), 
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
    body: {'subgrp': subgrp.toString()},
  );

  print("الرد النهائي من السيرفر: ${response.body}");

  if (response.statusCode == 200) {
    // 1. نقوم بفك ترميز الـ JSON
    final Map<String, dynamic> responseData = json.decode(response.body);
    
    // 2. نستخرج القائمة (التي تحمل اسم 'doctors')
    final List<dynamic> doctorsData = responseData['doctors'];

    // 3. نحول كل عنصر في القائمة إلى كائن من نوع Doctor
    return doctorsData.map((json) => Doctor.fromJson(json)).toList();
    
  } else {
    throw Exception('فشل الاتصال: ${response.statusCode}');
  }
}

Future<List<dynamic>> getPatientAppointments() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  final response = await http.get(
    Uri.parse('${baseUrl}patient-appointments'), 
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print("Patient Appointments Status: ${response.statusCode}");
  print("Patient Appointments Body: ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    final Map<String, dynamic> data = json.decode(response.body);

    // فحص جميع المفاتيح المحتملة التي قد ترجعها لارافل
    if (data.containsKey('upcoming_Appointment')) {
      return data['upcoming_Appointment'] ?? [];
    } else if (data.containsKey('upcoming_appointments')) {
      return data['upcoming_appointments'] ?? [];
    } else if (data.containsKey('data')) {
      return data['data'] ?? [];
    } else if (data.containsKey('appointments')) {
      return data['appointments'] ?? [];
    }
  }
  
  return [];
}
Future<List<VisitModel>> getVisits() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  final response = await http.get(
    Uri.parse('${baseUrl}pat_visits'), // تأكدي أن هذا هو الرابط الصحيح في api.php
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    // نقوم بتحويل قائمة الـ visits إلى VisitModel
    List<dynamic> visitsData = data['visits'];
    return visitsData.map((item) => VisitModel.fromJson(item)).toList();
  } else {
    throw Exception('فشل جلب الزيارات');
  }
}



Future<List<dynamic>> getDoctorTodayAppointments() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  // قراءة التوكن بالطريقتين لضمان عدم ضياعه
  String? token = prefs.getString('token') ?? prefs.getString('user_token'); 

  if (token == null) {
    print("🚨 تنبيه: التوكن غير موجود في الذاكرة! يرجى تسجيل الدخول.");
    throw Exception('غير مصرح لك، يرجى تسجيل الدخول من جديد.');
  }

  final response = await http.get(
    Uri.parse('${baseUrl}doctor-appointments'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print("Doctor All Appointments Response: ${response.body}");

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    
    // فحص جميع المفاتيح المحتملة القادمة من السيرفر لإرجاع القائمة كاملة
    if (data is List) {
      return data;
    } else if (data is Map) {
      return data['Appointments'] ?? data['appointments'] ?? data['data'] ?? [];
    }
  }
  
  return [];
}




Future<bool> acceptAppointment(int appointmentId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token') ?? prefs.getString('user_token');

    final response = await http.post(
      Uri.parse('${baseUrl}accept-appointment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'appointment_id': appointmentId.toString(),
      },
    );

    print("Accept Status: ${response.statusCode}");
    print("Accept Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'] == true;
    }
    return false;
  } catch (e) {
    print("Error accepting appointment: $e");
    return false;
  }
}
Future<bool> rejectAppointment(int appointmentId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token') ?? prefs.getString('user_token');

    final response = await http.post(
      Uri.parse('${baseUrl}reject-appointment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'appointment_id': appointmentId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'] == true;
    }
    return false;
  } catch (e) {
    print("Error rejecting appointment: $e");
    return false;
  }
}
}