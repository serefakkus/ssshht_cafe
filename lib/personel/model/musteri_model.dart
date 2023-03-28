import 'dart:convert';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';
part 'musterimodel.g.dart';

@HiveType(typeId: 0)
class Menu {
  Menu({
    this.mongoid,
    this.istekTip,
    this.status,
    this.cafeId,
    this.kategori,
  });

  @HiveField(0)
  String? mongoid;

  @HiveField(1)
  String? istekTip;

  @HiveField(2)
  bool? status;

  @HiveField(3)
  int? cafeId;

  @HiveField(4)
  List<Kategori>? kategori;

  factory Menu.fromMap(Map<String, dynamic> json) => Menu(
        mongoid: json["mongoid"],
        istekTip: json["istek_tip"],
        status: json["status"],
        cafeId: json["cafe_id"],
        kategori: json["kategori"],
      );

  Map<String, dynamic> toMap() => {
        "mongoid": mongoid,
        "istek_tip": istekTip,
        "status": status,
        "cafe_id": cafeId,
        "kategori": kategori,
      };
}

class Kategori {
  Kategori({
    this.menuUrun,
    this.name,
  });
  String? name;
  List<MenuUrun>? menuUrun;

  factory Kategori.fromMap(Map<String, dynamic> json) => Kategori(
        name: json["name"],
        menuUrun: json["urun"],
      );

  Map<String, dynamic> toMap() => {
        "urun": menuUrun,
        "name": name,
      };
}

@HiveType(typeId: 1)
class MenuUrun {
  MenuUrun({
    this.adet,
    this.durum,
    this.icerik,
    this.indirim,
    this.name,
    this.no,
    this.puan,
    this.resimId,
    this.tarif,
    this.ucret,
    this.ucretType,
  });

  @HiveField(0)
  int? no;

  @HiveField(1)
  int? adet;

  @HiveField(2)
  bool? durum;

  @HiveField(3)
  String? name;

  @HiveField(4)
  double? ucret;

  @HiveField(5)
  int? ucretType;

  @HiveField(6)
  String? tarif;

  @HiveField(7)
  double? puan;

  @HiveField(8)
  double? indirim;

  @HiveField(9)
  String? resimId;

  @HiveField(10)
  List<String>? icerik;

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'adet': adet,
      'durum': durum,
      'name': name,
      'ucret': ucret,
      'ucretType': ucretType,
      'tarif': tarif,
      'puan': puan,
      'indirim': indirim,
      'resimId': resimId,
      'icerik': icerik,
    };
  }

  factory MenuUrun.fromMap(Map<String, dynamic> map) {
    return MenuUrun(
      no: map['no']?.toInt(),
      adet: map['adet']?.toInt(),
      durum: map['durum'],
      name: map['name'],
      ucret: map['ucret']?.toDouble(),
      ucretType: map['ucretType']?.toInt(),
      tarif: map['tarif'],
      puan: map['puan']?.toDouble(),
      indirim: map['indirim']?.toDouble(),
      resimId: map['resimId'],
      icerik: List<String>.from(map['icerik']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuUrun.fromJson(String source) =>
      MenuUrun.fromMap(json.decode(source));
}

@HiveType(typeId: 2)
class NewPhone {
  NewPhone({
    this.istekTip,
    this.status,
    this.no,
    this.phone,
  });

  @HiveField(0)
  String? istekTip;

  @HiveField(1)
  bool? status;

  @HiveField(2)
  String? no;

  @HiveField(3)
  Phone? phone;

  factory NewPhone.fromMap(Map<String, dynamic> json) => NewPhone(
        istekTip: json["istek_tip"],
        status: json["status"],
        no: json["no"],
        phone: Phone.fromMap(json["phone"]),
      );

  Map<String, dynamic> toMap() => {
        "istek_tip": istekTip,
        "status": status,
        "no": no,
        "phone": phone?.toMap(),
      };
}

@HiveType(typeId: 3)
class Phone {
  Phone({
    this.istekTip,
    this.status,
    this.id,
    this.userId,
    this.userType,
    this.ok,
    this.no,
    this.code,
    this.rawTime,
    this.time,
  });

  @HiveField(0)
  String? istekTip;

  @HiveField(1)
  bool? status;

  @HiveField(2)
  int? id;

  @HiveField(3)
  int? userId;

  @HiveField(4)
  int? userType;

  @HiveField(5)
  bool? ok;

  @HiveField(6)
  String? no;

  @HiveField(7)
  String? code;

  @HiveField(8)
  dynamic rawTime;

  @HiveField(9)
  DateTime? time;

  factory Phone.fromMap(Map<String, dynamic> json) => Phone(
        istekTip: json["istek_tip"],
        status: json["status"],
        id: json["id"],
        userId: json["user_id"],
        userType: json["user_type"],
        ok: json["ok"],
        no: json["no"],
        code: json["code"],
        rawTime: json["raw_time"],
        time: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toMap() => {
        "istek_tip": istekTip,
        "status": status,
        "id": id,
        "user_id": userId,
        "user_type": userType,
        "ok": ok,
        "no": no,
        "code": code,
        "raw_time": rawTime,
        "time": time?.toIso8601String(),
      };
}

Musteri musteriFromMap(String str) => Musteri.fromMap(json.decode(str));

String musteriToMap(Musteri data) => json.encode(data.toMap());

class Musteri {
  Musteri({
    this.id,
    this.istekTip,
    this.status,
    this.cafeId,
    this.qrCode,
    this.cafePuan,
    this.tokens,
    this.info,
    this.phone,
    this.sign,
    this.cafeInfo,
    this.cafeAyar,
    this.masaCode,
    this.puan,
    this.menu,
    this.newPhone,
    this.siparis,
    this.siparisArsiv,
    this.mediaIp,
    this.mediaResp,
    this.siparisSor,
  });

  int? id;
  String? istekTip;
  bool? status;
  int? cafeId;
  String? qrCode;
  int? cafePuan;
  Tokens? tokens;
  Info? info;
  Phone? phone;
  Sign? sign;
  CafeInfo? cafeInfo;
  CafeAyar? cafeAyar;
  MasaCode? masaCode;
  Puan? puan;
  Menu? menu;
  NewPhone? newPhone;
  Siparis? siparis;
  SiparisArsivSor? siparisArsiv;
  dynamic mediaIp;
  dynamic mediaResp;
  SiparisSor? siparisSor;

  factory Musteri.fromMap(Map<String, dynamic> json) => Musteri(
        id: json["id"],
        istekTip: json["istek_tip"],
        status: json["status"],
        cafeId: json["cafe_id"],
        qrCode: json["qr_code"],
        cafePuan: json["cafe_puan"],
        tokens: Tokens.fromJson(json["tokens"]),
        info: Info.fromMap(json["info"]),
        phone: Phone.fromMap(json["phone"]),
        sign: Sign.fromMap(json["sign"]),
        cafeInfo: CafeInfo.fromJson(json["cafe_info"]),
        cafeAyar: CafeAyar.fromMap(json["cafe_ayar"]),
        masaCode: MasaCode.fromMap(json["masa_code"]),
        puan: Puan.fromJson((json["puan"])),
        menu: Menu.fromMap(json["menu"]),
        newPhone: NewPhone.fromMap(json["new_phone"]),
        siparis: Siparis.fromJson(json["siparis"]),
        siparisArsiv: SiparisArsivSor.fromMap(json["siparisarsiv"]),
        mediaIp: json["media_ip"],
        mediaResp: json["media_resp"],
        siparisSor: SiparisSor.fromJson(json["siparis_sor"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "istek_tip": istekTip,
        "status": status,
        "cafe_id": cafeId,
        "qr_code": qrCode,
        "cafe_puan": cafePuan,
        "tokens": tokens?.toJson(),
        "info": info?.toMap(),
        "phone": phone?.toMap(),
        "sign": sign?.toMap(),
        "cafe_info": cafeInfo?.toJson(),
        "cafe_ayar": cafeAyar?.toMap(),
        "masa_code": masaCode?.toMap(),
        "puan": puan?.toJson(),
        "menu": menu?.toMap(),
        "new_phone": newPhone?.toMap(),
        "siparis": siparis?.toJson(),
        "siparisarsiv": siparisArsiv?.toMap(),
        "media_ip": mediaIp,
        "media_resp": mediaResp,
        "siparis_sor": siparisSor,
      };
}

class CafeAyar {
  CafeAyar({
    this.mongoid,
    this.istekType,
    this.status,
    this.cafeId,
    this.puan,
    this.rez,
  });

  String? mongoid;
  String? istekType;
  bool? status;
  int? cafeId;
  bool? puan;
  int? rez;

  factory CafeAyar.fromMap(Map<String, dynamic> json) => CafeAyar(
        mongoid: json["mongoid"],
        istekType: json["istek_type"],
        status: json["status"],
        cafeId: json["cafe_id"],
        puan: json["puan"],
        rez: json["rez"],
      );

  Map<String, dynamic> toMap() => {
        "mongoid": mongoid,
        "istek_type": istekType,
        "status": status,
        "cafe_id": cafeId,
        "puan": puan,
        "rez": rez,
      };
}

class CafeInfo {
  CafeInfo({
    this.id,
    this.name,
    this.tanim,
    this.time,
    this.rawTime,
    this.photoId,
    this.istekTip,
    this.status,
    this.cafeLoc,
  });

  int? id;
  String? name;
  String? tanim;
  String? time;
  dynamic rawTime;
  String? photoId;
  String? istekTip;
  bool? status;
  CafeLoc? cafeLoc;

  CafeInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    tanim = json['tanim'];
    time = json['time'];
    rawTime = json['raw_time'];
    photoId = json['photo_id'];
    istekTip = json['istek_tip'];
    status = json['status'];
    cafeLoc =
        json['cafe_loc'] != null ? CafeLoc.fromMap(json['cafe_loc']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['tanim'] = tanim;
    data['time'] = time;
    data['raw_time'] = rawTime;
    data['photo_id'] = photoId;
    data['istek_tip'] = istekTip;
    data['status'] = status;
    if (cafeLoc != null) {
      data['cafe_loc'] = cafeLoc!.toMap();
    }
    return data;
  }
}

class CafeLoc {
  CafeLoc({
    this.id,
    this.locX,
    this.locY,
  });

  int? id;
  dynamic locX;
  dynamic locY;

  factory CafeLoc.fromMap(Map<String, dynamic> json) => CafeLoc(
        id: json["id"],
        locX: json["loc_x"],
        locY: json["loc_y"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "loc_x": locX,
        "loc_y": locY,
      };
}

class Info {
  Info({
    this.id,
    this.name,
    this.tip,
    this.birthdate,
    this.rawBirthdate,
    this.gender,
    this.time,
    this.rawTime,
    this.photoId,
    this.istekTip,
    this.status,
  });

  int? id;
  String? name;
  bool? tip;
  dynamic birthdate;
  dynamic rawBirthdate;
  int? gender;
  dynamic time;
  dynamic rawTime;
  String? photoId;
  String? istekTip;
  bool? status;

  factory Info.fromMap(Map<String, dynamic> json) => Info(
        id: json["id"],
        name: json["name"],
        tip: json["tip"],
        birthdate: json["birthdate"],
        rawBirthdate: json["raw_birthdate"],
        gender: json["gender"],
        time: json["time"],
        rawTime: json["raw_time"],
        photoId: json["photo_id"],
        istekTip: json["istek_tip"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "tip": tip,
        "birthdate": birthdate,
        "raw_birthdate": rawBirthdate,
        "gender": gender,
        "time": time,
        "raw_time": rawTime,
        "photo_id": photoId,
        "istek_tip": istekTip,
        "status": status,
      };
}

class MasaCode {
  MasaCode({
    this.status,
    this.istekTip,
    this.id,
    this.cafeId,
    this.masaNo,
    this.code,
    this.rawTime,
    this.time,
    this.masaCode,
  });

  bool? status;
  String? istekTip;
  String? id;
  int? cafeId;
  String? masaNo;
  String? code;
  dynamic rawTime;
  String? time;
  String? masaCode;

  factory MasaCode.fromMap(Map<String, dynamic> json) => MasaCode(
        status: json["status"],
        istekTip: json["istek_tip"],
        id: json["id"],
        cafeId: json["cafe_id"],
        masaNo: json["masa_no"],
        code: json["code"],
        rawTime: json["raw_time"],
        time: json["time"],
        masaCode: json['masa_code'],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "istek_tip": istekTip,
        "id": id,
        "cafe_id": cafeId,
        "masa_no": masaNo,
        "code": code,
        "raw_time": rawTime,
        "time": time,
        "masa_code": masaCode,
      };
}

class Puan {
  Puan({
    this.istekTip,
    this.status,
    this.id,
    this.musteriId,
    this.puan,
  });

  String? istekTip;
  bool? status;
  String? id;
  int? musteriId;
  List<CafePuan>? puan;

  Puan.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    istekTip = json['istek_tip'];
    status = json['status'];
    musteriId = json['musteri_id'];
    if (json['puan'] != null) {
      puan = <CafePuan>[];
      json['puan'].forEach((v) {
        puan!.add(CafePuan.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['istek_tip'] = istekTip;
    data['status'] = status;
    data['musteri_id'] = musteriId;
    if (puan != null) {
      data['puan'] = puan!.map((v) => v.toMap()).toList();
    }
    return data;
  }
}

class CafePuan {
  CafePuan({
    this.cafeId,
    this.puan,
  });
  int? cafeId;
  double? puan;
  factory CafePuan.fromMap(Map<String, dynamic> json) => CafePuan(
        cafeId: json["cafe_id"],
        puan: double.parse(json["puan"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "cafe_id": cafeId,
        "puan": puan,
      };
}

class Sign {
  Sign({
    this.code,
    this.istekTip,
    this.id,
    this.name,
    this.phone,
    this.pass,
    this.newPass,
    this.mail,
    this.userType,
    this.cafeId,
    this.status,
  });

  String? code;
  String? istekTip;
  int? id;
  String? name;
  String? phone;
  String? pass;
  String? newPass;
  String? mail;
  int? userType;
  int? cafeId;
  bool? status;

  factory Sign.fromMap(Map<String, dynamic> json) => Sign(
        code: json["code"],
        istekTip: json["istek_tip"],
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        pass: json["pass"],
        newPass: json["new_pass"],
        mail: json["mail"],
        userType: json["user_type"],
        cafeId: json["cafe_id"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "istek_tip": istekTip,
        "id": id,
        "name": name,
        "phone": phone,
        "pass": pass,
        "new_pass": newPass,
        "mail": mail,
        "user_type": userType,
        "cafe_id": cafeId,
        "status": status,
      };
}

class Siparis {
  String? id;
  String? istekTip;
  bool? status;
  String? newDay;
  int? cafeId;
  String? not;
  String? cafeNot;
  int? musteriId;
  int? hazirlayanId;
  int? garsonId;
  bool? iptal;
  String? siparisId;
  String? masaNo;
  List<SiparisUrun>? urun;
  Uint8List? time;

  Siparis({
    this.id,
    this.istekTip,
    this.status,
    this.newDay,
    this.cafeId,
    this.not,
    this.cafeNot,
    this.musteriId,
    this.hazirlayanId,
    this.garsonId,
    this.iptal,
    this.siparisId,
    this.masaNo,
    this.urun,
    this.time,
  });

  Siparis.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    istekTip = json['istek_tip'];
    status = json['status'];
    newDay = json['new_day'];
    cafeId = json['cafe_id'];
    not = json['not'];
    cafeNot = json['cafe_not'];
    musteriId = json['musteri_id'];
    hazirlayanId = json['hazirlayan_id'];
    garsonId = json['garson_id'];
    iptal = json['iptal'];
    siparisId = json['siparis_id'];
    masaNo = json['masa_no'];
    if (json['urun'] != null) {
      urun = <SiparisUrun>[];
      json['urun'].forEach((v) {
        urun!.add(SiparisUrun.fromMap(v));
      });
    }
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['istek_tip'] = istekTip;
    data['status'] = status;
    data['new_day'] = newDay;
    data['cafe_id'] = cafeId;
    data['not'] = not;
    data['cafe_not'] = cafeNot;
    data['musteri_id'] = musteriId;
    data['hazirlayan_id'] = hazirlayanId;
    data['garson_id'] = garsonId;
    data['iptal'] = iptal;
    data['siparis_id'] = siparisId;
    data['masa_no'] = masaNo;
    if (urun != null) {
      data['urun'] = urun!.map((v) => v.toJson()).toList();
    }
    data['time'] = time;
    return data;
  }
}

class SiparisArsivSor {
  SiparisArsivSor({
    this.istekTip,
    this.status,
    this.day,
    this.dbNo,
    this.userId,
    this.siparis,
    this.musteriSiparis,
  });

  String? istekTip;
  bool? status;
  List<dynamic>? day;
  dynamic dbNo;
  int? userId;
  dynamic siparis;
  dynamic musteriSiparis;

  factory SiparisArsivSor.fromMap(Map<String, dynamic> json) => SiparisArsivSor(
        istekTip: json["istek_tip"],
        status: json["status"],
        day: json["day"],
        dbNo: json["db_no"],
        userId: json["user_id"],
        siparis: json["siparis"],
        musteriSiparis: json["musteri_siparis"],
      );

  Map<String, dynamic> toMap() => {
        "istek_tip": istekTip,
        "status": status,
        "day": day,
        "db_no": dbNo,
        "user_id": userId,
        "siparis": siparis,
        "musteri_siparis": musteriSiparis,
      };
}

class CafeSiparisArsiv {
  CafeSiparisArsiv({
    this.istekTip,
    this.status,
    this.id,
    this.day,
    this.cafeId,
    this.siparis,
    this.free,
  });
  String? istekTip;
  bool? status;
  dynamic id;
  String? day;
  int? cafeId;
  List<SiparisArsiv>? siparis;
  int? free;
  factory CafeSiparisArsiv.fromMap(Map<String, dynamic> json) =>
      CafeSiparisArsiv(
        id: json["id"],
        cafeId: json["cafe_id"],
        istekTip: json["istek_tip"],
        status: json["status"],
        day: json["day"],
        free: json["free"],
        siparis: json["siparis"],
      );

  Map<String, dynamic> toMap() => {
        "cafe_id": cafeId,
        "id": id,
        "istek_tip": istekTip,
        "status": status,
        "day": day,
        "free": free,
        "siparis": siparis,
      };
}

class MusteriArsiv {
  MusteriArsiv({
    this.istekTip,
    this.status,
    this.id,
    this.day,
    this.musteriId,
    this.siparis,
    this.free,
  });
  String? istekTip;
  bool? status;
  dynamic id;
  String? day;
  int? musteriId;
  List<SiparisArsiv>? siparis;
  int? free;
  factory MusteriArsiv.fromMap(Map<String, dynamic> json) => MusteriArsiv(
        id: json["id"],
        musteriId: json["musteri_id"],
        istekTip: json["istek_tip"],
        status: json["status"],
        day: json["day"],
        free: json["free"],
        siparis: json["siparis"],
      );

  Map<String, dynamic> toMap() => {
        "musteri_id": musteriId,
        "id": id,
        "istek_tip": istekTip,
        "status": status,
        "day": day,
        "free": free,
        "siparis": siparis,
      };
}

class SiparisArsiv {
  SiparisArsiv({
    this.id,
    this.cafeId,
    this.not,
    this.cafeNot,
    this.musteriId,
    this.hazirlayanId,
    this.garsonId,
    this.iptal,
    this.masaNo,
    this.siparis,
    this.rawTime,
  });

  dynamic id;
  int? cafeId;
  String? not;
  String? cafeNot;
  int? musteriId;
  int? hazirlayanId;
  int? garsonId;
  bool? iptal;
  String? masaNo;
  SiparisDb? siparis;
  dynamic rawTime;

  factory SiparisArsiv.fromMap(Map<String, dynamic> json) => SiparisArsiv(
        id: json["id"],
        cafeId: json["cafe_id"],
        not: json["not"],
        cafeNot: json["cafe_not"],
        musteriId: json["musteri_id"],
        hazirlayanId: json["hazirlayan_id"],
        garsonId: json["garson_id"],
        iptal: json["iptal"],
        masaNo: json["masa_no"],
        siparis: json["siparis"],
        rawTime: json["time"],
      );

  Map<String, dynamic> toMap() => {
        "cafe_id": cafeId,
        "id": id,
        "not": not,
        "cafe_not": cafeNot,
        "musteri_id": musteriId,
        "hazirlayan_id": hazirlayanId,
        "garson_id": garsonId,
        "iptal": iptal,
        "masa_no": masaNo,
        "siparis": siparis,
        "time": rawTime,
      };
}

class SiparisDb {
  SiparisDb({
    this.id,
    this.urun,
  });
  dynamic id;
  List<SiparisUrun>? urun;

  factory SiparisDb.fromMap(Map<String, dynamic> json) => SiparisDb(
        urun: json["urun"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "urun": urun,
        "id": id,
      };
}

class SiparisUrun {
  SiparisUrun({
    this.urunNo,
    this.urunId,
    this.not,
    this.tl,
    this.puan,
    this.kazanilan,
    this.icerik,
    this.name,
    this.adet,
  });

  int? urunNo;
  dynamic urunId;
  String? not;
  double? tl;
  String? name;
  double? puan;
  double? kazanilan;
  int? adet;
  List<Icerik>? icerik;

  factory SiparisUrun.fromMap(Map<String, dynamic> json) => SiparisUrun(
        urunNo: json["urun_no"],
        name: json["name"],
        urunId: json["urun_id"],
        not: json["not"],
        tl: double.parse(json["tl"].toString()),
        adet: json["adet"],
        puan: double.parse(json["puan"].toString()),
        kazanilan: double.parse(json["kazanilan"].toString()),
        icerik: json["icerik"],
      );

  Map<String, dynamic> toMap() => {
        "adet": adet,
        "urun_no": urunNo,
        "name": name,
        "urun_id": urunId,
        "not": not,
        "tl": tl,
        "puan": puan,
        "kazanilan": kazanilan,
        "icerik": icerik,
      };

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adet'] = adet;
    data['urun_no'] = urunNo;
    data['name'] = name;
    data['urun_id'] = urunId;
    data['not'] = not;
    data['tl'] = tl;
    data['puan'] = puan;
    data['kazanilan'] = kazanilan;
    data['icerik'] = icerik;

    return data;
  }
}

class Icerik {
  Icerik({
    this.id,
    this.name,
  });

  String? name;
  dynamic id;

  factory Icerik.fromMap(Map<String, dynamic> json) => Icerik(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "id": id,
      };
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;

    return data;
  }
}

class CafeAdminInfo {
  String? code;
  Tokens? tokens;
  String? istekTip;
  int? id;
  String? name;
  String? phone;
  String? pass;
  String? newPass;
  String? mail;
  int? userType;
  int? cafeId;
  bool? status;
  String? rawtime;
  String? time;

  CafeAdminInfo(
      {this.code,
      this.tokens,
      this.istekTip,
      this.id,
      this.name,
      this.phone,
      this.pass,
      this.newPass,
      this.mail,
      this.userType,
      this.cafeId,
      this.status,
      this.rawtime,
      this.time});

  CafeAdminInfo.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['token'] != null) {
      tokens = Tokens.fromJson(json['token']);
    }
    istekTip = json['istek_tip'];
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    pass = json['pass'];
    newPass = json['new_pass'];
    mail = json['mail'];
    userType = json['user_type'];
    cafeId = json['cafe_id'];
    status = json['status'];
    rawtime = json['rawtime'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (tokens != null) {
      data['tokens'] = tokens!.toJson();
    }
    data['istek_tip'] = istekTip;
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['pass'] = pass;
    data['new_pass'] = newPass;
    data['mail'] = mail;
    data['user_type'] = userType;
    data['cafe_id'] = cafeId;
    data['status'] = status;
    data['rawtime'] = rawtime;
    data['time'] = time;
    return data;
  }
}

class Tokens {
  int? id;
  int? userType;
  bool? ok;
  TokenDetails? tokenDetails;
  String? auth;
  int? istekType;

  Tokens({
    this.id,
    this.userType,
    this.ok,
    this.tokenDetails,
    this.auth,
    this.istekType,
  });

  Tokens.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    ok = json['ok'];
    tokenDetails = json['token_details'] != null
        ? TokenDetails.fromJson(json['token_details'])
        : null;
    auth = json['auth'];
    istekType = json['istek_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_type'] = userType;
    data['ok'] = ok;
    if (tokenDetails != null) {
      data['token_details'] = tokenDetails!.toJson();
    }
    data['auth'] = auth;
    data['istek_type'] = istekType;
    return data;
  }
}

class TokenDetails {
  String? accessToken;
  String? refreshToken;
  String? accessUuid;
  String? refreshUuid;
  int? atExpires;
  int? rtExpires;

  TokenDetails({
    this.accessToken,
    this.refreshToken,
    this.accessUuid,
    this.refreshUuid,
    this.atExpires,
    this.rtExpires,
  });

  TokenDetails.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    accessUuid = json['access_uuid'];
    refreshUuid = json['refresh_uuid'];
    atExpires = json['at_expires'];
    rtExpires = json['rt_expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    data['access_uuid'] = accessUuid;
    data['refresh_uuid'] = refreshUuid;
    data['at_expires'] = atExpires;
    data['rt_expires'] = rtExpires;
    return data;
  }
}

class SiparisSor {
  bool? status;
  int? userId;
  List<Siparis>? aktif;
  List<Siparis>? arsiv;

  SiparisSor({
    this.status,
    this.userId,
    this.aktif,
    this.arsiv,
  });

  SiparisSor.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userId = json['user_id'];
    if (json['aktif'] != null) {
      aktif = <Siparis>[];
      json['aktif'].forEach((v) {
        aktif!.add(Siparis.fromJson(v));
      });
    }
    if (json['arsiv'] != null) {
      aktif = <Siparis>[];
      json['arsiv'].forEach((v) {
        aktif!.add(Siparis.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_id'] = userId;
    if (aktif != null) {
      data['aktif'] = aktif!.map((v) => v.toJson()).toList();
    }
    if (arsiv != null) {
      data['arsiv'] = arsiv!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
