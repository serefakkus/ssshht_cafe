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
KategoriCafe _kategoriCafe = KategoriCafe();
int _urunind = -1;
bool _isImage = false;
bool _isokimage = false;
bool _isAsset = false;
Uint8List _imagebit = Uint8List(0);

class CafeKateDetayPage extends StatefulWidget {
  const CafeKateDetayPage({Key? key}) : super(key: key);

  @override
  State<CafeKateDetayPage> createState() => _CafeKateDetayPageState();
}

class _CafeKateDetayPageState extends State<CafeKateDetayPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isImage = false;
    _isokimage = false;
    _isAsset = false;
  }

  @override
  Widget build(BuildContext context) {
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _kategoriname = _gelen[1];
    for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
      if (_kategoriname == _cafe.menu!.kategori![i].name) {
        _kategoriCafe = _cafe.menu!.kategori![i];
      }
    }
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Scaffold(
      body: MenuDetay(),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin:
                EdgeInsets.only(right: (_width / 10), bottom: (_height / 30)),
            child: SizedBox(
              height: (_height / 15),
              width: (_width / 4),
              child: ElevatedButton(
                child: Text('ONAYLA'),
                onPressed: () {
                  _onayla();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  _onayla() {
    if (_isAsset) {
      _sendImage(context);
    } else {
      _senddata();
    }
  }

  _senddata() {
    if (_baslik.text.length < 2) {
      EasyLoading.showToast('İSİM EN AZ 2 KARAKTER OLAMLI');
    } else {
      _kategoriCafe.name = _baslik.text;
      for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
        if (_kategoriname == _cafe.menu!.kategori![i].name) {
          _cafe.menu!.kategori![i] = _kategoriCafe;
        }
      }

      _sendRefMenu(context);
    }
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
        _isokimage = true;

        _kategoriCafe.resimid = _musteri.mediaIp![0].objectId;
        _senddata();
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
}

class MenuDetay extends StatefulWidget {
  const MenuDetay({Key? key}) : super(key: key);

  @override
  State<MenuDetay> createState() => _MenuDetayState();
}

class _MenuDetayState extends State<MenuDetay> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _baslik.text = _kategoriname.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [GeriButon(), SilButon()],
        ),
        UrunImg(),
        Baslik(),
      ],
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

_urunkapat(BuildContext context) async {
  var _st = false;
  for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
    if (_cafe.menu!.kategori![i].name == _kategoriname &&
        _cafe.menu!.kategori![i].urun != null) {
      for (var c = 0; c < _cafe.menu!.kategori![i].urun!.length; c++) {
        _cafe.menu!.kategori![i].urun![c].durum = false;
      }
    }
  }
  var _tok = Tokens();
  _tok.tokenDetails = await getToken(context);
  _cafe.tokens = _tok;

  _cafe.istekTip = 'menu_ref';

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());
  sendDataUrunKapat(json, _channel, context, _st, _cafe);
}

class UrunImg extends StatefulWidget {
  const UrunImg({Key? key}) : super(key: key);

  @override
  State<UrunImg> createState() => _UrunImgState();
}

class _UrunImgState extends State<UrunImg> {
  @override
  Widget build(BuildContext context) {
    if (_kategoriCafe.resimid != null && _kategoriCafe.resimid != '') {
      _isImage = true;
    }
    if (!_isImage) {
      return SizedBox(
        //height: (_height / 4),
        width: (_width / 1.5),
        child: GestureDetector(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Icon(
                Icons.add_a_photo,
                size: 50,
              )),
          onTap: () {
            _showOptions(context);
          },
        ),
      );
    } else if (_isAsset) {
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
    } else {
      _imgurl = imageurl + _kategoriCafe.resimid!;

      return Container(
        margin: EdgeInsets.only(top: (_height / 30), left: (_width / 15)),
        child: GestureDetector(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image(
              image: NetworkImage(_imgurl),
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
                  title: Text("Take a picture from camera"),
                  onTap: () {
                    _showPhotoCamera(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text("Choose from photo library"),
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
      _isImage = true;
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
      _isImage = true;
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
      margin: EdgeInsets.only(top: (_height / 30), left: (_width / 20)),
      alignment: Alignment.topLeft,
      child: GestureDetector(
        child: Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: (_width / 8),
        ),
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(context, '/CafeMenuPage',
              (Route) => Route.settings.name == '/CafeHomePage',
              arguments: _cafe);
        },
      ),
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
              primary: Colors.red,
              elevation: 10,
              fixedSize: Size((_width * 0.2), (_height / 18)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: const Text(
            'SİL',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (Builder) => AlertDialog(
                      title: Text(_kategoriCafe.name.toString()),
                      content: Text(
                          'KATEGORİYİ SİLMEK İSTEDİĞİNİZE !\nEMİNMİSİNİZ?'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('VAZGEÇ')),
                        ElevatedButton(
                            onPressed: () {
                              for (var i = 0;
                                  i < _cafe.menu!.kategori!.length;
                                  i++) {
                                if (_cafe.menu!.kategori![i].name ==
                                    _kategoriname) {
                                  _cafe.menu!.kategori!.removeAt(i);
                                } else {
                                  EasyLoading.showToast('bir hata olustu');
                                }
                              }

                              _sendRefMenu(context);
                            },
                            child: Text('ONAY')),
                      ],
                    ));
          }),
    );
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

class UrunuKapat extends StatelessWidget {
  const UrunuKapat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: (_width / 10), bottom: (_height / 30)),
      child: SizedBox(
        height: (_height / 15),
        width: (_width / 3),
        child: ElevatedButton(
          child: Text('KAPAT'),
          onPressed: () {
            showDialog(
                context: context,
                builder: (Builder) => AlertDialog(
                      content: Text(
                          'Ürünleri satışa Kapatmak İstediğinize !\nEMİNMİSİNİZ?'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('VAZGEÇ')),
                        ElevatedButton(
                            onPressed: () {
                              _urunkapat(context);
                              Navigator.pop(context);
                            },
                            child: Text('ONAY')),
                      ],
                    ));
          },
        ),
      ),
    );
  }
}
