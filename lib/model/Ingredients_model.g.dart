// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Ingredients_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IngredientsModelAdapter extends TypeAdapter<IngredientsModel> {
  @override
  final int typeId = 1;

  @override
  IngredientsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IngredientsModel(
      ingredients: (fields[2] as List).cast<String>(),
      recipeId: fields[1] as int,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, IngredientsModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.recipeId)
      ..writeByte(2)
      ..write(obj.ingredients);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
