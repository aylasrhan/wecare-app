// class UserModel {
//   final String? token;
//   final String? role;

//   UserModel({this.token, this.role});

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     // التأكد من وجود مفتاح 'data' أولاً
//     final data = json['data'] ?? {}; 
    
//     return UserModel(
//       // استخدام القيمة أو null إذا لم توجد
//       token: data['user_token']?.toString(), 
//       role: data['roles_name']?.toString(),
//     );
//   }
// }