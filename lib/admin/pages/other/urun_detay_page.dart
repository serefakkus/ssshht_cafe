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
List<dynamic> _gelen =
    []; // index 0 = cafe, index 1 = urun, index 2 = urun index int
KategoriCafe _kategori = KategoriCafe();
TextEditingController _name = TextEditingController();
TextEditingController _tarif = TextEditingController();
TextEditingController _puan = TextEditingController();
TextEditingController _ucret = TextEditingController();
TextEditingController _kazanilan = TextEditingController();
UrunCafe _urunCafe = UrunCafe();
String _kategoriname = '';
int _urunindex = -1;

class CafeUrunDetayPage extends StatefulWidget {
  const CafeUrunDetayPage({Key? key}) : super(key: key);

  @override
  State<CafeUrunDetayPage> createState() => _CafeUrunDetayPageState();
}

class _CafeUrunDetayPageState extends State<CafeUrunDetayPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _kategoriname = _gelen[1];
    _urunindex = _gelen[2];

    return Container(
      child: YenuUrunBody(),
    );
  }
}

class YenuUrunBody extends StatefulWidget {
  const YenuUrunBody({Key? key}) : super(key: key);

  @override
  State<YenuUrunBody> createState() => _YenuUrunBodyState();
}

class _YenuUrunBodyState extends State<YenuUrunBody> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
      if (_kategoriname == _cafe.menu!.kategori![i].name) {
        _urunCafe = _cafe.menu!.kategori![i].urun![_urunindex];

        _name.text = _urunCafe.name!;
        _ucret.text = _urunCafe.ucret.toString();
        if (_urunCafe.puan != null) {
          _puan.text = _urunCafe.puan.toString();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UrunImg(),
        Container(
          alignment: Alignment.center,
          child: Text(
            'KATEGORİ : ' + _kategoriname.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: ListView(
            children: [
              UrunName(),
              UrunTarif(),
              Row(
                children: [
                  Flexible(child: UrunPuan()),
                  Flexible(child: UrunUcret())
                ],
              ),
              OnayButon()
            ],
          ),
        ),
      ],
    );
  }
}

class UrunImg extends StatefulWidget {
  const UrunImg({Key? key}) : super(key: key);

  @override
  State<UrunImg> createState() => _UrunImgState();
}

class _UrunImgState extends State<UrunImg> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_width / 8)),
      child: SizedBox(
        height: (_height / 5),
        width: (_width / 2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: Image.network(
            'https://ykv.s3.eu-central-1.amazonaws.com/img/tarif/mgt/akdeniz-tost.jpg',
          ),
        ),
      ),
    );
  }
}

class UrunName extends StatefulWidget {
  const UrunName({Key? key}) : super(key: key);

  @override
  State<UrunName> createState() => _UrunNameState();
}

class _UrunNameState extends State<UrunName> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: (_height / 20)),
          child: Text('ÜRÜN ADI', style: TextStyle(fontSize: 20)),
        ),
        Container(
          margin: EdgeInsets.only(
              top: (_height / 90), left: (_width / 10), right: (_width / 10)),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.blue.shade50),
            controller: _name,
            cursorColor: Colors.blue,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            textInputAction: TextInputAction.go,
          ),
        ),
      ],
    );
  }
}

class UrunTarif extends StatefulWidget {
  const UrunTarif({Key? key}) : super(key: key);

  @override
  State<UrunTarif> createState() => _UrunTarifState();
}

class _UrunTarifState extends State<UrunTarif> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: (_height / 20)),
          child: Text('TARİF', style: TextStyle(fontSize: 20)),
        ),
        Container(
          margin: EdgeInsets.only(
              top: (_height / 90), left: (_width / 10), right: (_width / 10)),
          child: TextField(
            maxLines: 3,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.blue.shade50),
            controller: _tarif,
            cursorColor: Colors.blue,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            textInputAction: TextInputAction.go,
          ),
        ),
      ],
    );
  }
}

class UrunUcret extends StatefulWidget {
  const UrunUcret({Key? key}) : super(key: key);

  @override
  State<UrunUcret> createState() => _UrunUcretState();
}

class _UrunUcretState extends State<UrunUcret> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: (_height / 20)),
          child: Text('ÜCRET', style: TextStyle(fontSize: 20)),
        ),
        Container(
          margin: EdgeInsets.only(
              top: (_height / 90), left: (_width / 10), right: (_width / 10)),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.blue.shade50),
            controller: _ucret,
            cursorColor: Colors.blue,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            textInputAction: TextInputAction.go,
          ),
        ),
      ],
    );
  }
}

class UrunPuan extends StatefulWidget {
  const UrunPuan({Key? key}) : super(key: key);

  @override
  State<UrunPuan> createState() => _UrunPuanState();
}

class _UrunPuanState extends State<UrunPuan> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: (_height / 20)),
          child: Text(
            'PUAN',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: (_height / 90), left: (_width / 10), right: (_width / 10)),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.blue.shade50),
            controller: _puan,
            cursorColor: Colors.blue,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            textInputAction: TextInputAction.go,
          ),
        ),
      ],
    );
  }
}

class KazanilanPuan extends StatefulWidget {
  const KazanilanPuan({Key? key}) : super(key: key);

  @override
  State<KazanilanPuan> createState() => _KazanilanPuanState();
}

class _KazanilanPuanState extends State<KazanilanPuan> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: (_height / 20)),
          child: Text(
            'KAZANILAN PUAN',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: (_height / 90), left: (_width / 10), right: (_width / 10)),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.blue.shade50),
            controller: _kazanilan,
            cursorColor: Colors.blue,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            textInputAction: TextInputAction.go,
          ),
        ),
      ],
    );
  }
}

class OnayButon extends StatelessWidget {
  const OnayButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 20), left: (_width / 10), right: (_width / 10)),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.8), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: const Text('GÜNCELLE'),
          onPressed: () {
            if (_name.text.length < 2) {
              EasyLoading.showToast('İSİM EN AZ 2 KARAKTER OLAMLI');
            } else if (_ucret.text.isEmpty ||
                !(double.parse(_ucret.text.toString()) > 0)) {
              EasyLoading.showToast('ÜCRET GİRİNİZ');
            } else {
              if (_puan.text.isNotEmpty && _puan.text != '0') {
                for (var i = 0; i < _puan.text.length; i++) {
                  if (_puan.text[i] == ',') {
                    _puan.text = _puan.text.substring(0, i - 1) +
                        '.' +
                        _puan.text.substring(i + 1, _puan.text.length);
                  }
                }
                _urunCafe.puan = double.parse(_puan.text);
              }
              if (_kazanilan.text.isNotEmpty && _kazanilan.text != '0') {
                for (var i = 0; i < _kazanilan.text.length; i++) {
                  if (_kazanilan.text[i] == ',') {
                    _kazanilan.text = _kazanilan.text.substring(0, i - 1) +
                        '.' +
                        _kazanilan.text
                            .substring(i + 1, _kazanilan.text.length);
                  }
                }
                _urunCafe.indirim = double.parse(_puan.text);
              }

              for (var i = 0; i < _ucret.text.length; i++) {
                if (_ucret.text[i] == ',') {
                  _ucret.text = _ucret.text.substring(0, i - 1) +
                      '.' +
                      _ucret.text.substring(i + 1, _ucret.text.length);
                }
              }

              _urunCafe.name = _name.text;
              _urunCafe.ucret = double.parse(_ucret.text);
              debugPrint('1' + _urunCafe.ucret.toString());

              for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
                if (_cafe.menu!.kategori![i].name == _kategori.name) {
                  _cafe.menu!.kategori![i].urun![_urunindex] = _urunCafe;
                  debugPrint('2' +
                      _cafe.menu!.kategori![i].urun![_urunindex].ucret
                          .toString());
                }
              }

              _sendRefMenu(context);
            }
          }),
    );
  }
}

class SilButon extends StatelessWidget {
  const SilButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 20), left: (_width / 10), right: (_width / 10)),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.8), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: const Text('SİL'),
          onPressed: () {
            if (_name.text.length < 2) {
              EasyLoading.showToast('İSİM EN AZ 2 KARAKTER OLAMLI');
            } else if (_ucret.text.isEmpty ||
                !(double.parse(_ucret.text.toString()) > 0)) {
              EasyLoading.showToast('ÜCRET GİRİNİZ');
            } else {
              if (_puan.text.isNotEmpty && _puan.text != '0') {
                for (var i = 0; i < _puan.text.length; i++) {
                  if (_puan.text[i] == ',') {
                    _puan.text = _puan.text.substring(0, i - 1) +
                        '.' +
                        _puan.text.substring(i + 1, _puan.text.length);
                  }
                }
                _urunCafe.puan = double.parse(_puan.text);
              }
              if (_kazanilan.text.isNotEmpty && _kazanilan.text != '0') {
                for (var i = 0; i < _kazanilan.text.length; i++) {
                  if (_kazanilan.text[i] == ',') {
                    _kazanilan.text = _kazanilan.text.substring(0, i - 1) +
                        '.' +
                        _kazanilan.text
                            .substring(i + 1, _kazanilan.text.length);
                  }
                }
                _urunCafe.indirim = double.parse(_puan.text);
              }

              for (var i = 0; i < _ucret.text.length; i++) {
                if (_ucret.text[i] == ',') {
                  _ucret.text = _ucret.text.substring(0, i - 1) +
                      '.' +
                      _ucret.text.substring(i + 1, _ucret.text.length);
                }
              }
              _urunCafe.name = _name.text;
              _urunCafe.ucret = double.parse(_ucret.text);

              for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
                if (_cafe.menu!.kategori![i].name == _kategori.name) {
                  _cafe.menu!.kategori![i].urun!.removeAt(_urunindex);
                } else {
                  EasyLoading.showToast('bir hata olustu');
                }
              }

              _sendRefMenu(context);
            }
          }),
    );
  }
}

_sendRefMenu(BuildContext context) async {
  var _tok = Tokens();
  _tok.tokenDetails = await getToken(context);
  _cafe.tokens = _tok;

  _cafe.istekTip = 'menu_ref';

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  sendDataNewUrun(json, _channel, context, _cafe);
}
