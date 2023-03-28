import 'dart:convert';

import 'package:flutter/material.dart';
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
bool _ok2 = false;

class CafeAyarPage extends StatelessWidget {
  const CafeAyarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    if (_cafe.cafeAyar != null) {
      if (_cafe.cafeAyar!.puan != null) {
        _ok2 = _cafe.cafeAyar!.puan!;
      }
    }
    debugPrint(_cafe.cafeAyar!.toMap().toString());
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    if (_cafe.cafeAyar?.isStaticMenu == true &&
        _cafe.cafeAyar?.isPdf == true) {}
    if (_cafe.cafeAyar?.puan == null) {
      Navigator.pop(context);
      return Container();
    } else if (_cafe.cafeAyar?.isStaticMenu == true) {
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
          const MenuButon(),
          const PdfButon(),
        ],
      );
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
          const MenuButon()
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
    return 'SABIT MENÜ KULLANIMDA';
  } else {
    return 'SİPARİŞ VERİLEBİLİR MENÜ KULLANIMDA';
  }
}

String _pdfButonstr(bool ok) {
  if (ok) {
    return 'PDF MENÜ KULLANIMDA';
  } else {
    return 'RESİM MENÜ KULLANIMDA';
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
                if (_ok2 == true) {
                  _cafe.cafeAyar!.puan = false;
                } else {
                  _cafe.cafeAyar!.puan = true;
                }
                _sendRefAyar(context);
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

class MenuButon extends StatefulWidget {
  const MenuButon({Key? key}) : super(key: key);

  @override
  State<MenuButon> createState() => _MenuButonState();
}

class _MenuButonState extends State<MenuButon> {
  @override
  Widget build(BuildContext context) {
    if (_cafe.cafeAyar!.isStaticMenu == null) {
      _cafe.cafeAyar!.isStaticMenu = false;
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: (_height / 10)),
          child: Text(
            _puanButonstr(_cafe.cafeAyar!.isStaticMenu!),
            style: TextStyle(
              color: Colors.green.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: (_height / 20)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  fixedSize: Size((_width * 0.6), (_height / 15)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                if (_cafe.cafeAyar!.isStaticMenu == true) {
                  _cafe.cafeAyar!.isStaticMenu = false;
                } else {
                  _cafe.cafeAyar!.isStaticMenu = true;
                }

                _sendRefAyar(context);
              },
              child: const Text("DEGİŞTİR")),
        ),
      ],
    );
  }
}

class PdfButon extends StatefulWidget {
  const PdfButon({Key? key}) : super(key: key);

  @override
  State<PdfButon> createState() => _PdfButonState();
}

class _PdfButonState extends State<PdfButon> {
  @override
  Widget build(BuildContext context) {
    if (_cafe.cafeAyar!.isStaticMenu == null) {
      _cafe.cafeAyar!.isStaticMenu = false;
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: (_height / 10)),
          child: Text(
            _pdfButonstr(_cafe.cafeAyar!.isPdf!),
            style: TextStyle(
              color: Colors.green.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: (_height / 20)),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  fixedSize: Size((_width * 0.6), (_height / 15)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                if (_cafe.cafeAyar!.isPdf == true) {
                  _cafe.cafeAyar!.isPdf = false;
                } else {
                  _cafe.cafeAyar!.isPdf = true;
                }

                _sendRefAyar(context);
              },
              child: const Text("DEGİŞTİR")),
        ),
      ],
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
            primary: Colors.red,
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
  _cafe.tokens = tok;

  _cafe.istekTip = 'ayar_ref';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataCafeAyar(json, channel, context);
}
