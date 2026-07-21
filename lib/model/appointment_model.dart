// class Appointment {
//   final int id;
//   final String appointmentDate;
//   final String appointmentTime;
//   final String doctorName; // السيرفر يرسل doctor_name

//   Appointment({
//     required this.id,
//     required this.appointmentDate,
//     required this.appointmentTime,
//     required this.doctorName,
//   });

//   factory Appointment.fromJson(Map<String, dynamic> json) {
//     return Appointment(
//       id: json['id'],
//       appointmentDate: json['appointment_date'] ?? '',
//       appointmentTime: json['time'] ?? '', // السيرفر يرسل المفتاح باسم 'time'
//       doctorName: json['doctor_name'] ?? 'غير معروف', // السيرفر يرسل 'doctor_name'
//     );
//   }
// }
class Appointment {
  final int id;
  final String appointmentDate;
  final String appointmentTime;
  final String doctorName;

  Appointment({
    required this.id,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.doctorName,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    // 1. استخراج واستخلاص التاريخ والوقت من حقل d_start أو appointment_date
    String rawDate = json['d_start'] ?? json['appointment_date'] ?? '';
    String extractedDate = '';
    String extractedTime = json['time'] ?? '';

    if (rawDate.isNotEmpty) {
      // إذا كان النص يحتوي على صيغة مثل: "2026-10-14 الساعة: 10:00 PM"
      List<String> parts = rawDate.split(' ');
      extractedDate = parts[0]; // تأخذ فقط "2026-10-14"

      // إذا لم يكن الوقت موجوداً في مفتاح 'time' نستخرجه من النص
      if (extractedTime.isEmpty && parts.length > 1) {
        extractedTime = rawDate.replaceAll(parts[0], '').replaceAll('الساعة:', '').trim();
      }
    }

    // 2. استخراج اسم الطبيب أو العيادة بأمان لتجنب ظهور null أو "غير معروف"
    String docName = json['doctor_name'] ?? '';
    if (docName.isEmpty && json['gnr_m_clinics'] != null) {
      docName = json['gnr_m_clinics']['name_ar'] ?? '';
    }
    if (docName.isEmpty) {
      docName = 'غير معروف';
    }

    return Appointment(
      id: json['id'] ?? 0,
      appointmentDate: extractedDate.isNotEmpty ? extractedDate : (json['appointment_date'] ?? ''),
      appointmentTime: extractedTime.isNotEmpty ? extractedTime : '00:00',
      doctorName: docName,
    );
  }
}