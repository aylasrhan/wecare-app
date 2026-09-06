
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wecare/core/networking/api_constants.dart';
import 'package:wecare/features/auth/login/data/models/user_model.dart';
import 'package:wecare/model/doctor_model.dart';
import 'package:wecare/model/visit_model.dart';


class AuthService {
Future<String> bookAppointment({
  required dynamic doctor, 
  required String date,
  required String time,
}) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token') ?? prefs.getString('user_token'); 

    int doctorId;
    if (doctor is int) {
      doctorId = doctor;
    } else if (doctor is Map) {
      doctorId = doctor['id'];
    } else {
      doctorId = doctor.id; 
    }

    print("🚨 [FINAL FIX] Booking with true Doctor ID: $doctorId for Date: $date, Time: $time");

    final response = await http.post(
      ApiConstants.endpoint('appointment-store'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'appointment_with': doctorId,
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

    final response = await http.get(
      ApiConstants.endpoint(
        'booked-times',
        queryParameters: {
          'doctor_id': doctorId.toString(),
          'date': date,
        },
      ),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return List<String>.from(data['booked_times']);
      }
    }
    return []; 
  } catch (e) {
    print("Error fetching booked times: $e");
    return [];
  }
}



Future<UserModel> login(String email, String password) async {
  final response = await http.post(
    ApiConstants.endpoint(ApiConstants.loginEndpoint),
    body: {'email': email, 'password': password},
  );
  
  final responseData = json.decode(response.body);
  
  if (response.statusCode == 200) {
    final data = responseData['data']; 
    
    if (data != null && data is Map) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
     
      if (data.containsKey('user_token')) { 
        String tokenValue = data['user_token'];
        await prefs.setString('token', tokenValue);      
        await prefs.setString('user_token', tokenValue); 
        print("تم حفظ التوكين بنجاح بالاسمين");
      }
      
     
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
      ApiConstants.endpoint('profile'),
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
  int? sex,          
  String? blood,
  int? city,         
  int? nationality,  
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
  if (city != null) body['p_city'] = city.toString();         
  if (nationality != null) body['nationality'] = nationality.toString(); 
  if (address != null) body['address'] = address;
  if (specialization != null) body['specialization'] = specialization;

  final response = await http.post(
    ApiConstants.endpoint('register'),
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
    print("جاري الاتصال بـ: ${ApiConstants.endpoint('get-nationalities')}");
    
    final response = await http.get(ApiConstants.endpoint('get-nationalities'));
    
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
    print("خطأ كشف الاتصال: $e"); 
    throw e;
  }
}
Future<List<String>> getCities() async {
  final response = await http.get(ApiConstants.endpoint('cities'));
  
  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    
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
    ApiConstants.endpoint('email/verify'),
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

Future<void> resendCode() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  final response = await http.post(
    ApiConstants.endpoint('email/resend'),
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
    ApiConstants.endpoint('doctors_by_department'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
    body: {'subgrp': subgrp.toString()},
  );

  print("الرد النهائي من السيرفر: ${response.body}");

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    
    final List<dynamic> doctorsData = responseData['doctors'];

    return doctorsData.map((json) => Doctor.fromJson(json)).toList();
    
  } else {
    throw Exception('فشل الاتصال: ${response.statusCode}');
  }
}

Future<List<dynamic>> getPatientAppointments() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('user_token');

  final response = await http.get(
    ApiConstants.endpoint('patient-appointments'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print("Patient Appointments Status: ${response.statusCode}");
  print("Patient Appointments Body: ${response.body}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    final Map<String, dynamic> data = json.decode(response.body);

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
    ApiConstants.endpoint('pat_visits'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    List<dynamic> visitsData = data['visits'];
    return visitsData.map((item) => VisitModel.fromJson(item)).toList();
  } else {
    throw Exception('فشل جلب الزيارات');
  }
}



Future<List<dynamic>> getDoctorTodayAppointments() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  String? token = prefs.getString('token') ?? prefs.getString('user_token'); 

  if (token == null) {
    print("🚨 تنبيه: التوكن غير موجود في الذاكرة! يرجى تسجيل الدخول.");
    throw Exception('غير مصرح لك، يرجى تسجيل الدخول من جديد.');
  }

  final response = await http.get(
    ApiConstants.endpoint('doctor-appointments'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print("Doctor All Appointments Response: ${response.body}");

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    
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
      ApiConstants.endpoint('accept-appointment'),
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
      ApiConstants.endpoint('reject-appointment'),
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




  Future<bool> submitDoctorReview({
    required int doctorId,
    required int patientId,
    required int rating,
    String? comment,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token') ?? prefs.getString('user_token');

      if (token == null) {
        print("🚨 خطأ: لا يوجد توكن مسجل.");
        return false;
      }

      print("جاري إرسال التقييم... الطبيب: $doctorId | التقييم: $rating");

      final response = await http.post(
        ApiConstants.endpoint('doctor/rate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'doctor_id': doctorId,
          'user_id': patientId,
          'rating': rating,
          'comment': comment ?? '',
        }),
      );

      print("حالة رد التقييم: ${response.statusCode}");
      print("محتوى رد التقييم: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("حدث خطأ أثناء إرسال التقييم: $e");
      return false;
    }
  }
}
