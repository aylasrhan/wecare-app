class VisitModel {
  final int id;
  final String clinicName; 
  final int status;        
  final String startTime;  

  VisitModel({
    required this.id,
    required this.clinicName,
    required this.status,
    required this.startTime,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'],
      clinicName: json['gnr_m_clinics']?['name_ar'] ?? "عيادة غير معروفة",
      status: json['status'],
      startTime: json['d_start'],
    );
  }
}