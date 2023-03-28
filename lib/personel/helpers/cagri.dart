import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_cafe/main.dart';
import 'package:ssshht_cafe/personel/helpers/sqldatabase.dart';
import 'package:ssshht_cafe/personel/model/masa_cagri.dart';
import 'package:web_socket_channel/io.dart';

import '../model/musteri_model.dart';

Future<void> loginMasaCagri(BuildContext context) async {
  var channel = IOWebSocketChannel.connect(urlPersonelCagri);
  MasaPersonel personel = MasaPersonel();
  Tokens tokens = Tokens();
  tokens.tokenDetails = await getToken(context);
  tokens.auth = tokens.tokenDetails!.accessToken;
  personel.token = tokens;

  personel.istekType = 'login';

  var json = jsonEncode(personel.toJson());

  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);

      var musteri = MasaPersonel.fromJson(jsonobject);

      if (musteri.status == true) {
        masaTokensIntert(musteri.masaToken!.tokenDetails!);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU TEKRAR DENEYİN!');
        Navigator.pop(context);
      }
    },
  );
}
