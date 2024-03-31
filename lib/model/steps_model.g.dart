// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steps_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StepsModelAdapter extends TypeAdapter<StepsModel> {
  @override
  final int typeId = 3;

  @override
  StepsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepsModel(
      recipeId: fields[1] as int,
      steps: (fields[2] as List).cast<String>(),
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, StepsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.recipeId)
      ..writeByte(2)
      ..write(obj.steps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
