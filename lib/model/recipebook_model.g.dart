// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipebook_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeDetailsAdapter extends TypeAdapter<RecipeDetails> {
  @override
  final int typeId = 0;

  @override
  RecipeDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeDetails(
      name: fields[1] as String,
      description: fields[2] as String,
      cookTime: fields[3] as String,
      selectedCategory: fields[4] as String,
      imageUrls: (fields[5] as List).cast<String>(),
      selectedUnit: fields[6] as String?,
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, RecipeDetails obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.cookTime)
      ..writeByte(4)
      ..write(obj.selectedCategory)
      ..writeByte(5)
      ..write(obj.imageUrls)
      ..writeByte(6)
      ..write(obj.selectedUnit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
