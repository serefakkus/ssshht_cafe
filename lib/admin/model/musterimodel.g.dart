// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'musterimodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuAdapter extends TypeAdapter<Menu> {
  @override
  final int typeId = 0;

  @override
  Menu read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Menu(
      mongoid: fields[0] as String?,
      istekTip: fields[1] as String?,
      status: fields[2] as bool?,
      cafeId: fields[3] as int?,
      kategori: (fields[4] as List?)?.cast<Kategori>(),
    );
  }

  @override
  void write(BinaryWriter writer, Menu obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.mongoid)
      ..writeByte(1)
      ..write(obj.istekTip)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.cafeId)
      ..writeByte(4)
      ..write(obj.kategori);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MenuUrunAdapter extends TypeAdapter<MenuUrun> {
  @override
  final int typeId = 1;

  @override
  MenuUrun read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuUrun(
      adet: fields[1] as int?,
      durum: fields[2] as bool?,
      icerik: (fields[10] as List?)?.cast<String>(),
      indirim: fields[8] as double?,
      name: fields[3] as String?,
      no: fields[0] as int?,
      puan: fields[7] as double?,
      resimId: fields[9] as String?,
      tarif: fields[6] as String?,
      ucret: fields[4] as double?,
      ucretType: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, MenuUrun obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.adet)
      ..writeByte(2)
      ..write(obj.durum)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.ucret)
      ..writeByte(5)
      ..write(obj.ucretType)
      ..writeByte(6)
      ..write(obj.tarif)
      ..writeByte(7)
      ..write(obj.puan)
      ..writeByte(8)
      ..write(obj.indirim)
      ..writeByte(9)
      ..write(obj.resimId)
      ..writeByte(10)
      ..write(obj.icerik);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuUrunAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
