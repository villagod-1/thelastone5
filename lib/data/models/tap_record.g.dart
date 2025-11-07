// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tap_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TapRecordAdapter extends TypeAdapter<TapRecord> {
  @override
  final int typeId = 0;

  @override
  TapRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TapRecord(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      cycleId: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TapRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.cycleId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TapRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
