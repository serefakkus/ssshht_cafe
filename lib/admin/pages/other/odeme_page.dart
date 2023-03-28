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

TextEditingController _nakit = TextEditingController();
TextEditingController _kart = TextEditingController();
TextEditingController _puan = TextEditingController();
Cafe _cafe = Cafe();
List<dynamic> _gelen = [];
Siparis _siparis = Siparis();
double _kartdouble = 0;
double _nakitdouble = 0;
double _puandouble = 0;
double _musteriPuan = 0;

class CafeOdemePage extends StatefulWidget {
  const CafeOdemePage({Key? key}) : super(key: key);

  @override
  State<CafeOdemePage> createState() => _CafeOdemePageState();
}

class _CafeOdemePageState extends State<CafeOdemePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kartdouble = 0;
    _nakitdouble = 0;
    _puandouble = 0;
    _musteriPuan = 0;
  }

  @override
  Widget build(BuildContext context) {
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _siparis = _gelen[1];

    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OdemeButon(),
        ],
      ),
      body: Column(
        children: [HesapAppBar(), Flexible(child: Tutar())],
      ),
    );
  }
}

class HesapAppBar extends StatelessWidget {
  const HesapAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (_height / 6),
        width: _width,
        child: Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: (_width / 20)),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              CafeImg()
            ],
          ),
          color: Colors.blueGrey.shade700,
        ));
  }
}

class CafeImg extends StatelessWidget {
  const CafeImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: (_width / 6), right: (_width / 20)),
      child: SizedBox(
        height: (_height / 8),
        width: (_width / 3),
        child: CircleAvatar(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: (_width / 10),
            child: Text(
              'QRCAFE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class Tutar extends StatefulWidget {
  const Tutar({Key? key}) : super(key: key);

  @override
  State<Tutar> createState() => _TutarState();
}

class _TutarState extends State<Tutar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kart.text = '0';
    _nakit.text = '0';
    _puan.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    double _hesaptoplam = 0;
    if (_siparis.urun != null) {
      for (var i = 0; i < _siparis.urun!.length; i++) {
        if (_siparis.urun![i].tl != null) {
          _hesaptoplam = _hesaptoplam + _siparis.urun![i].tl!;
        }
      }
    }
    if (_cafe.puan?.puan != null) {
      if (_cafe.puan!.puan![0].puan != null) {
        _musteriPuan = _cafe.puan!.puan![0].puan!;
      }
    }
    double _toplam =
        _gethesap(_nakit.text) + _gethesap(_kart.text) + _gethesap(_puan.text);
    return Column(
      children: [
        Flexible(
          child: Card(
            margin: EdgeInsets.only(top: (_height / 15)),
            child: ListTile(
              leading: Text('HESAP'),
              trailing: Container(
                margin: EdgeInsets.only(right: (_width / 15)),
                child: Text(
                  _hesaptoplam.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Text('NAKİT'),
            trailing: Container(
              child: SizedBox(
                  width: (_width / 5),
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    textInputAction: TextInputAction.go,
                    controller: _nakit,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.blue.shade50),
                    onChanged: (value) {
                      _kart.text = (_gethesap(_kart.text)).toString();
                      _puan.text = (_gethesap(_puan.text)).toString();
                      _nakitdouble = _gethesap(_nakit.text);
                      _kartdouble = _gethesap(_kart.text);
                      _puandouble = _gethesap(_puan.text);
                    },
                  )),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Text('KART'),
            trailing: SizedBox(
              width: (_width / 5),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                textInputAction: TextInputAction.go,
                controller: _kart,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue.shade50),
                onChanged: (value) {
                  _nakit.text = (_gethesap(_nakit.text)).toString();
                  _puan.text = (_gethesap(_puan.text)).toString();
                  _nakitdouble = _gethesap(_nakit.text);
                  _kartdouble = _gethesap(_kart.text);
                  _puandouble = _gethesap(_puan.text);
                },
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Text('PUAN'),
            trailing: SizedBox(
              width: (_width / 5),
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                textInputAction: TextInputAction.go,
                controller: _puan,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue.shade50),
                onChanged: (value) {
                  _nakit.text = (_gethesap(_nakit.text)).toString();
                  _kart.text = (_gethesap(_kart.text)).toString();
                  _nakitdouble = _gethesap(_nakit.text);
                  _kartdouble = _gethesap(_kart.text);
                  _puandouble = _gethesap(_puan.text);
                },
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Text('MÜŞTERİ PUANI'),
            trailing: Container(
              margin: EdgeInsets.only(right: (_width / 15)),
              child: Text(
                _musteriPuan.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Text('TOPLAM'),
            trailing: Container(
              margin: EdgeInsets.only(right: (_width / 15)),
              child: Text(
                _toplam.toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Card(
          child: ListTile(
            leading: Text('KALAN'),
            trailing: Container(
              margin: EdgeInsets.only(right: (_width / 15)),
              child: Text(
                (_hesaptoplam - (_kartdouble + _nakitdouble + _puandouble))
                    .toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

double _gethesap(String text) {
  for (var i = 0; i < text.length; i++) {
    if (text[i] == ',') {
      var a = text.substring(0, i);
      text = a + '.' + text.substring(i + 1, text.length);
    }
  }
  if (text != '') {
    return double.parse(text);
  }
  return 0;
}

class OdemeButon extends StatelessWidget {
  const OdemeButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: (_height / 20),
      width: (_width / 2),
      child: Container(
        margin: EdgeInsets.only(bottom: (_height / 20)),
        child: ElevatedButton(
          child: Text('ÖDEME'),
          onPressed: () {
            _sendSipariskapat(context);
          },
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.8), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
        ),
      ),
    );
  }
}

_sendSipariskapat(BuildContext context) async {
  if (_musteriPuan < _puandouble) {
    EasyLoading.showToast("MÜŞRERİ YETERLİ PUANA SAHİP DEĞİL!");
  } else {
    var _tok = Tokens();
    _tok.tokenDetails = await getToken(context);
    var _hesap = HesapIstek();
    _hesap.kredi = _kartdouble;
    _hesap.nakit = _nakitdouble;
    _hesap.puan = _puandouble;
    _cafe.hesapIstek = _hesap;
    _cafe.tokens = _tok;
    _cafe.siparis = _siparis;
    _cafe.istekTip = 'siparis_kapat';

    WebSocketChannel _channel = IOWebSocketChannel.connect(urlAdmin);
    var json = jsonEncode(_cafe.toMap());

    sendDataSiparisKapat(json, _channel, context);
  }
}
