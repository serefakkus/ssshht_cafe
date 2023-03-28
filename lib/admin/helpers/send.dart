import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_cafe/admin/helpers/sqldatabase.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../main.dart';
import '../../personel/model/personel.dart';
import '../model/cafe.dart';
import '../model/musterimodel.dart';

sendDataSignIn(BuildContext cnt, dynamic json, WebSocketChannel channel) {
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        if (musteri.sign != null) {
          if (musteri.sign!.userType != 1) {
            EasyLoading.showToast('LÜTFEN PERSONEL SAYFASINDAN GİRİŞ YAPIN',
                duration: const Duration(seconds: 10));
            return;
          }
        }
        phoneAndPassIntert(musteri.sign!);
        tokensIntert(musteri.tokens!.tokenDetails!, musteri.sign!.userType!);
        Navigator.pushNamed(cnt, '/CafeHomePage', arguments: musteri);
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
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        phoneIntert(musteri.sign!);
        Navigator.pushNamed(cnt, '/CafeNewPassPage', arguments: codeandphone);
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
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        EasyLoading.showToast('KOD GÖNDERİLDİ');
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU');
      }
      channel.sink.close();
    },
    onDone: () => {},
  );
}

sendDataNewLogin(BuildContext cnt, dynamic json, WebSocketChannel channel) {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.tokens!.tokenDetails!.accessToken != null) {
        passIntert(musteri.sign!);
        tokensIntert(musteri.tokens!.tokenDetails!, musteri.sign!.userType!);
        Navigator.pushNamed(cnt, '/CafeHomePage', arguments: musteri);
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
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        passIntert(musteri.sign!);
        Navigator.pushNamed(cnt, '/CafeNewPassPage2', arguments: codeandphone);
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
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        tokensIntert(musteri.tokens!.tokenDetails!, musteri.sign!.userType!);
        Navigator.pushNamed(cnt, '/CafeHomePage', arguments: musteri);
      } else if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/CafeGirisPage');
      } else {
        Navigator.pushNamed(cnt, '/CafeGirisPage');
      }
      channel.sink.close();
    },
    onDone: () => {},
  );

  return musteri;
}

var gelen = Cafe();
Future<Cafe> sendDataMusteri(dynamic json, WebSocketChannel channel) async {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);
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
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        Sign sign = Sign();
        sign.phone = phone;
        phoneIntert(sign);
        EasyLoading.showToast('NUMARAN BAŞARIYLA DEĞİŞTİ',
            duration: const Duration(seconds: 4));
        const Duration(seconds: 5);
        Navigator.pushNamed(cnt, '/CafeHomePage');
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
  Cafe musteri = Cafe();
  channel.sink.add(json);
  var toast = '';
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/CafeMenuPage');
      } else if (musteri.status == false) {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';
        Navigator.pushNamed(cnt, '/CafeQrPageFail');
      } else {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';

        Navigator.pushNamed(cnt, '/CafeQrPageFail');
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

Future<Cafe> sendDataToken(dynamic json, WebSocketChannel channel) async {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        tokensIntert(musteri.tokens!.tokenDetails!, musteri.sign!.userType!);
      }
      gelen = musteri;
      channel.sink.close();
    },
    onDone: () => {},
  );

  return gelen;
}

Future<Cafe> sendDataIsToken(
    dynamic json, WebSocketChannel channel, BuildContext context) async {
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
      } else {
        Navigator.pushNamed(context, '/CafeGirisPage');
      }
      gelen = musteri;
      channel.sink.close();
    },
    onDone: () => {},
  );

  return gelen;
}

sendDataMenuCode(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  var toast = '';
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/CafeMenuPage', arguments: musteri);
      } else if (musteri.status == false) {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';
        Navigator.pushNamed(cnt, '/CafeQrPageMenuFail');
      } else {
        toast = 'Tekrar Deneyin yada \n Qrkodun altindaki yaziyi girin';

        Navigator.pushNamed(cnt, '/CafeQrPageMenuFail');
      }
      EasyLoading.showToast(toast, duration: const Duration(seconds: 5));
      channel.sink.close();
    },
    onDone: () => {},
  );

  return musteri;
}

Future<Cafe> sendDataCafe(dynamic json, WebSocketChannel channel) async {
  var gelen = Cafe();
  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      var musteri = Cafe.fromMap(jsonobject);
      gelen = musteri;

      channel.sink.close();
    },
    onError: (error) => EasyLoading.showToast('BAĞLANTI HATASI'),
    onDone: () => {},
  );

  return gelen;
}

sendDataMenu(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeMenuPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataMenuRef(
    dynamic json, WebSocketChannel channel, BuildContext cnt, Cafe cafe) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeMenuPage',
            (route) => route.settings.name == '/CafeHomePage',
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
    dynamic json, WebSocketChannel channel, BuildContext cnt, Cafe cafe) {
  Cafe musteri = Cafe();

  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeMenuPage',
            (route) => route.settings.name == '/CafeHomePage',
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
    bool status, Cafe cafe) {
  Cafe musteri = Cafe();

  channel.sink.add(json);

  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);
      if (musteri.status == true) {
        if (status == false) {
          EasyLoading.showToast('ÜRÜN SATIŞA KAPANDI');
        } else {
          EasyLoading.showToast('ÜRÜN SATIŞA AÇILDI');
        }
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeMenuPage',
            (route) => route.settings.name == '/CafeHomePage',
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
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeMasaPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataUrun(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeUrunPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataRefMasa(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeMasaPage',
            (route) => route.settings.name == '/CafeHomePage',
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
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafePersonelPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataNewPersonel(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        EasyLoading.showToast('PERSONEL EKLENDİ');
        Navigator.pushNamed(cnt, '/CafeHomePage');
      } else if (musteri.sign!.pass == 'cafe_var') {
        EasyLoading.showToast('PERSONEL BAŞKA BİR CAFE\'DE KAYITLI !');
        Navigator.pushNamed(cnt, '/CafeHomePage');
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ',
            duration: const Duration(seconds: 5));
        Navigator.pop(cnt);
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
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      var gelen = [musteri, index];

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafePersonelDetayPage',
            (route) => route.settings.name == '/CafePersonelPage',
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

sendDataRefPersdel(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafePersonelPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataHesap(dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeHesapPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataSiparis(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeSiparisPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataSiparisKapat(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeHomePage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataSiparisRef(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeSiparisPage',
            (route) => route.settings.name == '/CafeHomePage',
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
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeKasaPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataCafeAyar(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeAyarPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendDataMenuAyar(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  Cafe cafe = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) async {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        if (musteri.cafeAyar!.isStaticMenu == true) {
          if (musteri.cafeAyar!.isPdf != true) {
            Navigator.pushNamedAndRemoveUntil(cnt, '/CafeStaticMenuPage',
                (route) => route.settings.name == '/CafeHomePage',
                arguments: musteri);
          } else {
            Navigator.pushNamedAndRemoveUntil(cnt, '/CafePdfMenuPage',
                (route) => route.settings.name == '/CafeHomePage',
                arguments: musteri);
          }
        } else {
          cafe.tokens = musteri.tokens;

          cafe.istekTip = 'menu_sor';

          WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
          var json = jsonEncode(cafe.toMap());

          sendDataMenu(json, channel, cnt);
        }
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

sendRefMenuAyar(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();

  channel.sink.add(json);

  channel.stream.listen(
    (data) async {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeStaticMenuPage',
            (route) => route.settings.name == '/CafeHomePage',
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

sendRefMenuAyarPdf(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();

  channel.sink.add(json);
  channel.stream.listen(
    (data) async {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeStaticMenuPage',
            (route) => route.settings.name == '/CafeHomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeStaticMenuPage',
            (route) => route.settings.name == '/CafeHomePage',
            arguments: musteri);
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeStaticMenuPage',
            (route) => route.settings.name == '/CafeHomePage',
            arguments: musteri);
      }

      channel.sink.close();
    },
    onError: (error) {},
    onDone: () => {},
  );
}

sendDataIsOkAdmin(
    dynamic json, WebSocketChannel channel, BuildContext cnt) async {
  Cafe musteri = Cafe();
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        Navigator.pushNamedAndRemoveUntil(cnt, '/CafeHomePage',
            (route) => route.settings.name == '/CafeHomePage',
            arguments: musteri);
      } else if (musteri.status == false) {
        Navigator.pushNamed(cnt, '/WelcomePage');
      } else {
        Navigator.pushNamed(cnt, '/WelcomePage');
      }

      channel.sink.close();
    },
    onError: (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    },
    onDone: () {},
  );
}

sendDataIsOkPersonel(
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
        Navigator.pushNamed(cnt, '/WelcomePage');
      } else {
        Navigator.pushNamed(cnt, '/WelcomePage');
      }

      channel.sink.close();
    },
    onError: (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    },
    onDone: () {},
  );
}
