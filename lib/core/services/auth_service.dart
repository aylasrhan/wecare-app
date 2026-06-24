
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wecare/features/auth/login/data/models/user_model.dart';

class AuthService {
  final String baseUrl = "http://10.0.2.2:8000/api/";

  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}Api_login'),
      body: {'email': email, 'password': password},
    );
    
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Failed to login');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String motherName,
    required String mobile,
    required String birthDate,
    required String sex,
    required String blood,
    required String city,
    required String nationality,
    required String address,
  }) async {
    final response = await http.post(
      Uri.parse('${baseUrl}register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'c_password': passwordConfirmation,
        'mother_name': motherName,
        'mobile': mobile,
        'birth_date': birthDate,
        'sex': sex,
        'blood': blood,
        'p_city': city,
        'nationality': nationality,
        'address': address,
      },
    );

    print("Register Status: ${response.statusCode}");
    print("Register Body: ${response.body}");

    final data = json.decode(response.body);
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to register');
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
}