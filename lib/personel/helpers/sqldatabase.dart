import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssshht_cafe/personel/helpers/cagri.dart';
import 'package:ssshht_cafe/personel/model/masa_cagri.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../main.dart';
import '../model/musteri_model.dart';
import '../model/personel.dart';
import 'send.dart';

//----------------------------masa cagri token------------------------------
void masaTokensIntert(TokenDetails tokenDetails) async {
  if (tokenDetails.accessToken != null && tokenDetails.refreshToken != null) {
    final preferences = await SharedPreferences.getInstance();

    preferences.setString('masaaccesstoken', tokenDetails.accessToken!);
    preferences.setString('masarefreshtoken', tokenDetails.refreshToken!);
    preferences.setInt('masaatexp', tokenDetails.atExpires!);
    preferences.setInt('masartexp', tokenDetails.rtExpires!);
  }
}

void masaTokensDel() async {
  final preferences = await SharedPreferences.getInstance();

  preferences.remove('masaaccesstoken');
  preferences.remove('masarefreshtoken');
  preferences.remove('masaatexp');
  preferences.remove('masartexp');
}

Future<TokenDetails> masaTokenGet() async {
  final preferences = await SharedPreferences.getInstance();
  TokenDetails token = TokenDetails();
  token.accessToken = preferences.getString('masaaccesstoken');
  token.refreshToken = preferences.getString('masarefreshtoken');
  token.atExpires = preferences.getInt('masaatexp');
  token.rtExpires = preferences.getInt('masartexp');
  return token;
}

Future<TokenDetails> getMasaToken(
    BuildContext context, Personel personel) async {
  TokenDetails token = await masaTokenGet();

  WebSocketChannel chnnl = IOWebSocketChannel.connect(urlPersonelCagri);
  WebSocketChannel chnnl2 = IOWebSocketChannel.connect(urlPersonelCagri);

  if (token.rtExpires == null) {
    // ignore: use_build_context_synchronously
    await loginMasaCagri(context);
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/PersonelHomePage', arguments: personel);
    return token;
  }

  var date = DateTime.fromMillisecondsSinceEpoch(token.rtExpires! * 1000);

  if (date.isBefore(DateTime.now())) {
    MasaPersonel mus = MasaPersonel();
    Tokens tok = Tokens();
    tok.tokenDetails = token;
    mus.token = tok;
    mus.istekType = 'ref_tok';
    var json = jsonEncode(mus.toJson());

    var m = await sendDataMasaToken(json, chnnl);
    mus.istekType = '';
    mus.masaToken = m.masaToken;
    var json2 = jsonEncode(mus.toJson());

    // ignore: use_build_context_synchronously
    sendDataIsMasaToken(json2, chnnl2, context, personel);

    if (m.status == true) {
      token = m.token!.tokenDetails!;
    } else {
      token.accessToken = '';
    }
  }

  return token;
}

//---------------------------------token------------------------------

void tokensIntert(TokenDetails tokenDetails, int type) async {
  if (tokenDetails.accessToken != null && tokenDetails.refreshToken != null) {
    final preferences = await SharedPreferences.getInstance();

    preferences.setString('accesstoken', tokenDetails.accessToken!);
    preferences.setString('refreshtoken', tokenDetails.refreshToken!);
    preferences.setInt('atexp', tokenDetails.atExpires!);
    preferences.setInt('rtexp', tokenDetails.rtExpires!);
    type = 2;
    preferences.setInt('type', type);
  }
}

void tokensDel() async {
  final preferences = await SharedPreferences.getInstance();

  preferences.remove('accesstoken');
  preferences.remove('refreshtoken');
  preferences.remove('atexp');
  preferences.remove('rtexp');
  preferences.remove('type');
}

typeGet() async {
  final preferences = await SharedPreferences.getInstance();
  var type = preferences.getInt('type');
  return type;
}

Future<TokenDetails> tokenGet() async {
  final preferences = await SharedPreferences.getInstance();
  TokenDetails token = TokenDetails();
  token.accessToken = preferences.getString('accesstoken');
  token.refreshToken = preferences.getString('refreshtoken');
  token.atExpires = preferences.getInt('atexp');
  token.rtExpires = preferences.getInt('rtexp');
  return token;
}

void phoneAndPassIntert(Sign sign) async {
  final preferences = await SharedPreferences.getInstance();

  preferences.setString('phone', sign.phone!);
  preferences.setString('pass', sign.pass!);
}

void passIntert(Sign sign) async {
  final preferences = await SharedPreferences.getInstance();

  preferences.setString('pass', sign.pass!);
}

void phoneIntert(Sign sign) async {
  final preferences = await SharedPreferences.getInstance();

  preferences.setString('phone', sign.phone!);
}

Future<Sign> passGet() async {
  final preferences = await SharedPreferences.getInstance();
  Sign sign = Sign();
  sign.phone = preferences.getString('phone');
  sign.pass = preferences.getString('pass');
  return sign;
}

Future<TokenDetails> getToken(BuildContext context) async {
  TokenDetails token = await tokenGet();

  WebSocketChannel chnnl = IOWebSocketChannel.connect(urlPeronel);
  WebSocketChannel chnnl2 = IOWebSocketChannel.connect(urlPeronel);
  var date = DateTime.fromMillisecondsSinceEpoch(token.rtExpires! * 1000);
  if (date.isBefore(DateTime.now())) {
    Personel mus = Personel();
    Tokens tok = Tokens();
    tok.tokenDetails = token;
    mus.token = tok;
    mus.istekTip = 'ref_token';
    var json = jsonEncode(mus.toMap());
    var m = await sendDataToken(json, chnnl);
    mus.istekTip = 'menu_sor';
    var json2 = jsonEncode(mus.toMap());
    // ignore: use_build_context_synchronously
    sendDataIsToken(json2, chnnl2, context);
    if (m.status == true) {
      token = m.token!.tokenDetails!;
    }
  }

  return token;
}

_istokenok(TokenDetails token) async {
  WebSocketChannel chnnl = IOWebSocketChannel.connect(urlPeronel);
  Personel mus = Personel();
  Tokens tok = Tokens();
  tok.tokenDetails = token;
  mus.token = tok;
  mus.istekTip = 'menu_sor';
  var json = jsonEncode(mus.toMap());
  var m = await sendDataToken(json, chnnl);
  return m.status;
}

Future<Sign> phoneGet() async {
  final preferences = await SharedPreferences.getInstance();
  Sign sign = Sign();
  sign.phone = preferences.getString('phone');
  return sign;
}

sepetInsert(Menu menu) async {
  menu.cafeId = 1;

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MenuAdapter());
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(MenuUrunAdapter());
  }

  //await Hive.openBox<Menu>('menu');
  var box = Hive.box<Menu>('menu');
  box.put(menu.cafeId, menu);
}

sepetDelete(Menu menu) async {
  menu.cafeId = 1; //==========================================

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MenuAdapter());
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(MenuUrunAdapter());
  }

  await Hive.openBox<Menu>('menu');
  var box = Hive.box<Menu>('menu');
  await box.clear();
}

Future<Menu> sepetGet(Menu menu) async {
  menu.cafeId = 1;

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MenuAdapter());
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(MenuUrunAdapter());
  }

  await Hive.openBox<Menu>('menu');
  var box = Hive.box<Menu>('menu');
  if (box.containsKey(menu.cafeId)) {
    menu = box.get(menu.cafeId)!;
  }

  return menu;
}
