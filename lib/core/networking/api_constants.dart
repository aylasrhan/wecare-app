

class ApiConstants {
  // عنوان خادم الـ API الوحيد للتطبيق. يجب أن يكون الهاتف واللابتوب
  // على الشبكة نفسها عند التشغيل على جهاز Android حقيقي.
  static const String baseUrl = 'http://192.168.0.21:8000/api';
   //  static const String baseUrl = "http://10.0.2.2:8000/api/";

  static const String loginEndpoint = 'Api_login';

  static Uri endpoint(
    String path, {
    Map<String, String>? queryParameters,
  }) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('$baseUrl/$normalizedPath').replace(
      queryParameters: queryParameters,
    );
  }
}
