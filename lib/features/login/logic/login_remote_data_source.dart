import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/networking/api_constants.dart';

class LoginRemoteDataSource {
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.loginEndpoint),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      // هذا هو الـ Token الذي سيعطيكِ صلاحية الدخول لباقي التطبيق
      return jsonResponse['data']['user_token']; 
    } else {
      throw Exception('فشل تسجيل الدخول: تحقق من الإيميل وكلمة السر');
    }
  }
}