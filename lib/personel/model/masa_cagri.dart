import 'musteri_model.dart';

class MasaPersonel {
  MasaPersonel({
    this.allMasa,
    this.bekleyenMasa,
    this.cafeId,
    this.clientId,
    this.id,
    this.istekType,
    this.masa,
    this.masaToken,
    this.message,
    this.sign,
    this.status,
    this.token,
    this.tokenId,
    this.bagliMasa,
  });

  String? istekType;
  String? tokenId;
  String? clientId;
  int? id;
  bool? status;
  int? cafeId;
  String? message;
  Sign? sign;
  Tokens? token;
  MasaTokens? masaToken;
  Masa? masa;
  List<Masa>? bekleyenMasa;
  List<Masa>? allMasa;
  List<Masa>? bagliMasa;

  MasaPersonel.fromJson(Map<String, dynamic> json) {
    istekType = json["istek_type"];
    tokenId = json["token_id"];
    clientId = json["client_id"];
    id = json["id"];
    status = json["status"];
    cafeId = json["cafe_id"];
    message = json["mssg"];

    if (json["token"] != null) {
      token = Tokens.fromJson(json["token"]);
    }

    if (json["masa_tokens"] != null) {
      masaToken = MasaTokens.fromJson(json["masa_tokens"]);
    }

    if (json["masa"] != null) {
      masa = Masa.fromMap(json["masa"]);
    }

    if (json["sign"] != null) {
      sign = Sign.fromMap(json["sign"]);
    }

    if (json["bekleyen_masa"] != null) {
      bekleyenMasa = <Masa>[];
      json['bekleyen_masa'].forEach((v) {
        bekleyenMasa!.add(Masa.fromMap(v));
      });
    }

    if (json["all_masa"] != null) {
      allMasa = <Masa>[];
      json['all_masa'].forEach((v) {
        allMasa!.add(Masa.fromMap(v));
      });
    }

    if (json["bagli_masalar"] != null) {
      bagliMasa = <Masa>[];
      json['bagli_masalar'].forEach((v) {
        bagliMasa!.add(Masa.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['istek_type'] = istekType;
    data['token_id'] = tokenId;
    data['client_id'] = clientId;
    data['id'] = id;
    data['status'] = status;
    data['cafe_id'] = cafeId;
    data['mssg'] = message;
    if (token != null) {
      data['token'] = token!.toJson();
    }

    if (masaToken != null) {
      data['masa_tokens'] = masaToken!.toJson();
    }

    if (masa != null) {
      data['masa'] = masa!.toMap();
    }

    if (sign != null) {
      data['sign'] = sign!.toMap();
    }

    if (bekleyenMasa != null) {
      data['bekleyen_masa'] = bekleyenMasa!.map((v) => v.toMap()).toList();
    }

    if (allMasa != null) {
      data['all_masa'] = allMasa!.map((v) => v.toMap()).toList();
    }

    if (bagliMasa != null) {
      data['bagli_masalar'] = allMasa!.map((v) => v.toMap()).toList();
    }

    return data;
  }
}

class Masa {
  Masa({
    this.masaName,
    this.masaNo,
  });

  String? masaNo;
  String? masaName;

  factory Masa.fromMap(Map<String, dynamic> json) => Masa(
        masaName: json["masa_name"],
        masaNo: json["masa_no"],
      );

  Map<String, dynamic> toMap() => {
        "masa_name": masaName,
        "masa_no": masaNo,
      };
}

class MasaForShort {
  MasaForShort({
    this.masaName,
    this.masaNo,
    this.sira,
  });

  String? masaNo;
  String? masaName;
  int? sira;
}

class MasaTokens {
  int? id;
  int? userType;
  bool? ok;
  TokenDetails? tokenDetails;
  String? auth;
  int? istekId;
  int? istekType;
  String? masaId;

  MasaTokens({
    this.id,
    this.userType,
    this.ok,
    this.tokenDetails,
    this.auth,
    this.istekId,
    this.istekType,
    this.masaId,
  });

  MasaTokens.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userType = json['user_type'];
    ok = json['ok'];
    tokenDetails = json['token_details'] != null
        ? TokenDetails.fromJson(json['token_details'])
        : null;
    auth = json['auth'];
    istekId = json['istek_id'];
    istekType = json['istek_type'];
    masaId = json['masa_id'];
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
    data['istek_id'] = istekId;
    data['istek_type'] = istekType;
    data['masa_id'] = masaId;
    return data;
  }
}
