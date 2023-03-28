import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musterimodel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Cafe _cafe = Cafe();
Masalar _masa = Masalar();
int _ind = -1;

bool _isCapChange = false;
bool _isNameChange = false;

bool _isCapOK = false;
bool _isNameOk = false;

bool _isFirst = true;

TextEditingController _masaCap = TextEditingController();
TextEditingController _masaName = TextEditingController();

class CafeMasaDetayPage extends StatefulWidget {
  const CafeMasaDetayPage({Key? key}) : super(key: key);

  @override
  State<CafeMasaDetayPage> createState() => _CafeMasaDetayPageState();
}

class _CafeMasaDetayPageState extends State<CafeMasaDetayPage> {
  @override
  void initState() {
    _isCapChange = false;
    _isNameChange = false;
    _isFirst = true;
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = gelen[0];
    _ind = gelen[1];
    _masa = _cafe.masa!.masa![_ind];
    if (_isFirst) {
      _isFirst = false;
      _masaName.text = _masaNameGet(_masa.no.toString());
    }

    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Column(
      children: const [MasaNo(), MasaKap(), MasaName(), OnayButon()],
    );
  }
}

class MasaNo extends StatefulWidget {
  const MasaNo({Key? key}) : super(key: key);

  @override
  State<MasaNo> createState() => _MasaNoState();
}

class _MasaNoState extends State<MasaNo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 80)),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: (_width / 20), top: (_height / 20)),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 45,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: (_height / 20)),
            child: const Text('MASA NO', style: TextStyle(fontSize: 20)),
          ),
          Container(
              margin: EdgeInsets.only(
                  top: (_height / 90),
                  left: (_width / 10),
                  right: (_width / 10)),
              child: Text(
                _masa.no.toString(),
                style: const TextStyle(fontSize: 20, color: Colors.black),
              )),
        ],
      ),
    );
  }
}

class MasaKap extends StatefulWidget {
  const MasaKap({Key? key}) : super(key: key);

  @override
  State<MasaKap> createState() => _MasaKapState();
}

class _MasaKapState extends State<MasaKap> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    if (_masa.cap != null) {
      _masaCap.text = _masa.cap.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 10)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: (_height / 20)),
            child: const Text('KAPASİTE', style: TextStyle(fontSize: 20)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: (_height / 90), left: (_width / 10), right: (_width / 10)),
            child: TextField(
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.blue.shade50),
              controller: _masaCap,
              textAlign: TextAlign.center,
              cursorColor: Colors.blue,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: true),
              textInputAction: TextInputAction.go,
              onChanged: (value) {
                _isCapChange = true;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MasaName extends StatefulWidget {
  const MasaName({Key? key}) : super(key: key);

  @override
  State<MasaName> createState() => _MasaNameState();
}

class _MasaNameState extends State<MasaName> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 50)),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: (_height / 20)),
            child: const Text('MASA İSİMI', style: TextStyle(fontSize: 20)),
          ),
          Container(
            margin: EdgeInsets.only(
                top: (_height / 90), left: (_width / 10), right: (_width / 10)),
            child: TextField(
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.blue.shade50),
              controller: _masaName,
              textAlign: TextAlign.center,
              cursorColor: Colors.blue,
              textInputAction: TextInputAction.go,
              onChanged: (value) {
                _isNameChange = true;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OnayButon extends StatelessWidget {
  const OnayButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: (_height / 20), top: (_height / 6)),
      child: ElevatedButton(
        onPressed: () {
          _sendRefData(context, _cafe);
        },
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('ONAYLA'),
      ),
    );
  }
}

String _masaNameGet(String masaNo) {
  if (_cafe.masaCode == null) {
    EasyLoading.showToast('Masa isimi getirilemedi !');
    return '';
  }

  if (_cafe.masaCode!.masaNameS == null) {
    EasyLoading.showToast('Masa isimi getirilemedi !');
    return '';
  }

  for (var i = 0; i < _cafe.masaCode!.masaNameS!.length; i++) {
    if (masaNo == _cafe.masaCode!.masaNameS![i].masaNo) {
      String? masaName;
      masaName = _cafe.masaCode!.masaNameS![i].masaName;
      if (masaName == null || masaName == '') {
        return '';
      }
      return masaName;
    }
  }
  return '';
}

_sendRefData(BuildContext context, Cafe cafe) async {
  if (_isCapChange) {
    if (_masaCap.text.isEmpty) {
      EasyLoading.showToast('LÜTFEN MASA KAPASİTESİNİ GİRİNİZ');
    } else {
      for (var i = 0; i < _masaCap.text.length; i++) {
        if (_masaCap.text[i] == ',' || _masaCap.text[i] == '.') {
          _masaCap.text = _masaCap.text.substring(0, i) +
              _masaCap.text.substring(i + 1, _masaCap.text.length);
        }
      }
      _masa.cap = int.parse(_masaCap.text);
      _cafe.masa!.masa![_ind] = _masa;
      _sendRefCap(context, _cafe);
    }
  }
  if (_isNameChange) {
    if (_masaName.text.isEmpty) {
      EasyLoading.showToast('LÜTFEN MASA İSMİ GİRİNİZ');
    } else {
      _cafe.masaCode!.masaNo = _masa.no;
      _cafe.masaCode!.name = _masaName.text;
      _sendRefName(context, cafe);
    }
  }
}

_sendRefCap(BuildContext context, Cafe cafe) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);

  Cafe musteri = Cafe();
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  cafe.tokens = tok;

  cafe.istekTip = 'masa_ref';

  var json = jsonEncode(cafe.toMap());
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        _isCapOK = true;
        if (!(_isNameChange && !_isNameOk)) {
          EasyLoading.showToast('BAŞARILI');
          Navigator.pushNamedAndRemoveUntil(context, '/CafeHomePage',
              (route) => route.settings.name == '/CafeHomePage',
              arguments: musteri);
        }
      } else if (musteri.status == false) {
        _isCapOK = true;
        EasyLoading.showToast('BİR HATA OLUŞTU\nKAPASİTE DEĞİŞMEDİ');
      } else {
        _isCapOK = true;
        EasyLoading.showToast('BİR HATA OLUŞTU\nKAPASİTE DEĞİŞMEDİ');
      }

      channel.sink.close();
    },
    onError: (error) =>
        {EasyLoading.showToast('BİR HATA OLUŞTU\nKAPASİTE DEĞİŞMEDİ')},
    onDone: () => {},
  );
}

_sendRefName(BuildContext context, Cafe cafe) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);

  Cafe musteri = Cafe();
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  cafe.tokens = tok;

  cafe.istekTip = 'masa_name_ref';

  var json = jsonEncode(cafe.toMap());
  channel.sink.add(json);
  channel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);
      musteri = Cafe.fromMap(jsonobject);

      if (musteri.status == true) {
        _isNameOk = true;
        if (!(_isCapChange && !_isCapOK)) {
          EasyLoading.showToast('BAŞARILI');
          Navigator.pushNamedAndRemoveUntil(context, '/CafeHomePage',
              (route) => route.settings.name == '/CafeHomePage',
              arguments: musteri);
        }
      } else if (musteri.status == false) {
        _isNameOk = true;
        EasyLoading.showToast('BİR HATA OLUŞTU\nİSİM DEĞİŞMEDİ');
      } else {
        _isNameOk = true;
        EasyLoading.showToast('BİR HATA OLUŞTU\nİSİM DEĞİŞMEDİ');
      }

      channel.sink.close();
    },
    onError: (error) =>
        {EasyLoading.showToast('BİR HATA OLUŞTU\nİSİM DEĞİŞMEDİ')},
    onDone: () => {},
  );
}
