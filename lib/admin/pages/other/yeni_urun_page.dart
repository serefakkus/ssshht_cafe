import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musterimodel.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

String _imgurl = '';
TextEditingController _icerik = TextEditingController();
TextEditingController _baslik = TextEditingController();
TextEditingController _fiyat = TextEditingController();
TextEditingController _puan = TextEditingController();
TextEditingController _odul = TextEditingController();
List<dynamic> _gelen = [];
Cafe _cafe = Cafe();
String _kategoriname = '';
String _resimid = '';
bool _isAsset = false;
Uint8List _imagebit = Uint8List(0);

class CafeYeniUrunPage extends StatefulWidget {
  const CafeYeniUrunPage({Key? key}) : super(key: key);

  @override
  State<CafeYeniUrunPage> createState() => _CafeYeniUrunPageState();
}

class _CafeYeniUrunPageState extends State<CafeYeniUrunPage> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _kategoriname = _gelen[1];
    debugPrint('gelen = ' + _kategoriname);

    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return const MenuDetay();
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
        const GeriButon(),
        const UrunImg(),
        const Baslik(),
        const Icerik(),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [Kazanilan(), Puan(), Fiyat()],
          ),
        ),
        const Onayla()
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
    if (!_isAsset) {
      return SizedBox(
        //height: (_height / 4),
        width: (_width / 1.5),
        child: GestureDetector(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: const Icon(
                Icons.add_a_photo,
                size: 50,
              )),
          onTap: () {
            _showOptions(context);
          },
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: (_height / 40)),
        child: GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.file(
              File(_imgurl),
              fit: BoxFit.cover,
              height: (_height / 4),
              width: (_width / 1.3),
            ),
          ),
          onTap: () {
            _showOptions(context);
          },
        ),
      );
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text("Take a picture from camera"),
                  onTap: () {
                    _showPhotoCamera(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Choose from photo library"),
                  onTap: () {
                    _showPhotoLibrary(context);
                  },
                )
              ]));
        });
  }

  void _showPhotoLibrary(BuildContext context) async {
    final file =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    var _image = file?.readAsBytes;
    if (_image != null) {
      _isAsset = true;
      _imgurl = file!.path;
      _imagebit = await file.readAsBytes();

      setState(() {});
      Navigator.pop(context);
    }
  }

  void _showPhotoCamera(BuildContext context) async {
    final file =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    var _image = file?.readAsBytes;
    if (_image != null) {
      _isAsset = true;
      _imgurl = file!.path;
      _imagebit = await file.readAsBytes();

      setState(() {});
      Navigator.pop(context);
    }
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
          Navigator.pushNamedAndRemoveUntil(context, '/CafeMenuPage',
              (route) => route.settings.name == '/CafeHomePage',
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
          child: const Text('İÇERİK'),
          margin: EdgeInsets.only(top: (_height / 50)),
        ),
        Container(
          margin: EdgeInsets.only(
              left: (_width / 50), right: (_width / 50), top: (_height / 50)),
          child: TextField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
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
            child: const Text('BAŞLIK'),
            margin: EdgeInsets.only(top: (_height / 50)),
          ),
          Container(
            margin: EdgeInsets.only(
                left: (_width / 50), right: (_width / 50), top: (_height / 50)),
            child: TextField(
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
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
    return SizedBox(
      width: (_width / 4),
      child: Column(
        children: [
          Container(
            child: const Text('FİYAT'),
            margin: EdgeInsets.only(top: (_height / 50)),
          ),
          Container(
            margin: EdgeInsets.only(
                left: (_width / 50), right: (_width / 50), top: (_height / 50)),
            child: TextField(
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.blue.shade50),
              controller: _fiyat,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
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
    return SizedBox(
        width: (_width / 4),
        child: Column(
          children: [
            Container(
              child: const Text('PUAN'),
              margin: EdgeInsets.only(top: (_height / 50)),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: (_width / 50),
                  right: (_width / 50),
                  top: (_height / 50)),
              child: TextField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue.shade50),
                controller: _puan,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ));
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
    return SizedBox(
        width: (_width / 4),
        child: Column(
          children: [
            Container(
              child: const Text('ÖDÜL'),
              margin: EdgeInsets.only(top: (_height / 50)),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: (_width / 50),
                  right: (_width / 50),
                  top: (_height / 50)),
              child: TextField(
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue.shade50),
                controller: _odul,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ));
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
          child: const Text('ONAYLA'),
          onPressed: () {
            if (_isAsset) {
              _sendImage(context);
            } else {
              _onay(context, '');
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
  _cafe.tokens = _tok;

  _cafe.istekTip = 'menu_ref';

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlAdmin);

  var json = jsonEncode(_cafe.toMap());

  sendDataNewUrun(json, _channel, context, _cafe);
}

_sendImage(BuildContext context) async {
  MediaIp _mediaip = MediaIp();
  _mediaip.media = _imagebit;
  _mediaip.objectTip = _imgurl.substring(_imgurl.length - 3);
  _cafe.mediaIp = [_mediaip];

  var _tok = Tokens();
  _tok.tokenDetails = await getToken(context);
  _cafe.tokens = _tok;

  _cafe.istekTip = 'media_new';

  WebSocketChannel _channel2 = IOWebSocketChannel.connect(urlAdmin);

  var _json = jsonEncode(_cafe.toMap());
  debugPrint(_json.length.toString());

  _channel2.sink.add(_json);

  _channel2.stream.listen((data) {
    var _musteri = Cafe();
    var jsonobject = jsonDecode(data);
    _musteri = Cafe.fromMap(jsonobject);

    if (_musteri.status == true) {
      _resimid = _musteri.mediaIp![0].objectId!;
      _onay(context, _resimid);
    } else if (_musteri.status == false) {
      EasyLoading.showToast(
          'RESiM YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
    } else {
      EasyLoading.showToast(
          'RESiM YÜKLERNİRKEN BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
    }

    _channel2.sink.close();
  });
}

_onay(BuildContext context, String id) async {
  bool _urunok = true;
  UrunCafe _urun = UrunCafe();
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
      _urun.indirim = double.parse(_odul.text);
    }

    for (var i = 0; i < _fiyat.text.length; i++) {
      if (_fiyat.text[i] == ',') {
        _fiyat.text = _fiyat.text.substring(0, i - 1) +
            '.' +
            _fiyat.text.substring(i + 1, _fiyat.text.length);
      }
    }

    _urun.tarif = _icerik.text;
    _urun.name = _baslik.text;
    _urun.ucret = double.parse(_fiyat.text);

    _urun.resimId = id;

    for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
      if (_cafe.menu!.kategori![i].name == _kategoriname) {
        if (_cafe.menu!.kategori![i].urun != null) {
          for (var c = 0; c < _cafe.menu!.kategori![i].urun!.length; c++) {
            if (_cafe.menu!.kategori![i].urun![c].name == _urun.name) {
              _urunok = false;
              EasyLoading.showToast('AYNI İSİMLİ BİR ÜRÜN MEVCUT');
            }
          }
        }

        if (_cafe.menu!.kategori![i].urun == null) {
          _cafe.menu!.kategori![i].urun = [_urun];
        } else {
          _cafe.menu!.kategori![i].urun!.add(_urun);
        }
      }
    }
    if (_urunok) {
      _sendRefMenu(context);
    }
  }
}
