class VisitModel {
  final int id;
  final String clinicName; // سيأتي من العلاقة مع gnr_m_clinics
  final int status;        // 0 لـ UnCompleted مثلاً
  final String startTime;  // التاريخ المنسق

  VisitModel({
    required this.id,
    required this.clinicName,
    required this.status,
    required this.startTime,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'],
      // نتحقق من وجود اسم العيادة في العلاقة
      clinicName: json['gnr_m_clinics']?['name_ar'] ?? "عيادة غير معروفة",
      status: json['status'],
      startTime: json['d_start'],
    );
  }
}