class Appointment {
  final int id;
  final String appointmentDate;
  final String appointmentTime;
  final String status;
  final Map<String, dynamic>? doctor; // لجلب بيانات الطبيب المرتبطة

  Appointment({
    required this.id,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    this.doctor,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      appointmentDate: json['appointment_date'] ?? '',
      appointmentTime: json['appointment_time'] ?? '',
      status: json['status'] ?? '',
      // هنا نربط بيانات الطبيب إذا كانت موجودة في الـ JSON
      doctor: json['doctor'] != null ? Map<String, dynamic>.from(json['doctor']) : null,
    );
  }
}