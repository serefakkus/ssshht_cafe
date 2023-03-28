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

  factory CafeHesapArsiv.fromMap(Map<String, dynamic> json) => CafeHesapArsiv(
        cafeId: json["cafe_id"],
        day: json["day"],
        istekTip: json["istek_tip"],
        diger: json["diger"],
        gider: json["gider"],
        id: json["_id"],
        kazanilan: json["kazanilan"],
        kredi: json["kredi"],
        nakit: json["nakit"],
        personelId: json["personel_id"],
        puan: json["puan"],
        status: json["status"],
        personel: json["personel"],
        free: json["free"],
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
        "personel": personel,
        "free": free,
      };
}

class PersonelHesapArsiv {
  String? istekTip;
  bool? status;
  String? sId;
  String? day;
  int? cafeId;
  double? nakit;
  double? kredi;
  double? puan;
  double? kazanilan;
  GiderHesapIstek? gider;
  List<DigerHesapIstek>? diger;
  int? personelId;

  PersonelHesapArsiv(
      {this.istekTip,
      this.status,
      this.sId,
      this.day,
      this.cafeId,
      this.nakit,
      this.kredi,
      this.puan,
      this.kazanilan,
      this.gider,
      this.diger,
      this.personelId});

  PersonelHesapArsiv.fromJson(Map<String, dynamic> json) {
    istekTip = json['istek_tip'];
    status = json['status'];
    sId = json['_id'];
    day = json['day'];
    cafeId = json['cafe_id'];
    kredi = double.parse(json["kredi"].toString());
    nakit = double.parse(json["nakit"].toString());
    puan = double.parse(json["puan"].toString());
    kazanilan = double.parse(json["kazanilan"].toString());

    gider = json['gider'] != null
        ? new GiderHesapIstek.fromMap(json['gider'])
        : null;
    diger = json['diger'];
    personelId = json['personel_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['istek_tip'] = this.istekTip;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['day'] = this.day;
    data['cafe_id'] = this.cafeId;
    data['nakit'] = this.nakit;
    data['kredi'] = this.kredi;
    data['puan'] = this.puan;
    data['kazanilan'] = this.kazanilan;
    if (this.gider != null) {
      data['gider'] = this.gider!.toMap();
    }
    data['diger'] = this.diger;
    data['personel_id'] = this.personelId;
    return data;
  }
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
  Null? mekan;
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
        masa!.add(new Masalar.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mongo_id'] = this.mongoId;
    data['cafe_id'] = this.cafeId;
    data['istek_tip'] = this.istekTip;
    data['status'] = this.status;
    data['mekan'] = this.mekan;
    if (this.masa != null) {
      data['masa'] = this.masa!.map((v) => v.toJson()).toList();
    }
    return data;
  }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no'] = this.no;
    data['loc'] = this.loc;
    data['rezerv'] = this.rezerv;
    data['cap'] = this.cap;
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
  String? istekTip;
  bool? status;
  String? sId;
  String? day;
  int? cafeId;
  int? nakit;
  int? kredi;
  int? puan;
  int? kazanilan;
  GiderHesapIstek? gider;
  Null? diger;
  int? personelId;
  Null? personel;

  HesapIstek(
      {this.istekTip,
      this.status,
      this.sId,
      this.day,
      this.cafeId,
      this.nakit,
      this.kredi,
      this.puan,
      this.kazanilan,
      this.gider,
      this.diger,
      this.personelId,
      this.personel});

  HesapIstek.fromJson(Map<String, dynamic> json) {
    istekTip = json['istek_tip'];
    status = json['status'];
    sId = json['_id'];
    day = json['day'];
    cafeId = json['cafe_id'];
    nakit = json['nakit'];
    kredi = json['kredi'];
    puan = json['puan'];
    kazanilan = json['kazanilan'];
    gider = json['gider'] != null
        ? new GiderHesapIstek.fromMap(json['gider'])
        : null;
    diger = json['diger'];
    personelId = json['personel_id'];
    personel = json['personel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['istek_tip'] = this.istekTip;
    data['status'] = this.status;
    data['_id'] = this.sId;
    data['day'] = this.day;
    data['cafe_id'] = this.cafeId;
    data['nakit'] = this.nakit;
    data['kredi'] = this.kredi;
    data['puan'] = this.puan;
    data['kazanilan'] = this.kazanilan;
    if (this.gider != null) {
      data['gider'] = this.gider!.toMap();
    }
    data['diger'] = this.diger;
    data['personel_id'] = this.personelId;
    data['personel'] = this.personel;
    return data;
  }
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
        pers!.add(new Pers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mongoid'] = this.mongoid;
    data['istek_type'] = this.istekType;
    data['status'] = this.status;
    data['cafe_id'] = this.cafeId;
    if (this.pers != null) {
      data['pers'] = this.pers!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pers_id'] = this.persId;
    data['pers_auth'] = this.persAuth;
    data['name'] = this.name;
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
        kategori!.add(new KategoriCafe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mongoid'] = this.mongoid;
    data['istek_tip'] = this.istekTip;
    data['status'] = this.status;
    data['cafe_id'] = this.cafeId;
    if (this.kategori != null) {
      data['kategori'] = this.kategori!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class KategoriCafe {
  String? name;
  List<UrunCafe>? urun;

  KategoriCafe({this.name, this.urun});

  KategoriCafe.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['urun'] != null) {
      urun = <UrunCafe>[];
      json['urun'].forEach((v) {
        urun!.add(new UrunCafe.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.urun != null) {
      data['urun'] = this.urun!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['no'] = this.no;
    data['durum'] = this.durum;
    data['name'] = this.name;
    data['ucret'] = this.ucret;
    data['ucret_type'] = this.ucretType;
    data['tarif'] = this.tarif;
    data['puan'] = this.puan;
    data['indirim'] = this.indirim;
    data['resim_id'] = this.resimId;
    data['icerik'] = this.icerik;
    return data;
  }
}
