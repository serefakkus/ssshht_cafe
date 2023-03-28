import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Personel _cafe = Personel();

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;
List<bool>? _yetki;

List<String> _names = [
  'ÇAĞRI',
  'MENÜ',
  'SİPARİŞ',
  'MASA',
  'HESAP',
  'ÜRÜN',
];

class PersonelHomePage extends StatelessWidget {
  const PersonelHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Personel;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    _getYetki(context);

    if (_cafe.cafeId != null) {
      if (_cafe.cafeId! > 0) {
        return Container(
          color: Colors.blueGrey.shade700,
          child: Column(
            children: const [HomeCafeAppBar(), HomeCafeBody()],
          ),
        );
      } else {
        return const QrCode();
      }
    } else {
      return const Center(
        child: Text(
          'BİR HATA OLUŞTU LÜTFEN UYGULAMAYI\n ARKAPLANDAN KAPATIP TEKRAR AÇIN',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      );
    }
  }
}

class HomeCafeBody extends StatelessWidget {
  const HomeCafeBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (_width),
      //height: (_height / 1.2),
      child: const HomeGrid(),
    );
  }
}

class HomeGrid extends StatelessWidget {
  const HomeGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/backgroud.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: SizedBox(
        height: (_height / 1.2),
        child: GridView.builder(
            primary: false,
            itemCount: _names.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return _bodycontainers(index, context);
            }),
      ),
    );
  }
}

class HomeCafeAppBar extends StatelessWidget {
  const HomeCafeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (_height / 6),
        width: _width,
        child: SizedBox(
          height: (_height / 10),
          child: Row(
            children: const [CafeImg(), Ayar()],
          ),
          //color: Colors.yellow.shade100,
        ));
  }
}

class CafeImg extends StatelessWidget {
  const CafeImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: (_width / 3), right: (_width / 10)),
      child: SizedBox(
        height: (_height / 8),
        width: (_width / 3),
        child: CircleAvatar(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: (_width / 10),
            child: const Text(
              'QRCAFE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class Ayar extends StatelessWidget {
  const Ayar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        icon: Icon(
          Icons.settings,
          color: Colors.white,
          size: (_width / 8),
        ),
        onPressed: () {
          _sendAyar(context);
        },
      ),
    );
  }
}

_bodycontainers(int index, BuildContext cnt) {
  return GestureDetector(
    child: Container(
      margin: EdgeInsets.all(_width / 12),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.grey[600]!, offset: const Offset(-3, 3)),
        ],
        border: Border.all(color: Colors.grey, width: (_width / 100)),
        color: Colors.blueGrey.shade700,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      alignment: Alignment.center,
      child: Text(
        _names[index],
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    onTap: () {
      switch (index) {
        case 0:
          _sendCagri(cnt);
          break;

        case 1:
          //_sendmenu(cnt);
          EasyLoading.showToast('BU ÖZELLİK YAKINDA SİZLERLE');
          break;

        case 2:
          //_sendSiparis(cnt);
          EasyLoading.showToast('BU ÖZELLİK YAKINDA SİZLERLE');
          break;

        case 3:
          if (_yetki == null) {
            EasyLoading.showToast('YETKİ SORGULANIYOR BEKLEYİNİZ');
            return;
          }
          if (_yetki![1] != true) {
            EasyLoading.showToast('MASA DÜZENLEME YETKİNİZ YOK !');
            return;
          }
          _sendMasa(cnt);
          break;

        case 4:
          //_sendHesap(cnt);
          EasyLoading.showToast('BU ÖZELLİK YAKINDA SİZLERLE');
          break;

        case 5:
          // _sendUrun(_cnt);
          EasyLoading.showToast('BU ÖZELLİK YAKINDA SİZLERLE');
          break;
      }
    },
  );
}

_sendCagri(BuildContext context) async {
  Navigator.pushNamed(context, '/PersonelMasaCagriPage', arguments: _cafe);
}

_sendmenu(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.token = tok;

  _cafe.istekTip = 'menu_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataMenu(json, channel, context);
}

_sendMasa(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.token = tok;

  _cafe.istekTip = 'masa_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataMasa(json, channel, context);
}

_sendSiparis(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.token = tok;

  _cafe.istekTip = 'sip_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataSiparis(json, channel, context);
}

_sendHesap(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.token = tok;

  _cafe.istekTip = 'sip_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataHesap(json, channel, context);
}

_sendAyar(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.token = tok;

  _cafe.istekTip = 'cafe_ayar_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataPersonelAyar(json, channel, context);
}

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Center(
        child: QrImage(
          data: _codeStr(_cafe),
          version: QrVersions.auto,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          size: 300,
          padding: const EdgeInsets.all(10),
          gapless: true,
          errorStateBuilder: (context, error) => const Text("Hata"),
          errorCorrectionLevel: QrErrorCorrectLevel.L,
          constrainErrorBounds: true,
          dataModuleStyle: const QrDataModuleStyle(
            color: Colors.black,
            dataModuleShape: QrDataModuleShape.square,
          ),
          eyeStyle: const QrEyeStyle(
            color: Colors.black,
            eyeShape: QrEyeShape.square,
          ),
          embeddedImageStyle: QrEmbeddedImageStyle(
            color: Colors.blue,
            size: const Size(50, 50),
          ),
          embeddedImageEmitsError: false,
          semanticsLabel: "Qr Code",
        ),
      ),
    );
  }
}

String _codeStr(Personel cafe) {
  String code = '';
  if (cafe.sign == null) {
    return code;
  }

  if (cafe.sign!.code == null) {
    return code;
  }

  code = 'perscode-${cafe.sign!.code!}';

  return code;
}

_getYetki(BuildContext context) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);

  Personel musteri = Personel();
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  musteri.token = tok;

  musteri.istekTip = 'yetki_sor';

  var json = jsonEncode(musteri.toMap());
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Personel.fromMap(jsonobject);

      if (musteri.status == true) {
        _yetki = musteri.yetki;
      } else if (musteri.status == false) {
        EasyLoading.showToast('BİR HATA OLUŞTU\nYETKİ GETİRİLEMEDİ');
      } else {
        EasyLoading.showToast('BİR HATA OLUŞTU\nYETKİ GETİRİLEMEDİ');
      }

      channel.sink.close();
    },
    onError: (error) =>
        {EasyLoading.showToast('BİR HATA OLUŞTU\nYETKİ GETİRİLEMEDİ')},
    onDone: () => {},
  );
}
