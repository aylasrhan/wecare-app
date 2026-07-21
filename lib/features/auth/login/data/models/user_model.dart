class UserModel {
  final String token;
  final String role;

  UserModel({required this.token, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // نقرأ التوكين مباشرة من json وليس من data
      token: (json['user_token'] ?? "").toString(),

      // نقرأ الدور مباشرة أيضاً (مع إعطاء قيمة فارغة في حال لم يرسله السيرفر كما في Login)
      role: (json['roles_name'] ?? "").toString(),
    );
  }
}
