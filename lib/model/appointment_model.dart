
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
    String rawDate = json['d_start'] ?? json['appointment_date'] ?? '';
    String extractedDate = '';
    String extractedTime = json['time'] ?? '';

    if (rawDate.isNotEmpty) {
      List<String> parts = rawDate.split(' ');
      extractedDate = parts[0]; 

      if (extractedTime.isEmpty && parts.length > 1) {
        extractedTime = rawDate.replaceAll(parts[0], '').replaceAll('الساعة:', '').trim();
      }
    }

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