import 'package:hive/hive.dart';

part 'tap_record.g.dart';

@HiveType(typeId: 0)
class TapRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final int cycleId;

  TapRecord({
    required this.id,
    required this.timestamp,
    required this.cycleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'cycleId': cycleId,
    };
  }

  factory TapRecord.fromJson(Map<String, dynamic> json) {
    return TapRecord(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      cycleId: json['cycleId'] as int,
    );
  }
}
