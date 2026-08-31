class Doctor {
  final int id;
  final String nameAr;
  final String? fromTime;
  final String? toTime;
  final int? slotTime;
  final String? specializationAr;

  Doctor({
    required this.id,
    required this.nameAr,
    this.fromTime,
    this.toTime,
    this.slotTime,
    this.specializationAr,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      nameAr: json['name_ar'] ?? 'غير معروف',
      fromTime: json['from_time']?.toString(),
      toTime: json['to_time']?.toString(),
      specializationAr: json['specialization_ar'],
      slotTime: json['slot_time'] is int ? json['slot_time'] : int.tryParse(json['slot_time'].toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'from_time': fromTime,
      'to_time': toTime,
      'slot_time': slotTime,
      'specialization_ar': specializationAr,
    };
  }
}