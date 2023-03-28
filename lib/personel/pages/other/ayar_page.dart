import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Personel _cafe = Personel();
bool _ok2 = false;
bool _yetki = false;

class PersonelAyarPage extends StatelessWidget {
  const PersonelAyarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Personel;
    if (_cafe.cafeAyar != null) {
      if (_cafe.cafeAyar!.puan != null) {
        _ok2 = _cafe.cafeAyar!.puan!;
      }
    }
    if (_cafe.yetki != null) {
      _yetki = _cafe.yetki![3];
    }
    debugPrint(_cafe.cafeAyar!.toMap().toString());
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    if (_cafe.cafeAyar?.puan == null) {
      Navigator.pop(context);
      return Container();
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: (_height / 20), left: (_width / 15)),
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 50,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const CikisButon()
            ],
          ),
          const Status(),
          Row(
            children: const [PuanButon(), CafeSil()],
          )
        ],
      );
    }
  }
}

_icon(bool ok) {
  if (ok == true) {
    return Icon(
      Icons.check_box,
      size: (_width / 7),
      color: Colors.green,
    );
  } else {
    return Icon(
      Icons.indeterminate_check_box,
      size: (_width / 7),
      color: Colors.red,
    );
  }
}

String _puanstr(bool ok) {
  if (ok) {
    return 'AÇIK';
  } else {
    return 'KAPALI';
  }
}

String _puanButonstr(bool ok) {
  if (ok) {
    return 'PUAN KULLANIMINI KAPAT';
  } else {
    return 'PUAN KULLANIMI AÇ';
  }
}

_color(bool ok) {
  if (ok) {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 5)),
      child: SizedBox(
          // width: (_width / 6),
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: (_height / 40),
            ),
            child: const SizedBox(
              child: Text(
                'PUAN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              //height: (_height / 25),
              //width: (_width / 3),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                right: (_width / 13),
                left: (_width / 60),
                bottom: (_height / 100)),
            child: IconButton(
              icon: _icon(_ok2),
              onPressed: () {
                if (_yetki == true) {
                  if (_ok2 == true) {
                    _cafe.cafeAyar!.puan = false;
                  } else {
                    _cafe.cafeAyar!.puan = true;
                  }
                  _sendRefAyar(context);
                } else {
                  EasyLoading.showToast('YETKİNİZ YOK');
                }
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: (_height / 50)),
            child: Text(
              _puanstr(_ok2),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _color(_ok2)),
            ),
          )
        ],
      )),
    );
  }
}

class PuanButon extends StatefulWidget {
  const PuanButon({Key? key}) : super(key: key);

  @override
  State<PuanButon> createState() => _PuanButonState();
}

class _PuanButonState extends State<PuanButon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 4)),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 10,
              fixedSize: Size((_width * 0.6), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          onPressed: () {
            if (_yetki == true) {
              if (_ok2 == true) {
                _cafe.cafeAyar!.puan = false;
              } else {
                _cafe.cafeAyar!.puan = true;
              }
              _sendRefAyar(context);
            } else {
              EasyLoading.showToast('YETKİNİZ YOK');
            }
          },
          child: Text(_puanButonstr(_ok2))),
    );
  }
}

class CikisButon extends StatelessWidget {
  const CikisButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 13), right: (_width / 15)),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 10,
                              fixedSize: Size((_width * 0.25), (_height / 20)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('VAZGEÇ')),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 10,
                              fixedSize: Size((_width * 0.25), (_height / 20)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            tokensDel();
                            Navigator.pushNamedAndRemoveUntil(context, '/',
                                (route) => route.settings.name == '/');
                          },
                          child: const Text('ÇIKIŞ YAP'))
                    ],
                  )
                ],
                content: const Text('ÇIKIŞ YAPMAK İSTEDİĞİNİZDEN EMİNMİSİNİZ?'),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            elevation: 10,
            fixedSize: Size((_width * 0.3), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: const Text('ÇIKIŞ YAP'),
      ),
    );
  }
}

_sendRefAyar(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.token = tok;

  _cafe.istekTip = 'cafe_ayar_ref';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataPersonelAyar(json, channel, context);
}

class CafeSil extends StatelessWidget {
  const CafeSil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
        onPressed: () {
          showDialog(
              context: context,
              // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
              builder: (Builder) => AlertDialog(
                    title: const Text('UYARI'),
                    content: const Text(
                        'BU KAFE İLE TÜM BAĞLANTINIZ KOPACAK EMİNMİSİNİZ?'),
                    actions: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            _sendCafeAyril(context);
                          },
                          child: const Text('ONAYLA')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('VAZGEÇ'))
                    ],
                  ));
        },
        child: const Text('BU KAFEDEN AYRIL'),
      ),
    );
  }
}

_sendCafeAyril(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.token = tok;

  _cafe.istekTip = 'cafe_ayril';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataCafeAyril(json, channel, context);
}
