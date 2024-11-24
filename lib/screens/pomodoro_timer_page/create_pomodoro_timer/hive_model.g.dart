// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveModelAdapter extends TypeAdapter<HiveModel> {
  @override
  final int typeId = 0;

  @override
  HiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveModel()
      ..studSessionName = fields[0] as String
      ..selectedStudSession = fields[1] as String
      ..alarmSound = fields[2] as String
      ..isAutoStartSwitched = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, HiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.studSessionName)
      ..writeByte(1)
      ..write(obj.selectedStudSession)
      ..writeByte(2)
      ..write(obj.alarmSound)
      ..writeByte(3)
      ..write(obj.isAutoStartSwitched);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
