import 'dart:convert';

import 'package:flutter/material.dart';

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
Siparis _siparis = Siparis();

class PersonelSiparisDetayPage extends StatefulWidget {
  const PersonelSiparisDetayPage({Key? key}) : super(key: key);

  @override
  State<PersonelSiparisDetayPage> createState() =>
      _PersonelSiparisDetayPageState();
}

class _PersonelSiparisDetayPageState extends State<PersonelSiparisDetayPage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> _gelen = [];
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _siparis = _gelen[1];
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Container(
      child: Column(
        children: [
          SizedBox(
            //height: (_height / 5),
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
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: (_width / 20)),
            child: IconButton(
              icon: Icon(
                Icons.backspace,
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
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(_siparis.masaNo.toString(),
                    style:
                        TextStyle(fontSize: 20, color: Colors.grey.shade800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              'İSİM',
              style: TextStyle(fontSize: 16),
            ),
            margin: EdgeInsets.only(left: (_width / 20)),
          ),
          Text('ADET', style: TextStyle(fontSize: 16)),
          Container(
            child: Text('NOT', style: TextStyle(fontSize: 16)),
            margin: EdgeInsets.only(right: (_width / 20)),
          )
        ],
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
      _sayac = 1;
    } else {
      _sayac = _siparis.urun!.length + 1;
    }
    return ListView.builder(
      itemCount: _sayac,
      itemBuilder: (context, index) {
        if (index == _sayac - 1) {
          return Container(
            margin: EdgeInsets.only(top: (_height / 15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
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
                                  Navigator.pushNamed(context, '/Iptal');
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
                          borderRadius: BorderRadius.circular(50))),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_siparis.hazirlayanId != null &&
                        _siparis.hazirlayanId != 0) {
                      _cafe.siparis = _siparis;
                      _sendSiparis(context, 1);
                    } else {
                      _cafe.siparis = _siparis;
                      _sendSiparis(context, 2);
                    }
                  },
                  child: Text('onay'),
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      fixedSize: Size((_width * 0.4), (_height / 15)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                )
              ],
            ),
          );
        } else {
          return SizedBox(
            height: (_height / 15),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_siparis.urun![index].name.toString()),
                  Text(_siparis.urun![index].adet.toString()),
                  _isNot(_siparis.urun![index].not, context, index),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

_isNot(String? text, BuildContext context, int index) {
  if (text == null || text == '') {
    return Container();
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

class PersonelIptal extends StatefulWidget {
  const PersonelIptal({Key? key}) : super(key: key);

  @override
  State<PersonelIptal> createState() => _PersonelIptalState();
}

class _PersonelIptalState extends State<PersonelIptal> {
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
  _cafe.token = _tok;
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

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(_cafe.toMap());

  sendDataSiparisRef(json, _channel, context);
}
