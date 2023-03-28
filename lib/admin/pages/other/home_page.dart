import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musterimodel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Cafe _cafe = Cafe();

List<String> _names = [
  'MENÜ',
  'SİPARİŞ',
  'MASA',
  'HESAP',
  'KASA',
  'ÜRÜN',
  'PERSONEL',
];

class CafeHomePage extends StatelessWidget {
  const CafeHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Container(
      color: Colors.blueGrey.shade700,
      child: Column(
        children: const [HomeCafeAppBar(), HomeCafeBody()],
      ),
    );
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
            itemCount: 7,
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

MaterialColor _color(bool ok) {
  if (ok == true) {
    return Colors.green;
  } else {
    return Colors.red;
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
          _sendMenuAyar(cnt);
          break;
        case 1:
          _sendSiparis(cnt);

          break;
        case 2:
          _sendMasa(cnt);

          break;
        case 3:
          _sendHesap(cnt);

          break;
        case 4:
          _sendKasa(cnt);

          break;
        case 5:
          // _sendUrun(_cnt);
          EasyLoading.showToast('BU ÖZELLİK YAKINDA SİZLERLE');
          break;
        case 6:
          _sendPersonel(cnt);
      }
    },
  );
}

_sendMasa(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'masa_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataMasa(json, channel, context);
}

_sendUrun(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'urun_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataUrun(json, channel, context);
}

_sendPersonel(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'pers_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataPersonel(json, channel, context);
}

_sendSiparis(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'sip_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataSiparis(json, channel, context);
}

_sendHesap(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'sip_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataHesap(json, channel, context);
}

_sendKasa(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'ciro_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataKasa(json, channel, context);
}

_sendAyar(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'ayar_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataCafeAyar(json, channel, context);
}

_sendMenuAyar(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'ayar_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataMenuAyar(json, channel, context);
}
