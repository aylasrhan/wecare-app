
class UserModel {
  final String token;
  final String role;

  UserModel({required this.token, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {}; 
    
    return UserModel(
      token: (data['user_token'] ?? "").toString(), 
      role: (data['roles_name'] ?? "").toString(),
    );
  }
}