import 'package:hive/hive.dart';

part 'cycle.g.dart';

@HiveType(typeId: 1)
class Cycle extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final DateTime startDate;

  @HiveField(2)
  final DateTime? endDate;

  @HiveField(3)
  final bool isActive;

  Cycle({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Cycle.fromJson(Map<String, dynamic> json) {
    return Cycle(
      id: json['id'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String) 
          : null,
      isActive: json['isActive'] as bool,
    );
  }

  Cycle copyWith({
    int? id,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return Cycle(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }
}
