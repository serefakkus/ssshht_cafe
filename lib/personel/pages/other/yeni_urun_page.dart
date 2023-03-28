import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

String _imgurl =
    'https://cdn.yemek.com/mnresize/940/940/uploads/2020/05/atom-tost-yemekcom.jpg';

UrunCafe _urun = UrunCafe();
TextEditingController _icerik = TextEditingController();
TextEditingController _baslik = TextEditingController();
TextEditingController _fiyat = TextEditingController();
TextEditingController _puan = TextEditingController();
TextEditingController _odul = TextEditingController();
List<dynamic> _gelen = [];
Personel _cafe = Personel();
String _kategoriname = '';
int _urunind = -1;

class PersonelYeniUrunPage extends StatefulWidget {
  const PersonelYeniUrunPage({Key? key}) : super(key: key);

  @override
  State<PersonelYeniUrunPage> createState() => _PersonelYeniUrunPageState();
}

class _PersonelYeniUrunPageState extends State<PersonelYeniUrunPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _kategoriname = _gelen[1];

    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return MenuDetay();
  }
}

class MenuDetay extends StatefulWidget {
  const MenuDetay({Key? key}) : super(key: key);

  @override
  State<MenuDetay> createState() => _MenuDetayState();
}

class _MenuDetayState extends State<MenuDetay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GeriButon(),
        UrunImg(),
        Baslik(),
        Icerik(),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Kazanilan(), Puan(), const Fiyat()],
          ),
        ),
        Onayla()
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
      margin: EdgeInsets.only(top: (_height / 30), left: (_width / 15)),
      child: SizedBox(
        //height: (_height / 4),
        width: (_width / 1.5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image(
            image: NetworkImage(_imgurl),
          ),
        ),
      ),
    );
  }
}

class GeriButon extends StatelessWidget {
  const GeriButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 40)),
      alignment: Alignment.topLeft,
      child: GestureDetector(
        child: Icon(
          Icons.backspace,
          color: Colors.blue,
          size: (_width / 8),
        ),
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(context, '/MenuPage',
              (Route) => Route.settings.name == '/HomePage',
              arguments: _cafe);
        },
      ),
    );
  }
}

class Icerik extends StatefulWidget {
  const Icerik({Key? key}) : super(key: key);

  @override
  State<Icerik> createState() => _IcerikState();
}

class _IcerikState extends State<Icerik> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      children: [
        Container(
          child: Text('İÇERİK'),
          margin: EdgeInsets.only(top: (_height / 50)),
        ),
        Container(
          margin: EdgeInsets.only(
              left: (_width / 50), right: (_width / 50), top: (_height / 50)),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.blue.shade50),
            controller: _icerik,
            maxLines: 3,
          ),
        ),
      ],
    ));
  }
}

class Baslik extends StatefulWidget {
  const Baslik({Key? key}) : super(key: key);

  @override
  State<Baslik> createState() => _BaslikState();
}

class _BaslikState extends State<Baslik> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Container(
            child: Text('BAŞLIK'),
            margin: EdgeInsets.only(top: (_height / 50)),
          ),
          Container(
            margin: EdgeInsets.only(
                left: (_width / 50), right: (_width / 50), top: (_height / 50)),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.blue.shade50),
              controller: _baslik,
            ),
          ),
        ],
      ),
    );
  }
}

class Fiyat extends StatelessWidget {
  const Fiyat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: (_width / 4),
        child: Column(
          children: [
            Container(
              child: Text('FİYAT'),
              margin: EdgeInsets.only(top: (_height / 50)),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: (_width / 50),
                  right: (_width / 50),
                  top: (_height / 50)),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue.shade50),
                controller: _fiyat,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Puan extends StatefulWidget {
  const Puan({Key? key}) : super(key: key);

  @override
  State<Puan> createState() => _PuanState();
}

class _PuanState extends State<Puan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
          width: (_width / 4),
          child: Column(
            children: [
              Container(
                child: Text('PUAN'),
                margin: EdgeInsets.only(top: (_height / 50)),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: (_width / 50),
                    right: (_width / 50),
                    top: (_height / 50)),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.blue.shade50),
                  controller: _puan,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          )),
    );
  }
}

class Kazanilan extends StatefulWidget {
  const Kazanilan({Key? key}) : super(key: key);

  @override
  State<Kazanilan> createState() => _KazanilanState();
}

class _KazanilanState extends State<Kazanilan> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
          width: (_width / 4),
          child: Column(
            children: [
              Container(
                child: Text('ÖDÜL'),
                margin: EdgeInsets.only(top: (_height / 50)),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: (_width / 50),
                    right: (_width / 50),
                    top: (_height / 50)),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.blue.shade50),
                  controller: _odul,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          )),
    );
  }
}

class Onayla extends StatelessWidget {
  const Onayla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: (_width / 10), bottom: (_height / 30)),
      child: SizedBox(
        height: (_height / 15),
        width: (_width / 4),
        child: ElevatedButton(
          child: Text('ONAYLA'),
          onPressed: () {
            if (_baslik.text.length < 2) {
              EasyLoading.showToast('İSİM EN AZ 2 KARAKTER OLAMLI');
            } else if (_fiyat.text.isEmpty ||
                !(double.parse(_fiyat.text.toString()) > 0)) {
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
                _urun.puan = double.parse(_puan.text);
              }
              if (_odul.text.isNotEmpty && _odul.text != '0') {
                for (var i = 0; i < _odul.text.length; i++) {
                  if (_odul.text[i] == ',') {
                    _odul.text = _odul.text.substring(0, i - 1) +
                        '.' +
                        _odul.text.substring(i + 1, _odul.text.length);
                  }
                }
                _urun.indirim = double.parse(_puan.text);
              }

              for (var i = 0; i < _fiyat.text.length; i++) {
                if (_fiyat.text[i] == ',') {
                  _fiyat.text = _fiyat.text.substring(0, i - 1) +
                      '.' +
                      _fiyat.text.substring(i + 1, _fiyat.text.length);
                }
              }

              _urun.name = _baslik.text;
              _urun.ucret = double.parse(_fiyat.text);

              for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
                if (_cafe.menu!.kategori![i].name == _kategoriname) {
                  if (_cafe.menu!.kategori![i].urun == null) {
                    _cafe.menu!.kategori![i].urun = [_urun];
                  } else {
                    _cafe.menu!.kategori![i].urun!.add(_urun);
                  }
                }
              }

              _sendRefMenu(context);
            }
          },
        ),
      ),
    );
  }
}

_sendRefMenu(BuildContext context) async {
  var _tok = Tokens();
  _tok.tokenDetails = await getToken(context);
  _cafe.token = _tok;

  _cafe.istekTip = 'menu_ref';

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlPeronel);

  var json = jsonEncode(_cafe.toMap());
  debugPrint('sdfsdf');

  sendDataNewUrun(json, _channel, context, _cafe);
}
