import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_cafe/personel/helpers/cagri.dart';
import 'package:ssshht_cafe/personel/model/masa_cagri.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/musteri_model.dart';
import '../model/personel.dart';
import 'sqldatabase.dart';

sendDataSignIn(BuildContext cnt, dynamic json, WebSocketChannel channel) {
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);

      var musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        if (musteri.sign != null) {
          if (musteri.sign!.userType != 2) {
            EasyLoading.showToast('LÜTFEN YETKİLİ SAYFASINDAN GİRİŞ YAPIN',
                duration: const Duration(seconds: 10));
            return;
          }
        }
        phoneAndPassIntert(musteri.sign!);
        tokensIntert(musteri.token!.tokenDetails!, musteri.sign!.userType!);
        Navigator.pushNamed(cnt, '/PersonelHomePage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('KULLANICI ADI VEYA ŞİFRE YANLIŞ');
      }
      channel.sink.close();
    },
  );
}

sendDataSignUp(BuildContext cnt, dynamic json, WebSocketChannel channel,
    List<String> codeandphone) {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Personel.fromMap(jsonobject);
      if (musteri.status == true) {
        phoneIntert(musteri.sign!);
        Navigator.pushNamed(cnt, '/PersonelNewPassPage',
            arguments: codeandphone);
      } else if (musteri.status == false) {
        EasyLoading.showToast('KOD HATALI');
      }
      channel.sink.close();
    },
    onDone: () => {},
  );
}

sendDataSignUpCode(BuildContext cnt, dynamic json, WebSocketChannel channel) {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Personel.fromMap(jsonobject);
      if (musteri.phone!.code == 'telefon var') {
        EasyLoading.showToast('TELEFON NUMARASI ZATEN KAYITLI');
      } else {
        if (musteri.status == true) {
          EasyLoading.showToast('KOD GÖNDERİLDİ');
          channel.sink.close();
          return;
        } else if (musteri.status == false && musteri.phone?.no == 'bekle') {
          EasyLoading.showToast('YENİDEN MESAJ GÖNDERMEK İÇİN BEKLEYİNİZ',
              duration: const Duration(seconds: 10));
          channel.sink.close();
          return;
        }

        EasyLoading.showToast('BİR HATA OLUŞTU');
        channel.sink.close();
      }
    },
    onDone: () => {},
  );
}

sendDataNewLogin(BuildContext cnt, dynamic json, WebSocketChannel channel) {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Personel.fromMap(jsonobject);
      if (musteri.token!.tokenDetails!.accessToken != null) {
        passIntert(musteri.sign!);
        tokensIntert(musteri.token!.tokenDetails!, musteri.sign!.userType!);
        Navigator.pushNamed(cnt, '/PersonelHomePage', arguments: musteri);
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU');
      }
      channel.sink.close();
    },
    onDone: () => {},
  );
}

sendDataNewPass(BuildContext cnt, dynamic json, WebSocketChannel channel,
    List<String> codeandphone) {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Personel.fromMap(jsonobject);
      if (musteri.status == true) {
        passIntert(musteri.sign!);
        Navigator.pushNamed(cnt, '/PersonelNewPassPage2',
            arguments: codeandphone);
      } else if (musteri.status == false) {
        EasyLoading.showToast('KOD HATALI');
      }
      channel.sink.close();
    },
    onDone: () => {},
  );
}

sendDataRefToken(
    BuildContext cnt, dynamic json, WebSocketChannel channel) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);
      if (musteri.status == true) {
        tokensIntert(musteri.token!.tokenDetails!, musteri.sign!.userType!);
        Navigator.pushNamed(cnt, '/PersonelHomePage', arguments: musteri);
      } else if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/WelcomePage');
      } else {
        Navigator.pushNamed(cnt, '/WelcomePage');
      }
      channel.sink.close();
    },
    onDone: () => {},
  );

  return musteri;
}

var gelen = Personel();
Future<Personel> sendDataMusteri(dynamic json, WebSocketChannel channel) async {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Personel.fromMap(jsonobject);
      gelen = musteri;
      channel.sink.close();
    },
    onDone: () => {},
  );

  return gelen;
}

sendDataNewPhone(
    BuildContext cnt, dynamic json, WebSocketChannel channel, String phone) {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Personel.fromMap(jsonobject);
      if (musteri.status == true) {
        Sign sign = Sign();
        sign.phone = phone;
        phoneIntert(sign);
        EasyLoading.showToast('NUMARAN BAŞARIYLA DEĞİŞTİ',
            duration: const Duration(seconds: 4));
        const Duration(seconds: 5);
        Navigator.pushNamed(cnt, '/PersonelHomePage');
      } else if (musteri.status == false) {
        EasyLoading.showToast('KOD HATALI');
      }
      channel.sink.close();
    },
    onError: (error) => EasyLoading.showToast('BAĞLANTI HATASI'),
    onDone: () => {},
  );
}

sendDataMasaCode(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  var toast = '';
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);
      if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/PersonelMenuPage');
      } else if (musteri.status == false) {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';
        Navigator.pushNamed(cnt, '/QrPageFail');
      } else {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';

        Navigator.pushNamed(cnt, '/QrPageFail');
      }
      if (toast != '') {
        EasyLoading.showToast(toast, duration: const Duration(seconds: 5));
      }
      channel.sink.close();
    },
    onDone: () => {},
  );

  return musteri;
}

Future<Personel> sendDataToken(dynamic json, WebSocketChannel channel) async {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Personel.fromMap(jsonobject);
      if (musteri.status == true) {
        tokensIntert(musteri.token!.tokenDetails!, musteri.sign!.userType!);
      }
      gelen = musteri;
      channel.sink.close();
    },
    onDone: () => {},
  );

  return gelen;
}

Future<MasaPersonel> sendDataMasaToken(
    dynamic json, WebSocketChannel channel) async {
  var isWaiting = true;
  MasaPersonel musteri = MasaPersonel();
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = MasaPersonel.fromJson(jsonobject);
      if (musteri.status == true) {
        isWaiting = false;
        masaTokensIntert(musteri.masaToken!.tokenDetails!);
      }
      channel.sink.close();
    },
    onDone: () => {},
  );
  for (var i = 0; i < 100; i++) {
    if (!isWaiting) {
      i = 100;
    }
    if (i != 0) {
      await Future.delayed(const Duration(seconds: 3));
    }
  }
  return musteri;
}

Future<Personel> sendDataIsToken(
    dynamic json, WebSocketChannel channel, BuildContext context) async {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Personel.fromMap(jsonobject);
      if (musteri.status == true) {
      } else {
        Navigator.pushNamed(context, '/PersonelGirisPage');
      }
      gelen = musteri;
      channel.sink.close();
    },
    onDone: () => {},
  );

  return gelen;
}

Future<void> sendDataIsMasaToken(dynamic json, WebSocketChannel channel,
    BuildContext context, Personel personel) async {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = MasaPersonel.fromJson(jsonobject);
      if (musteri.status != true) {
        loginMasaCagri(context);
      }
      channel.sink.close();
    },
    onDone: () => {},
  );
}

sendDataMenuCode(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  var toast = '';
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);
      if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/PersonelMenuPage', arguments: musteri);
      } else if (musteri.status == false) {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';
        Navigator.pushNamed(cnt, '/PersonelQrPageMenuFail');
      } else {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';

        Navigator.pushNamed(cnt, '/PersonelQrPageMenuFail');
      }
      EasyLoading.showToast(toast, duration: const Duration(seconds: 5));
      channel.sink.close();
    },
    onDone: () => {},
  );

  return musteri;
}

Future<Personel> sendDataCafe(dynamic json, WebSocketChannel channel) async {
  var gelen = Personel();
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Personel.fromMap(jsonobject);
      gelen = musteri;

      channel.sink.close();
    },
    onError: (error) => EasyLoading.showToast('BAĞLANTI HATASI'),
    onDone: () => {},
  );

  return gelen;
}

sendDataMasaCagri(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/PersonelMasaCagriPage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }
      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );

  return musteri;
}

sendDataMenu(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();

  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/PersonelMenuPage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }
      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );

  return musteri;
}

sendDataMenuRef(dynamic json, WebSocketChannel channel, BuildContext cnt,
    Personel cafe) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);
      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/PersonelMenuPage',
            (route) => route.settings.name == '/PersonelHomePage',
            arguments: cafe);
      } else if (musteri.status == false) {
        Navigator.pop(cnt);
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        Navigator.pop(cnt);
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }
      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );

  return musteri;
}

sendDataNewUrun(
    dynamic json, WebSocketChannel channel, BuildContext cnt, Personel cafe) {
  Personel musteri = Personel();

  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);
      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/PersonelMenuPage',
            (route) => route.settings.name == '/PersonelHomePage',
            arguments: cafe);
      } else if (musteri.status == false) {
        Navigator.pop(cnt);
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        Navigator.pop(cnt);
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }
      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataUrunKapat(dynamic json, WebSocketChannel channel, BuildContext cnt,
    bool status, Personel cafe) {
  Personel musteri = Personel();

  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);
      if (musteri.status == true) {
        if (status == false) {
          EasyLoading.showToast('ÜRÜN SATIŞA KAPANDI');
        } else {
          EasyLoading.showToast('ÜRÜN SATIŞA AÇILDI');
        }
        Navigator.pushNamedAndRemoveUntil(cnt, '/PersonelMenuPage',
            (route) => route.settings.name == '/PersonelHomePage',
            arguments: cafe);
      } else if (musteri.status == false) {
        Navigator.pop(cnt);
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        Navigator.pop(cnt);
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }
      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataMasa(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/PersonelMasaPage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );

  return musteri;
}

sendDataUrun(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/PersonelUrunPage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );

  return musteri;
}

sendDataRefMasa(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/PersonelMasaPage',
            (route) => route.settings.name == '/PersonelHomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );

  return musteri;
}

sendDataPersonel(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/PersonelPersonelPage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataNewPersonel(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        EasyLoading.showToast('PERSONEL EKLENDİ');
        Navigator.pushNamed(cnt, '/PersonelHomePage');
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataRefPers(
    dynamic json, WebSocketChannel channel, BuildContext cnt, int index) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);
      var gelen = [musteri, index];

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/PersonelPersonelDetayPage',
            (route) => route.settings.name == '/PersonelPersonelPage',
            arguments: gelen);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );

  return musteri;
}

sendDataHesap(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/PersonelHesapPage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataSiparis(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/PersonelSiparisPage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataSiparisRef(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/PersonelSiparisPage',
            (route) => route.settings.name == '/PersonelHomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataKasa(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamed(cnt, '/PersonelKasaPage', arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataPersonelAyar(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/PersonelAyarPage',
            (route) => route.settings.name == '/PersonelHomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataHome(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/PersonelHomePage',
            (route) => route.settings.name == '/PersonelHomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/WelcomePage',
            (route) => route.settings.name == '/WelcomePage',
            arguments: musteri);
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}

sendDataCafeAyril(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Personel musteri = Personel();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/PersonelHomePage',
            (route) => route.settings.name == '/PersonelHomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
      }

      channel.sink.close();
    },
    onError: (error) => {},
    onDone: () => {},
  );
}
