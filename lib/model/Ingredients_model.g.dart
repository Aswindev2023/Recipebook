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
      ingredient: (fields[1] as List).cast<String>(),
    )
      ..id = fields[0] as int
      ..recipeId = fields[2] as int;
  }

  @override
  void write(BinaryWriter writer, RecipeIngredients obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ingredient)
      ..writeByte(2)
      ..write(obj.recipeId);
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
