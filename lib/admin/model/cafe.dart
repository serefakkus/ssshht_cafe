import 'package:flutter/cupertino.dart';

import 'musterimodel.dart';
import 'personel.dart';

class Cafe {
  Cafe({
    this.id,
    this.istekTip,
    this.status,
    this.tokens,
    this.sign,
    this.cafeInfo,
    this.cafeAyar,
    this.puan,
    this.menu,
    this.siparis,
    this.siparisArsiv,
    this.mediaIp,
    this.mediaResp,
    this.hesapArsiv,
    this.hesapIstek,
    this.masa,
    this.personelAyar,
    this.saat,
    this.urun,
    this.urunArsiv,
    this.urunTakip,
    this.siparisSor,
    this.masaCode,
  });

  int? id;
  String? istekTip;
  bool? status;
  Tokens? tokens;
  Sign? sign;
  CafeInfo? cafeInfo;
  CafeAyar? cafeAyar;
  Puan? puan;
  MenuCafe? menu;
  Siparis? siparis;
  SiparisArsivSor? siparisArsiv;
  List<MediaIp>? mediaIp;
  MediaResp? mediaResp;
  Saat? saat;
  PersonelAyar? personelAyar;
  HesapIstek? hesapIstek;
  SiparisSor? siparisSor;
  Masa? masa;
  UrunIstekId? urun;
  CafeUrunArsivIstek? urunArsiv;
  List<CafeHesapArsiv>? hesapArsiv;
  UrunTakip? urunTakip;
  MasaCode? masaCode;

  Cafe.fromMap(Map<String, dynamic> json) {
    id = json["id"];

    istekTip = json["istek_tip"];

    status = json["status"];

    if (json["siparis_sor"] != null) {
      siparisSor = SiparisSor.fromJson(json["siparis_sor"]);
    }

    if (json["saat"] != null) {
      saat = Saat.fromMap(json["saat"]);
    }

    if (json["pers_ayar"] != null) {
      personelAyar = PersonelAyar.fromJson(json["pers_ayar"]);
    }

    if (json["pers_ayar"] != null) {
      personelAyar = PersonelAyar.fromJson(json["pers_ayar"]);
    }

    if (json["hesap"] != null) {
      hesapIstek = HesapIstek.fromMap(json["hesap"]);
    }

    if (json["tokens"] != null) {
      tokens = Tokens.fromJson(json["tokens"]);
    }

    if (json["masa"] != null) {
      masa = Masa.fromJson(json["masa"]);
    }

    if (json["sign"] != null) {
      sign = Sign.fromMap(json["sign"]);
    }

    if (json["info"] != null) {
      cafeInfo = CafeInfo.fromJson(json["info"]);
    }

    if (json["cafe_ayar"] != null) {
      cafeAyar = CafeAyar.fromMap(json["cafe_ayar"]);
    }

    if (json["urun"] != null) {
      urun = UrunIstekId.fromMap(json["urun"]);
    }

    if (json["puan"] != null) {
      puan = Puan.fromJson(json["puan"]);
    }

    if (json["menu"] != null) {
      menu = MenuCafe.fromJson(json["menu"]);
    }

    if (json["urun_arsiv"] != null) {
      urunArsiv = CafeUrunArsivIstek.fromMap(json["urun_arsiv"]);
    }

    if (json["siparis"] != null) {
      siparis = Siparis.fromJson(json["siparis"]);
    }

    if (json["siparis_arsiv"] != null) {
      siparisArsiv = SiparisArsivSor.fromMap(json["siparis_arsiv"]);
    }

    if (json['media_ip'] != null) {
      mediaIp = <MediaIp>[];
      json['media_ip'].forEach((v) {
        mediaIp!.add(MediaIp.fromJson(v));
      });
    }

    if (json["media_resp"] != null) {
      mediaResp = MediaResp.fromMap(json["media_resp"]);
    }

    if (json["hesap_arsiv"] != null) {
      hesapArsiv = <CafeHesapArsiv>[];
      try {
        for (var element in json["hesap_arsiv"]) {
          hesapArsiv!.add(CafeHesapArsiv.fromJson(element));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    if (json["urun_takip"] != null) {
      urunTakip = UrunTakip.fromMap(json["urun_takip"]);
    }

    if (json["masa_code"] != null) {
      masaCode = MasaCode.fromJson(json["masa_code"]);
    }
  }

  Map<String, dynamic> toMap() => {
        "siparis_sor": siparisSor?.toJson(),
        "id": id,
        "istek_tip": istekTip,
        "status": status,
        "saat": saat?.toMap(),
        "pers_ayar": personelAyar?.toJson(),
        "hesap": hesapIstek?.toMap(),
        "tokens": tokens?.toJson(),
        "masa": masa?.toJson(),
        "sign": sign?.toMap(),
        "cafe_info": cafeInfo?.toJson(),
        "cafe_ayar": cafeAyar?.toMap(),
        "urun": urun?.toMap(),
        "puan": puan?.toJson(),
        "menu": menu?.toJson(),
        "urun_arsiv": urunArsiv?.toMap(),
        "siparis": siparis?.toJson(),
        "siparis_arsiv": siparisArsiv?.toMap(),
        "media_ip": mediaIp,
        "media_resp": mediaResp?.toMap(),
        "hesap_arsiv": hesapArsiv,
        "urun_takip": urunTakip?.toMap(),
        "masa_code": masaCode?.toJson(),
      };
}

class UrunTakip {
  UrunTakip({
    this.cafeId,
    this.gelenUrun,
    this.time,
    this.id,
    this.istekTip,
    this.status,
  });
  String? istekTip;
  dynamic time;
  bool? status;
  dynamic id;
  int? cafeId;
  List<GelenIstek>? gelenUrun;

  factory UrunTakip.fromMap(Map<String, dynamic> json) => UrunTakip(
        cafeId: json["cafe_id"],
        gelenUrun: json["gelen_utun"],
        istekTip: json["istek_tip"],
        time: json["time"],
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "cafe_id": cafeId,
        "gelen_urun": gelenUrun,
        "istek_tip": istekTip,
        "time": time,
        "status": status,
        "id": id,
      };
}

class CafeHesapArsiv {
  CafeHesapArsiv({
    this.cafeId,
    this.day,
    this.diger,
    this.free,
    this.gider,
    this.id,
    this.istekTip,
    this.kazanilan,
    this.kredi,
    this.nakit,
    this.personel,
    this.personelId,
    this.puan,
    this.status,
  });
  String? istekTip;
  bool? status;
  int? free;
  dynamic id;
  String? day;
  int? cafeId;
  int? personelId;
  double? nakit;
  double? kredi;
  double? puan;
  double? kazanilan;
  GiderHesapIstek? gider;
  List<DigerHesapIstek>? diger;
  List<PersonelHesapArsiv>? personel;

  CafeHesapArsiv.fromJson(Map<String, dynamic> json) {
    istekTip = json['istek_tip'];
    status = json['status'];
    id = json['_id'];
    day = json['day'];
    cafeId = json['cafe_id'];
    kredi = double.parse(json["kredi"].toString());
    nakit = double.parse(json["nakit"].toString());
    puan = double.parse(json["puan"].toString());
    kazanilan = double.parse(json["kazanilan"].toString());

    gider =
        json['gider'] != null ? GiderHesapIstek.fromMap(json['gider']) : null;
    diger = json['diger'];
    personelId = json['personel_id'];
    personel = json["personel"];
    free = json["free"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['istek_tip'] = istekTip;
    data['status'] = status;
    data['_id'] = id;
    data['day'] = day;
    data['cafe_id'] = cafeId;
    data['nakit'] = nakit;
    data['kredi'] = kredi;
    data['puan'] = puan;
    data['kazanilan'] = kazanilan;
    if (gider != null) {
      data['gider'] = gider!.toMap();
    }
    data['diger'] = diger;
    data['personel_id'] = personelId;
    data['personel'] = personel;
    data['free'] = free;
    return data;
  }
}

class PersonelHesapArsiv {
  PersonelHesapArsiv({
    this.cafeId,
    this.day,
    this.istekTip,
    this.diger,
    this.gider,
    this.id,
    this.kazanilan,
    this.kredi,
    this.nakit,
    this.personelId,
    this.puan,
    this.status,
  });
  String? istekTip;
  bool? status;
  dynamic id;
  String? day;
  int? cafeId;
  double? nakit;
  double? kredi;
  double? puan;
  double? kazanilan;
  List<DigerHesapIstek>? diger;
  GiderHesapIstek? gider;
  int? personelId;

  factory PersonelHesapArsiv.fromMap(Map<String, dynamic> json) =>
      PersonelHesapArsiv(
        cafeId: json["cafe_id"],
        day: json["day"],
        istekTip: json["istek_tip"],
        diger: json["diger"],
        gider: GiderHesapIstek.fromMap(json["gider"]),
        id: json["_id"],
        kazanilan: double.parse(json["kazanilan"].toString()),
        kredi: double.parse(json["kredi"].toString()),
        nakit: double.parse(json["nakit"].toString()),
        personelId: json["personel_id"],
        puan: double.parse(json["puan"].toString()),
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "cafe_id": cafeId,
        "day": day,
        "istek_tip": istekTip,
        "diger": diger,
        "gider": gider?.toMap(),
        "_id": id,
        "kazanilan": kazanilan,
        "kredi": kredi,
        "nakit": nakit,
        "personel_id": personelId,
        "puan": puan,
        "status": status,
      };
}

class CafeUrunArsivIstek {
  CafeUrunArsivIstek({
    this.arsiv,
    this.cafeId,
    this.id,
    this.status,
    this.urun,
  });
  dynamic id;
  bool? status;
  int? cafeId;
  List<ArsivUrunIstek>? arsiv;
  List<GelenUrunlerIstek>? urun;
  factory CafeUrunArsivIstek.fromMap(Map<String, dynamic> json) =>
      CafeUrunArsivIstek(
        arsiv: json["arsiv"],
        cafeId: json["cafe_id"],
        id: json["_id"],
        status: json["status"],
        urun: json["urun"],
      );

  Map<String, dynamic> toMap() => {
        "arsiv": arsiv,
        "cafe_id": cafeId,
        "_id": id,
        "status": status,
        "urun": urun,
      };
}

class ArsivUrunIstek {
  ArsivUrunIstek({
    this.day,
    this.mongoDbNo,
    this.mongoId,
  });
  String? day;
  dynamic mongoId;
  int? mongoDbNo;

  factory ArsivUrunIstek.fromMap(Map<String, dynamic> json) => ArsivUrunIstek(
        mongoDbNo: json["mongo_db_no"],
        day: json["day"],
        mongoId: json["mongo_id"],
      );

  Map<String, dynamic> toMap() => {
        "mongo_db_no": mongoDbNo,
        "day": day,
        "mongo_id": mongoId,
      };
}

class GelenUrunlerIstek {
  GelenUrunlerIstek({
    this.cafeId,
    this.day,
    this.id,
    this.time,
    this.urun,
  });
  dynamic id;
  int? cafeId;
  String? day;
  dynamic time;
  List<GelenIstek>? urun;

  factory GelenUrunlerIstek.fromMap(Map<String, dynamic> json) =>
      GelenUrunlerIstek(
        cafeId: json["cafe_id"],
        day: json["day"],
        id: json["_id"],
        time: json["time"],
        urun: json["gelen_urun"],
      );

  Map<String, dynamic> toMap() => {
        "cafe_id": cafeId,
        "day": day,
        "_id": id,
        "time": time,
        "gelen_urun": urun,
      };
}

class GelenIstek {
  GelenIstek({
    this.faturaNo,
    this.miktar,
    this.odeme,
    this.odemetype,
    this.personelId,
    this.time,
    this.urunNo,
  });
  int? urunNo;
  double? miktar;
  double? odeme;
  int? odemetype;
  String? faturaNo;
  int? personelId;
  dynamic time;

  factory GelenIstek.fromMap(Map<String, dynamic> json) => GelenIstek(
        urunNo: json["id"],
        miktar: json["istek_tip"],
        odeme: json["status"],
        odemetype: json["cafe_id"],
        personelId: json["urun"],
        time: json["cafe_id"],
        faturaNo: json["urun"],
      );

  Map<String, dynamic> toMap() => {
        "id": faturaNo,
        "istek_tip": miktar,
        "status": odeme,
        "cafe_id": odemetype,
        "urun": personelId,
        "cafe_id": time,
        "urun": urunNo,
      };
}

class UrunIstekId {
  UrunIstekId({
    this.cafeId,
    this.id,
    this.istekTip,
    this.status,
    this.urun,
  });

  String? istekTip;
  bool? status;
  dynamic id;
  int? cafeId;
  List<Urun>? urun;

  factory UrunIstekId.fromMap(Map<String, dynamic> json) => UrunIstekId(
        id: json["id"],
        istekTip: json["istek_tip"],
        status: json["status"],
        cafeId: json["cafe_id"],
        urun: json["urun"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "istek_tip": istekTip,
        "status": status,
        "cafe_id": cafeId,
        "urun": urun,
      };
}

class Urun {
  Urun({
    this.id,
    this.malzeme,
    this.name,
    this.no,
  });
  dynamic id;
  int? no;
  String? name;
  List<UrunMalzemeIstek>? malzeme;

  factory Urun.fromMap(Map<String, dynamic> json) => Urun(
        id: json["id"],
        name: json["name"],
        no: json["urun_no"],
        malzeme: json["malzeme"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "urun_no": no,
        "malzeme": malzeme,
      };
}

class UrunMalzemeIstek {
  UrunMalzemeIstek({
    this.malzemeId,
    this.miktar,
  });
  dynamic malzemeId;
  double? miktar;

  factory UrunMalzemeIstek.fromMap(Map<String, dynamic> json) =>
      UrunMalzemeIstek(
        malzemeId: json["malzeme_id"],
        miktar: json["miktar"],
      );

  Map<String, dynamic> toMap() => {
        "malzeme_id": malzemeId,
        "miktar": miktar,
      };
}

class Masa {
  String? mongoId;
  int? cafeId;
  String? istekTip;
  bool? status;
  dynamic mekan;
  List<Masalar>? masa;

  Masa(
      {this.mongoId,
      this.cafeId,
      this.istekTip,
      this.status,
      this.mekan,
      this.masa});

  Masa.fromJson(Map<String, dynamic> json) {
    mongoId = json['mongo_id'];
    cafeId = json['cafe_id'];
    istekTip = json['istek_tip'];
    status = json['status'];
    mekan = json['mekan'];
    if (json['masa'] != null) {
      masa = <Masalar>[];
      json['masa'].forEach((v) {
        masa!.add(Masalar.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mongo_id'] = mongoId;
    data['cafe_id'] = cafeId;
    data['istek_tip'] = istekTip;
    data['status'] = status;
    data['mekan'] = mekan;
    if (masa != null) {
      data['masa'] = masa!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MasalarWithName {
  Masalar? masalar;
  String? name;

  MasalarWithName({
    this.masalar,
    this.name,
  });
}

class Masalar {
  String? no;
  List<int>? loc;
  bool? rezerv;
  int? cap;

  Masalar({this.no, this.loc, this.rezerv, this.cap});

  Masalar.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    loc = json['loc'].cast<int>();
    rezerv = json['rezerv'];
    cap = json['cap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['loc'] = loc;
    data['rezerv'] = rezerv;
    data['cap'] = cap;
    return data;
  }
}

class MekanPoligon {
  MekanPoligon({
    this.point,
  });
  List<int>? point;

  factory MekanPoligon.fromMap(Map<String, dynamic> json) => MekanPoligon(
        point: json["point"],
      );

  Map<String, dynamic> toMap() => {
        "point": point,
      };
}

class HesapIstek {
  HesapIstek({
    this.cafeId,
    this.day,
    this.diger,
    this.gider,
    this.id,
    this.istekTip,
    this.kazanilan,
    this.kredi,
    this.nakit,
    this.personel,
    this.personelId,
    this.puan,
    this.status,
  });
  String? istekTip;
  bool? status;
  dynamic id;
  String? day;
  int? cafeId;
  double? nakit;
  double? kredi;
  double? puan;
  double? kazanilan;
  GiderHesapIstek? gider;
  List<DigerHesapIstek>? diger;
  int? personelId;
  List<PersonelIstek>? personel;

  factory HesapIstek.fromMap(Map<String, dynamic> json) => HesapIstek(
        cafeId: json["cafe_id"],
        day: json["day"],
        diger: json["diger"],
        gider: GiderHesapIstek.fromMap(json["gider"]),
        id: json["_id"],
        istekTip: json["istek_tip"],
        kazanilan: double.parse(json["kazanilan"].toString()),
        kredi: double.parse(json["kredi"].toString()),
        nakit: double.parse(json["nakit"].toString()),
        personel: json["personel"],
        personelId: json["personel_id"],
        status: json["status"],
        puan: double.parse(json["puan"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "cafe_id": cafeId,
        "istek_tip": istekTip,
        "status": status,
        "day": day,
        "gider": gider?.toMap(),
        "diger": diger,
        "_id": id,
        "kazanilan": kazanilan,
        "kredi": kredi,
        "nakit": nakit,
        "personel": personel,
        "personel_id": personelId,
        "puan": puan,
      };
}

class PersonelIstek {
  PersonelIstek({
    this.diger,
    this.gider,
    this.kazanilan,
    this.kredi,
    this.nakit,
    this.puan,
  });
  double? nakit;
  double? kredi;
  double? puan;
  double? kazanilan;
  GiderHesapIstek? gider;
  List<DigerHesapIstek>? diger;

  factory PersonelIstek.fromMap(Map<String, dynamic> json) => PersonelIstek(
        nakit: json["nakit"],
        kredi: json["kredi"],
        diger: json["diger"],
        gider: json["gider"],
        kazanilan: json["kazanilan"],
        puan: json["puan"],
      );

  Map<String, dynamic> toMap() => {
        "nakit": nakit,
        "kredi": kredi,
        "diger": diger,
        "gider": gider?.toMap(),
        "kazanilan": kazanilan,
        "puan": puan,
      };
}

class GiderHesapIstek {
  GiderHesapIstek({
    this.kredi,
    this.nakit,
    this.diger,
  });
  double? nakit;
  double? kredi;
  List<DigerHesapIstek>? diger;

  factory GiderHesapIstek.fromMap(Map<String, dynamic> json) => GiderHesapIstek(
        nakit: double.parse(json["nakit"].toString()),
        kredi: double.parse(json["kredi"].toString()),
        diger: json["diger"],
      );

  Map<String, dynamic> toMap() => {
        "nakit": nakit,
        "kredi": kredi,
        "diger": diger,
      };
}

class DigerHesapIstek {
  DigerHesapIstek({
    this.name,
    this.tutar,
  });
  String? name;
  double? tutar;
  factory DigerHesapIstek.fromMap(Map<String, dynamic> json) => DigerHesapIstek(
        name: json["name"],
        tutar: double.parse(json["tutar"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "tutar": tutar,
      };
}

class PersonelAyar {
  String? mongoid;
  String? istekType;
  bool? status;
  int? cafeId;
  List<Pers>? pers;

  PersonelAyar(
      {this.mongoid, this.istekType, this.status, this.cafeId, this.pers});

  PersonelAyar.fromJson(Map<String, dynamic> json) {
    mongoid = json['mongoid'];
    istekType = json['istek_type'];
    status = json['status'];
    cafeId = json['cafe_id'];
    if (json['pers'] != null) {
      pers = <Pers>[];
      json['pers'].forEach((v) {
        pers!.add(Pers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mongoid'] = mongoid;
    data['istek_type'] = istekType;
    data['status'] = status;
    data['cafe_id'] = cafeId;
    if (pers != null) {
      data['pers'] = pers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pers {
  int? persId;
  List<dynamic>? persAuth;
  String? name;

  Pers({this.persId, this.persAuth, this.name});

  Pers.fromJson(Map<String, dynamic> json) {
    persId = json['pers_id'];
    var foo = json['pers_auth'];
    if (foo == null) {
      persAuth = json['pers_auth'];
    } else {
      persAuth = json['pers_auth'].cast<bool>();
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pers_id'] = persId;
    data['pers_auth'] = persAuth;
    data['name'] = name;
    return data;
  }
}

class Saat {
  Saat({
    this.cafeId,
    this.durum,
    this.istekType,
    this.mongoid,
    this.status,
    this.zaman,
  });
  dynamic mongoid;
  String? istekType;
  bool? status;
  int? cafeId;
  bool? durum;
  List<dynamic>? zaman;

  factory Saat.fromMap(Map<String, dynamic> json) => Saat(
        mongoid: json["mongoid"],
        istekType: json["istek_type"],
        status: json["status"],
        cafeId: json["cafe_id"],
        durum: json["durum"],
        zaman: json['zaman'],
      );

  Map<String, dynamic> toMap() => {
        "mongoid": mongoid,
        "istek_tip": istekType,
        "status": status,
        "cafe_id": cafeId,
        "durum": durum,
        "zaman": zaman,
      };
}

class Zaman {
  Zaman({
    this.open,
    this.close,
  });

  List<dynamic>? open;
  List<dynamic>? close;

  factory Zaman.fromMap(Map<String, dynamic> json) => Zaman(
        open: json["open"],
        close: json["close"],
      );

  Map<String, dynamic> toMap() => {
        "open": open,
        "close": close,
      };
}

class MenuCafe {
  String? mongoid;
  String? istekTip;
  bool? status;
  int? cafeId;
  List<KategoriCafe>? kategori;

  MenuCafe(
      {this.mongoid, this.istekTip, this.status, this.cafeId, this.kategori});

  MenuCafe.fromJson(Map<String, dynamic> json) {
    mongoid = json['mongoid'];
    istekTip = json['istek_tip'];
    status = json['status'];
    cafeId = json['cafe_id'];
    if (json['kategori'] != null) {
      kategori = <KategoriCafe>[];
      json['kategori'].forEach((v) {
        kategori!.add(KategoriCafe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mongoid'] = mongoid;
    data['istek_tip'] = istekTip;
    data['status'] = status;
    data['cafe_id'] = cafeId;
    if (kategori != null) {
      data['kategori'] = kategori!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KategoriCafe {
  String? name;
  String? resimid;
  List<UrunCafe>? urun;

  KategoriCafe({this.name, this.urun, this.resimid});

  KategoriCafe.fromJson(Map<String, dynamic> json) {
    resimid = json['resim_id'];
    name = json['name'];
    if (json['urun'] != null) {
      urun = <UrunCafe>[];
      json['urun'].forEach((v) {
        urun!.add(UrunCafe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['resim_id'] = resimid;
    if (urun != null) {
      data['urun'] = urun!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UrunCafe {
  int? no;
  bool? durum;
  String? name;
  double? ucret;
  int? ucretType;
  String? tarif;
  double? puan;
  double? indirim;
  String? resimId;
  List<String>? icerik;

  UrunCafe(
      {this.no,
      this.durum,
      this.name,
      this.ucret,
      this.ucretType,
      this.tarif,
      this.puan,
      this.indirim,
      this.resimId,
      this.icerik});

  UrunCafe.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    durum = json['durum'];
    name = json['name'];
    ucret = double.parse(json['ucret'].toString());
    ucretType = json['ucret_type'];
    tarif = json['tarif'];
    puan = double.parse(json['puan'].toString());
    indirim = double.parse(json['indirim'].toString());
    resimId = json['resim_id'];
    icerik = json['icerik'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['durum'] = durum;
    data['name'] = name;
    data['ucret'] = ucret;
    data['ucret_type'] = ucretType;
    data['tarif'] = tarif;
    data['puan'] = puan;
    data['indirim'] = indirim;
    data['resim_id'] = resimId;
    data['icerik'] = icerik;
    return data;
  }
}

class MasaCode {
  bool? status;
  String? istekTip;
  String? id;
  int? cafeId;
  String? masaNo;
  String? code;
  String? name;
  List<MasaName>? masaNameS;

  MasaCode({
    this.status,
    this.istekTip,
    this.id,
    this.cafeId,
    this.masaNo,
    this.code,
    this.name,
    this.masaNameS,
  });

  MasaCode.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    istekTip = json['istek_tip'];
    id = json['id'];
    cafeId = json['cafe_id'];
    masaNo = json['masa_no'];
    code = json['code'];
    name = json['masa_name'];
    if (json['masalar'] != null) {
      masaNameS = <MasaName>[];
      json['masalar'].forEach((v) {
        masaNameS!.add(MasaName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['istek_tip'] = istekTip;
    data['id'] = id;
    data['cafe_id'] = cafeId;
    data['masa_no'] = masaNo;
    data['code'] = code;
    data['masa_name'] = name;
    if (masaNameS != null) {
      data['masalar'] = masaNameS!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MasaName {
  String? masaNo;
  String? masaName;

  MasaName({
    this.masaName,
    this.masaNo,
  });

  MasaName.fromJson(Map<String, dynamic> json) {
    masaName = json['masa_name'];
    masaNo = json['masa_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['masa_name'] = masaName;
    data['masa_no'] = masaNo;
    return data;
  }
}
