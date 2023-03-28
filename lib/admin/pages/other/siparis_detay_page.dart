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
Siparis _siparis = Siparis();

class CafeSiparisDetayPage extends StatefulWidget {
  const CafeSiparisDetayPage({Key? key}) : super(key: key);

  @override
  State<CafeSiparisDetayPage> createState() => _CafeSiparisDetayPageState();
}

class _CafeSiparisDetayPageState extends State<CafeSiparisDetayPage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> _gelen = [];
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _siparis = _gelen[1];
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: (_height / 50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(left: (_width / 20)),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content:
                            Text('İPTAL ETMEK İSTEDİĞİNİZDEN\n EMİNMİSİNİZ'),
                        title: Text('İPTAL'),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/CafeIptal');
                              },
                              child: Text('onay')),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('vazgeç'))
                        ],
                      );
                    },
                  );
                },
                child: Text('iptal'),
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    fixedSize: Size((_width * 0.4), (_height / 15)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: (_width / 20)),
              child: ElevatedButton(
                onPressed: () {
                  if (_siparis.hazirlayanId == null ||
                      _siparis.hazirlayanId == 0) {
                    _siparis.hazirlayanId = _cafe.id;

                    _siparis.siparisId = _siparis.id;
                    _cafe.siparis = _siparis;

                    debugPrint(_siparis.id);
                    debugPrint(_siparis.siparisId);
                    _sendSiparis(context, 1);
                  } else {
                    _siparis.garsonId = _cafe.id;

                    _siparis.siparisId = _siparis.id;
                    _cafe.siparis = _siparis;

                    debugPrint(_siparis.id);
                    debugPrint(_siparis.siparisId);
                    _sendSiparis(context, 2);
                  }
                },
                child: Text('onay'),
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    fixedSize: Size((_width * 0.4), (_height / 15)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            //
            child: Container(
              child: Column(
                children: [
                  MasaNo(),
                  Info(),
                ],
              ),
            ),
          ),
          Flexible(child: SiparisList()),
        ],
      ),
    );
  }
}

class MasaNo extends StatelessWidget {
  const MasaNo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade700,
      child: SizedBox(
        height: (_height / 7),
        child: Container(
          margin: EdgeInsets.only(top: (_height / 20)),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: (_width / 20), bottom: (_height / 35)),
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
              Container(
                margin: EdgeInsets.only(left: (_width / 5)),
                child: Column(
                  children: [
                    Text(
                      'MASA NO',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(_siparis.masaNo.toString(),
                        style: TextStyle(fontSize: 20, color: Colors.black)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        margin: EdgeInsets.only(top: (_height / 20)),
        child: const Card(
          color: Colors.blueGrey,
          child: ListTile(
            leading: Text(
              'İSİM',
              style: TextStyle(fontSize: 16),
            ),
            title: Text(
              'ADET',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            trailing: Text('NOT', style: TextStyle(fontSize: 16)),
          ),
        ),
      ),
    );
  }
}

class SiparisList extends StatefulWidget {
  const SiparisList({Key? key}) : super(key: key);

  @override
  State<SiparisList> createState() => _SiparisListState();
}

class _SiparisListState extends State<SiparisList> {
  @override
  Widget build(BuildContext context) {
    int _sayac = 0;
    if (_siparis.urun == null) {
      _sayac = 0;
    } else {
      _sayac = _siparis.urun!.length;
    }
    return ListView.builder(
      itemCount: _sayac,
      itemBuilder: (context, index) {
        return SizedBox(
            height: (_height / 15),
            child: Card(
              color: Colors.grey.shade300,
              child: ListTile(
                leading: Text(_siparis.urun![index].name.toString()),
                title: Text(
                  _siparis.urun![index].adet.toString(),
                  textAlign: TextAlign.center,
                ),
                trailing: _isNot(_siparis.urun![index].not, context, index),
              ),
            ));
      },
    );
  }
}

_isNot(String? text, BuildContext context, int index) {
  debugPrint(text.toString());
  if (text == null || text == '' || text == ' ') {
    return Text(' ');
  } else {
    return CircleAvatar(
      child: IconButton(
        icon: Icon(Icons.check_box),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(_siparis.urun![index].not.toString()),
                title: Text('NOT'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('tamam'))
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class CafeIptal extends StatefulWidget {
  const CafeIptal({Key? key}) : super(key: key);

  @override
  State<CafeIptal> createState() => _CafeIptalState();
}

class _CafeIptalState extends State<CafeIptal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: (_height / 10)),
            child: Text(
              'İPTAL NOTU',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: (_height / 3),
            child: Container(
              margin: EdgeInsets.only(
                  top: (_height / 15),
                  left: (_width / 15),
                  right: (_width / 15)),
              child: TextField(
                maxLines: 10,
                controller: _iptalnot,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.blue.shade50),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: (_height / 8)),
            child: ElevatedButton(
              onPressed: () {
                _siparis.cafeNot = _iptalnot.text;
                _cafe.siparis = _siparis;
                _sendSiparis(context, 3);
              },
              child: Text('gönder'),
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  fixedSize: Size((_width * 0.8), (_height / 15)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          )
        ],
      ),
    );
  }
}

TextEditingController _iptalnot = TextEditingController();

_istherenot(bool ok) {
  if (ok) {
    return Icon(Icons.check_box);
  } else {
    return Container();
  }
}

_sendSiparis(BuildContext context, int tip) async {
  var _tok = Tokens();
  _tok.tokenDetails = await getToken(context);
  _cafe.tokens = _tok;
  if (tip == 1) {
    //onay
    _cafe.istekTip = 'siparis_onay';
  } else if (tip == 2) {
    //teslim
    _cafe.istekTip = 'siparis_teslim';
  } else {
    //iptal
    _cafe.istekTip = 'siparis_iptal';
  }

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  sendDataSiparisRef(json, _channel, context);
}
