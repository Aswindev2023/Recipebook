// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'steps_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeStepsAdapter extends TypeAdapter<RecipeSteps> {
  @override
  final int typeId = 1;

  @override
  RecipeSteps read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeSteps(
      step: (fields[1] as List).cast<String>(),
    )
      ..id = fields[0] as int
      ..recipeId = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, RecipeSteps obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.step)
      ..writeByte(2)
      ..write(obj.recipeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeStepsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
