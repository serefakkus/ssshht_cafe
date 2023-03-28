import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:google_fonts/google_fonts.dart';

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
Cafe _cafe = Cafe();
String _kategoriname = '';
String? _resimid;
bool _isAsset = false;
Uint8List _imagebit = Uint8List(0);

class CafeYeniKatePage extends StatefulWidget {
  const CafeYeniKatePage({Key? key}) : super(key: key);

  @override
  State<CafeYeniKatePage> createState() => _CafeYeniKatePageState();
}

class _CafeYeniKatePageState extends State<CafeYeniKatePage> {
  @override
  void initState() {
    _isAsset = false;
    _imagebit = Uint8List(0);
    _imgurl = '';
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;

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
        YeniKategoriBaslikVeGeri(),
        UrunImg(),
        Baslik(),
        Onayla(),
      ],
    );
  }
}

class YeniKategoriBaslikVeGeri extends StatelessWidget {
  const YeniKategoriBaslikVeGeri({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        YeniKategoriBaslik(),
        Align(
          child: GeriButon(),
          alignment: Alignment.bottomLeft,
        )
      ],
    );
  }
}

class YeniKategoriBaslik extends StatelessWidget {
  const YeniKategoriBaslik({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 10, left: _width / 3.2),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Container(
          margin: EdgeInsets.all(_width / 25),
          child: Text(
            'Kategori',
            style: GoogleFonts.fredokaOne(
                fontSize: _width / 15, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

bool _isUrunImagePress = false;

class UrunImg extends StatefulWidget {
  const UrunImg({Key? key}) : super(key: key);

  @override
  State<UrunImg> createState() => _UrunImgState();
}

class _UrunImgState extends State<UrunImg> {
  @override
  Widget build(BuildContext context) {
    if (!_isAsset) {
      return Container(
        margin: EdgeInsets.only(top: _height / 20),
        child: Card(
          color: Colors.grey[350],
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            margin: EdgeInsets.only(
                top: _height / 600,
                bottom: _height / 30,
                left: _width / 80,
                right: _width / 13),
            child: IconButton(
              icon: Icon(
                Icons.add_a_photo_rounded,
                size: _width / 7,
              ),
              onPressed: () {
                _showOptions(context);
              },
            ),
          ),
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
          return Container(
              height: 150,
              child: Column(children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text("Fotograf çekin"),
                  onTap: () {
                    _showPhotoCamera(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Galeriden seçin"),
                  onTap: () {
                    _showPhotoLibrary(context);
                  },
                )
              ]));
        });
  }

  void _showPhotoLibrary(BuildContext context) async {
    final file =
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
      margin: EdgeInsets.only(top: _height / 15, left: _width / 20),
      alignment: Alignment.topLeft,
      child: GestureDetector(
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.blue,
          size: _width / 8,
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
            child: const Text(
              'BAŞLIK',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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

class Onayla extends StatelessWidget {
  const Onayla({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 10)),
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
    debugPrint(data.toString());
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

_onay(BuildContext context, String? id) async {
  UrunCafe _urun = UrunCafe();
  if (_baslik.text.length < 2) {
    EasyLoading.showToast('İSİM EN AZ 2 KARAKTER OLAMLI');
  } else {
    KategoriCafe _kate = KategoriCafe();
    _kate.name = _baslik.text;
    _kate.resimid = id;
    if (_cafe.menu!.kategori == null) {
      debugPrint('statement1111');
      _cafe.menu!.kategori = [_kate];
    } else {
      debugPrint('statement2222');
      debugPrint(_kate.name.toString());
      _cafe.menu!.kategori!.add(_kate);
    }
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
}
