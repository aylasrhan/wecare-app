
class UserModel {
  final String token;
  final String role;

  UserModel({required this.token, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // التأكد من وجود مفتاح 'data'
    final data = json['data'] ?? {}; 
    
    return UserModel(
      // إذا كانت القيمة null، سيعيد نصاً فارغاً "" بدلاً من null
      token: (data['user_token'] ?? "").toString(), 
      role: (data['roles_name'] ?? "").toString(),
    );
  }
}