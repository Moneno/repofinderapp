// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GitRepositoryAdapter extends TypeAdapter<GitRepository> {
  @override
  final int typeId = 0;

  @override
  GitRepository read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GitRepository(
      username: fields[0] as String?,
      stargazers: fields[1] as String?,
      watchers: fields[2] as String?,
      reposName: fields[3] as String?,
      userImage: fields[4] as String?,
      reposUrl: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GitRepository obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.stargazers)
      ..writeByte(2)
      ..write(obj.watchers)
      ..writeByte(3)
      ..write(obj.reposName)
      ..writeByte(4)
      ..write(obj.userImage)
      ..writeByte(5)
      ..write(obj.reposUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitRepositoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
