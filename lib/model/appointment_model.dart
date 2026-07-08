class Appointment {
  final int id;
  final String appointmentDate;
  final String appointmentTime;
  final String doctorName; // السيرفر يرسل doctor_name

  Appointment({
    required this.id,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.doctorName,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      appointmentDate: json['appointment_date'] ?? '',
      appointmentTime: json['time'] ?? '', // السيرفر يرسل المفتاح باسم 'time'
      doctorName: json['doctor_name'] ?? 'غير معروف', // السيرفر يرسل 'doctor_name'
    );
  }
}