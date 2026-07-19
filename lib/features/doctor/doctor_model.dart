class DoctorModel {
  final int id;
  final String nameAr;
  final String fromTime;
  final String toTime;
  final String slotTime;

  DoctorModel({required this.id, required this.nameAr, required this.fromTime, required this.toTime, required this.slotTime});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      nameAr: json['name_ar'],
      fromTime: json['from_time'],
      toTime: json['to_time'],
      slotTime: json['slot_time'],
    );
  }
}