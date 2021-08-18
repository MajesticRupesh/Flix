// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movielist.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieListAdapter extends TypeAdapter<MovieList> {
  @override
  final int typeId = 0;

  @override
  MovieList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieList()
      ..name = fields[0] as String
      ..director = fields[1] as String
      ..rating = fields[2] as double;
  }

  @override
  void write(BinaryWriter writer, MovieList obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.director)
      ..writeByte(2)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
