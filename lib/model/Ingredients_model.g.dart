// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Ingredients_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeIngredientsAdapter extends TypeAdapter<RecipeIngredients> {
  @override
  final int typeId = 3;

  @override
  RecipeIngredients read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeIngredients(
      id: fields[0] as int,
      ingredient: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RecipeIngredients obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ingredient);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeIngredientsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
