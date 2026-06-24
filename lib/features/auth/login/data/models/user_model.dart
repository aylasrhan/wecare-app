class UserModel {
  final String token;
  // يمكنك إضافة بيانات إضافية مثل الاسم أو الدور إذا كان الـ API يرسلها
  UserModel({required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      token: json['user_token'], // هذا هو المفتاح الذي يرسله الـ ApiAuthController
    );
  }
}