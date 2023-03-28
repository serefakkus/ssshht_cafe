import 'dart:typed_data';
import 'cafe.dart';
import 'musterimodel.dart';

class Personel {
  Personel({
    this.cafeAyar,
    this.cafeId,
    this.cafeInfo,
    this.hesap,
    this.hesapArsiv,
    this.id,
    this.info,
    this.istekTip,
    this.masa,
    this.mazleme,
    this.mediaIp,
    this.mediaResp,
    this.menu,
    this.newPhone,
    this.persayar,
    this.phone,
    this.rez,
    this.saat,
    this.sign,
    this.siparis,
    this.status,
    this.token,
    this.urun,
    this.urunTakip,
    this.yetki,
  });
  int? id;
  String? istekTip;
  bool? status;
  int? cafeId;
  List<bool>? yetki;
  Tokens? token;
  Info? info;
  Phone? phone;
  Sign? sign;
  PersonelAyar? persayar;
  CafeAyar? cafeAyar;
  Saat? saat;
  CafeInfo? cafeInfo;
  Menu? menu;
  Masa? masa;
  Rez? rez;
  UrunIstekId? urun;
  Siparis? siparis;
  UrunMalzemeId? mazleme;
  UrunTakip? urunTakip;
  HesapIstek? hesap;
  PersonelHesapArsiv? hesapArsiv;
  NewPhone? newPhone;
  List<MediaIp>? mediaIp;
  List<MediaResp>? mediaResp;

  factory Personel.fromMap(Map<String, dynamic> json) => Personel(
        id: json["id"],
        istekTip: json["istek_tip"],
        status: json["status"],
        cafeId: json["cafe_id"],
        hesap: HesapIstek.fromMap(json["hesap"]),
        hesapArsiv: PersonelHesapArsiv.fromMap(json["hesap_arsiv"]),
        masa: Masa.fromJson(json["masa"]),
        info: Info.fromMap(json["info"]),
        phone: Phone.fromMap(json["phone"]),
        sign: Sign.fromMap(json["sign"]),
        cafeInfo: CafeInfo.fromJson(json["cafe_info"]),
        cafeAyar: CafeAyar.fromMap(json["cafe_ayar"]),
        mazleme: UrunMalzemeId.fromMap(json["malzeme"]),
        persayar: PersonelAyar.fromJson(json["pers_ayar"]),
        menu: Menu.fromMap(json["menu"]),
        newPhone: NewPhone.fromMap(json["new_phone"]),
        siparis: Siparis.fromJson(json["siparis"]),
        rez: Rez.fromMap(json["rez"]),
        mediaIp: json["media_ip"],
        mediaResp: json["media_resp"],
        saat: Saat.fromMap(json["saat"]),
        token: Tokens.fromJson(json["tokens"]),
        urun: UrunIstekId.fromMap(json["urun"]),
        urunTakip: UrunTakip.fromMap(json["urun_takip"]),
        yetki: json["yetki"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "istek_tip": istekTip,
        "status": status,
        "cafe_id": cafeId,
        "hesap": hesap,
        "hesap_arsiv": hesapArsiv,
        "tokens": token?.toJson(),
        "info": info?.toMap(),
        "phone": phone?.toMap(),
        "sign": sign?.toMap(),
        "cafe_info": cafeInfo?.toJson(),
        "cafe_ayar": cafeAyar?.toMap(),
        "masa": masa?.toJson(),
        "malzeme": mazleme?.toMap(),
        "menu": menu?.toMap(),
        "new_phone": newPhone?.toMap(),
        "siparis": siparis?.toJson(),
        "pers_ayar": persayar?.toJson(),
        "media_ip": mediaIp,
        "media_resp": mediaResp,
        "rez": rez?.toMap(),
        "sig": sign?.toMap(),
        "saat": saat?.toMap(),
        "urun": urun?.toMap(),
        "urun_takip": urunTakip?.toMap(),
        "yetki": yetki,
      };
}

class Rez {
  Rez({
    this.cafeId,
    this.istekTip,
    this.mongoId,
    this.rez,
    this.status,
  });
  dynamic mongoId;
  bool? status;
  String? istekTip;
  int? cafeId;
  List<Rezler>? rez;

  factory Rez.fromMap(Map<String, dynamic> json) => Rez(
        cafeId: json["cafe_id"],
        istekTip: json["istek_tip"],
        mongoId: json["mongo_id"],
        rez: json["rez"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "cafe_id": cafeId,
        "istek_tip": istekTip,
        "mongo_id": mongoId,
        "rez": rez,
        "status": status,
      };
}

class Rezler {
  Rezler({
    this.no,
    this.userId,
  });
  String? no;
  int? userId;

  factory Rezler.fromMap(Map<String, dynamic> json) => Rezler(
        no: json["no"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toMap() => {
        "no": no,
        "user_id": userId,
      };
}

class UrunMalzemeId {
  UrunMalzemeId({
    this.cafeId,
    this.id,
    this.istekTip,
    this.malzeme,
    this.status,
  });
  String? istekTip;
  bool? status;
  dynamic id;
  int? cafeId;
  List<UrunMalzeme>? malzeme;

  factory UrunMalzemeId.fromMap(Map<String, dynamic> json) => UrunMalzemeId(
        id: json["id"],
        cafeId: json["miktar"],
        istekTip: json["miktar_type"],
        malzeme: json["name"],
        status: json["malzeme_no"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "miktar": cafeId,
        "miktar_type": istekTip,
        "name": malzeme,
        "malzeme_no": status,
      };
}

class UrunMalzeme {
  UrunMalzeme({
    this.id,
    this.miktar,
    this.miktarTip,
    this.name,
    this.no,
  });
  dynamic id;
  int? no;
  String? name;
  double? miktar;
  int? miktarTip;

  factory UrunMalzeme.fromMap(Map<String, dynamic> json) => UrunMalzeme(
        id: json["id"],
        miktar: json["miktar"],
        miktarTip: json["miktar_type"],
        name: json["name"],
        no: json["malzeme_no"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "miktar": miktar,
        "miktar_type": miktarTip,
        "name": name,
        "malzeme_no": no,
      };
}

class MediaIp {
  MediaIp({
    this.freeSize,
    this.istekId,
    this.istekTip,
    this.media,
    this.objectId,
    this.objectTip,
    this.serverId,
    this.serverIp,
    this.status,
  });
  bool? status;
  int? serverId;
  String? serverIp;
  String? objectId;
  String? objectTip;
  int? freeSize;
  int? istekId;
  String? istekTip;
  Uint8List? media;

  MediaIp.fromJson(Map<String, dynamic> json) {
    istekTip = json["istek_tip"];
    status = json["status"];
    freeSize = json["free_size"];
    istekId = json["istek_id"];
    if (json["media"] != null) {}

    objectId = json["object_id"];
    objectTip = json["object_type"];
    serverId = json["server_id"];
    serverIp = json["server_ip"];
  }

  Map<String, dynamic> toJson() => {
        "istek_tip": istekTip,
        "status": status,
        "free_size": freeSize,
        "istek_id": istekId,
        "media": media,
        "object_id": objectId,
        "object_type": objectTip,
        "server_id": serverId,
        "server_ip": serverIp,
      };
}

class MediaResp {
  MediaResp({
    this.ip,
    this.istekId,
    this.objectId,
    this.status,
  });
  bool? status;
  String? ip;
  int? istekId;
  String? objectId;

  factory MediaResp.fromMap(Map<String, dynamic> json) => MediaResp(
        ip: json["ip"],
        status: json["status"],
        istekId: json["istek_id"],
        objectId: json["object_id"],
      );

  Map<String, dynamic> toMap() => {
        "ip": ip,
        "status": status,
        "istek_id": istekId,
        "object_id": objectId,
      };
}
