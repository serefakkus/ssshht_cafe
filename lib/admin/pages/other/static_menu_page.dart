import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../main.dart';
import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../model/cafe.dart';
import '../../model/musterimodel.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Cafe _cafe = Cafe();
List<String> _imgurl = [];
List<Uint8List> _imagebit = [];
// ignore: non_constant_identifier_names
int _NewImage = 0;
bool _isEkle = false;
TextEditingController _sayfacontroller = TextEditingController();

class CafeStaticMenuPage extends StatefulWidget {
  const CafeStaticMenuPage({Key? key}) : super(key: key);

  @override
  State<CafeStaticMenuPage> createState() => _CafeStaticMenuPageState();
}

class _CafeStaticMenuPageState extends State<CafeStaticMenuPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    int _pageCount = 0;
    if (_cafe.cafeAyar!.menuImages != null) {
      _pageCount = _cafe.cafeAyar!.menuImages!.length;
    }

    _pageCount = _pageCount + _NewImage;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: _width / 15,
                top: _height / 20,
              ),
              child: _backButon(context),
            ),
            Container(
              margin: EdgeInsets.only(
                top: _height / 20,
                right: _width / 29,
              ),
              width: _width / 3,
              height: _height / 12,
              child: _ekleButon(context),
            ),
          ],
        ),
        Flexible(
          child: ListView.builder(
            itemCount: _pageCount,
            itemBuilder: (context, index) {
              int _oldImagesCount = 0;
              if (_cafe.cafeAyar!.menuImages != null) {
                _oldImagesCount = _cafe.cafeAyar!.menuImages!.length;
              }
              if (index >= _oldImagesCount && _NewImage > 0) {
                return _fileImage(context, index, _oldImagesCount);
              }
              return _getImage(index);
            },
          ),
        ),
      ],
    );
  }

  _getImage(int index) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: _height / 30,
            bottom: _height / 50,
          ),
          child: Text('SAYFA' + (index + 1).toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: _width / 20)),
        ),
        Container(
          margin: EdgeInsets.only(bottom: _height / 30),
          child: Icon(
            Icons.arrow_downward_outlined,
            size: _height / 20,
          ),
        ),
        GestureDetector(
          child: CachedNetworkImage(
            imageUrl: imageurl + _cafe.cafeAyar!.menuImages![index],
            placeholder: (context, url) => Container(
              margin: EdgeInsets.only(
                left: _width / 3,
                right: _width / 3,
              ),
              child: const CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Container(
              margin: EdgeInsets.only(
                left: _width / 3,
                right: _width / 3,
              ),
              child: Column(
                children: [
                  const Text(
                      "RESİM YÜKLENEMEDI!\nLÜTFEN RESMİ, ÜNLEM İŞARETİNİN ÜZERİNE BASILI TUTARAK SILİN"),
                  Icon(
                    Icons.error,
                    size: _width / 10,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _imageSil(context, index),
                        _imageChangeIndex(context, index),
                        _vazgecButon(context),
                      ],
                    )
                  ],
                  content: Text('SAYFA = ${index + 1}'),
                );
              },
            );
          },
        ),
      ],
    );
  }

  void _showPhotoLibrary(BuildContext context) async {
    final file =
        // ignore: invalid_use_of_visible_for_testing_member
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    var _image = file?.readAsBytes;
    if (_image != null) {
      _imgurl.add(file!.path);
      _NewImage++;

      var _imgbit = await file.readAsBytes();
      _imagebit = [];
      _imagebit.add(_imgbit);
      _isEkle = true;
      setState(() {});
      //Navigator.pop(context);
    }
  }

  ElevatedButton _ekleButon(BuildContext context) {
    return ElevatedButton(
      child: Text(_isEkleStr(_isEkle)),
      style: ElevatedButton.styleFrom(
          elevation: 20,
          fixedSize: Size((_width * 0.25), (_height / 20)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: () {
        if (_isEkle) {
          for (var i = 0; i < _NewImage; i++) {
            showDialog(
              context: context,
              builder: (context) {
                return SizedBox(
                  width: _width,
                  height: _height,
                  child: Container(
                    color: Colors.white12,
                    child: Center(
                      child: SizedBox(
                        width: _width / 2,
                        height: _width / 2,
                        child: const CircularProgressIndicator(),
                      ),
                    ),
                  ),
                );
              },
            );
            _sendImage(context, i);
          }
        } else {
          _showPhotoLibrary(context);
        }
      },
    );
  }

  _silDialogForFileImage(BuildContext context, int index, int _oldImagesCount) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _vazgecButon(context),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 10,
                        fixedSize: Size((_width * 0.25), (_height / 20)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      _imgurl.removeAt(index - _oldImagesCount);
                      _NewImage--;

                      _isEkle = false;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('SİL'))
              ],
            )
          ],
          content: const Text('SİLMEK İSTEDİĞİNİZDEN EMİNMİSİNİZ?'),
        );
      },
    );
  }

  GestureDetector _fileImage(
      BuildContext context, int index, int _oldImagesCount) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: (_height / 40)),
        child: ClipRRect(
          child: Image.file(
            File(_imgurl[index - _oldImagesCount]),
            fit: BoxFit.cover,
            height: (_height / 1.2),
            width: (_width / 1.2),
          ),
        ),
      ),
      onLongPress: () {
        _silDialogForFileImage(context, index, _oldImagesCount);
      },
    );
  }
}

String _isEkleStr(bool ok) {
  if (ok) {
    return 'ONAYLA';
  }
  return 'SAYFA EKLE';
}

_sendRefAyar(BuildContext context) async {
  var _tok = Tokens();
  _tok.tokenDetails = await getToken(context);
  _cafe.tokens = _tok;

  _cafe.istekTip = 'ayar_ref';

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());
  _isEkle = false;
  _NewImage = 0;
  _imgurl = [];
  _imagebit = [];
  sendRefMenuAyar(json, _channel, context);
}

_sendImage(BuildContext context, int index) async {
  MediaIp _mediaip = MediaIp();
  _mediaip.media = _imagebit[index];
  _mediaip.objectTip = _imgurl[index].substring(_imgurl[index].length - 3);
  _cafe.mediaIp = [_mediaip];

  var _tok = Tokens();
  _tok.tokenDetails = await getToken(context);
  _cafe.tokens = _tok;

  _cafe.istekTip = 'media_new';

  WebSocketChannel _channel2 = IOWebSocketChannel.connect(urlAdmin);

  var _json = jsonEncode(_cafe.toMap());

  _channel2.sink.add(_json);

  _channel2.stream.listen((data) {
    var _musteri = Cafe();
    var jsonobject = jsonDecode(data);
    _musteri = Cafe.fromMap(jsonobject);

    if (_musteri.status == true) {
      if (_cafe.cafeAyar!.menuImages == null) {
        _cafe.cafeAyar!.menuImages = [_musteri.mediaIp![0].objectId!];
      } else {
        _cafe.cafeAyar!.menuImages!.add(_musteri.mediaIp![0].objectId!);
      }
      if (index == _NewImage - 1) {
        _sendRefAyar(context);
      }
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

class SayfaInput extends StatelessWidget {
  const SayfaInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 30), left: (_width / 15), right: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          controller: _sayfacontroller,
          cursorColor: Colors.blue,
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

ElevatedButton _vazgecButon(BuildContext context) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 10,
          fixedSize: Size((_width * 0.25), (_height / 20)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('VAZGEÇ'));
}

GestureDetector _backButon(BuildContext context) {
  return GestureDetector(
    child: const Icon(
      Icons.arrow_back_rounded,
      size: 45,
    ),
    onTap: () {
      Navigator.pop(context);
    },
  );
}

ElevatedButton _imageChangeIndex(BuildContext context, int index) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 10,
          fixedSize: Size((_width * 0.25), (_height / 20)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                Column(
                  children: [
                    const Text('SAYFA NUMARASI'),
                    const SayfaInput(),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            fixedSize: Size((_width * 0.25), (_height / 20)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          _changeIndex(context, index);
                        },
                        child: const Text('DEĞİŞTİR')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            fixedSize: Size((_width * 0.25), (_height / 20)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('İPTAL')),
                  ],
                )
              ],
            );
          },
        );
      },
      child: const Text('SAYFA DEĞİŞTİR'));
}

void _changeIndex(BuildContext context, int index) {
  if (_sayfacontroller.text.isNotEmpty) {
    int? _selectedIndex = int.tryParse(_sayfacontroller.text);
    if (_selectedIndex != null) {
      if (_selectedIndex >= 0) {
        _selectedIndex--;

        List<String> _newList = [];
        if (_selectedIndex != index) {
          if (_selectedIndex < index) {
            for (var i = 0; i < _cafe.cafeAyar!.menuImages!.length; i++) {
              if (_selectedIndex == i) {
                _newList.add(_cafe.cafeAyar!.menuImages![index]);
              }
              if (index != i) {
                _newList.add(_cafe.cafeAyar!.menuImages![i]);
              }
            }
            _cafe.cafeAyar!.menuImages = _newList;

            _sendRefAyar(context);
          } else {
            EasyLoading.showToast(
                "SAYFA NUMARASI SEÇİLEN SAYFADAN\n BÜYÜK OLAMAZ",
                duration: const Duration(seconds: 3));
          }
        } else {
          EasyLoading.showToast("SEÇİLEN SAYFA İLE AYNI",
              duration: const Duration(seconds: 3));
          Navigator.pop(context);
        }
      }
    }
  }
}

ElevatedButton _imageSil(BuildContext context, int index) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 10,
          fixedSize: Size((_width * 0.25), (_height / 20)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actions: [
                Column(
                  children: [
                    const Text('SAYFAYI SİLMEK İSTEDİĞİNİZE EMİNMİSİNİZ?'),
                    Row(
                      children: [
                        _vazgecButon(context),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                fixedSize:
                                    Size((_width * 0.25), (_height / 20)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () {
                              _cafe.cafeAyar!.menuImages!.removeAt(index);

                              _sendRefAyar(context);
                            },
                            child: const Text('ONAY')),
                      ],
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
      child: const Text('SiL'));
}
