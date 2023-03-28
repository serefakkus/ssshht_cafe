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

int _index = -1;
Cafe _cafe = Cafe();
List<String> _yetkiname = [
  'MENÜ DÜZENLE',
  'MASA DÜZENLE',
  'REZERVASYON DÜZENLE',
  'CAFE AYAR DÜZENLE',
  'HESAP AL'
];
List<bool> _auth = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];
Pers _pers = Pers();

class CafePersonelDetayPage extends StatefulWidget {
  const CafePersonelDetayPage({Key? key}) : super(key: key);

  @override
  State<CafePersonelDetayPage> createState() => _CafePersonelDetayPageState();
}

class _CafePersonelDetayPageState extends State<CafePersonelDetayPage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> _gelen = [];
    int _persid = -1;
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _persid = _gelen[1];

    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    for (var i = 0; i < _cafe.personelAyar!.pers!.length; i++) {
      if (_persid == _cafe.personelAyar!.pers![i].persId) {
        _index = i;
      }
    }
    if (_cafe.personelAyar?.pers != null) {
      if (_cafe.personelAyar!.pers!.length > _index && _index >= 0) {
        _pers = _cafe.personelAyar!.pers![_index];
        if (_cafe.personelAyar!.pers![_index].persAuth == null) {
          _cafe.personelAyar!.pers![_index].persAuth = _auth;
        }
      }
    }

    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PersonelSil(),
        ],
      ),
      body: Column(
        children: [
          PersonelAppBar(),
          PersonelDetayInfo(),
          Flexible(child: PersonelDetayList())
        ],
      ),
    );
  }
}

class PersonelAppBar extends StatelessWidget {
  const PersonelAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (_height / 6),
        width: _width,
        child: Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: (_width / 20)),
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
              CafeImg(),
            ],
          ),
          color: Colors.blueGrey.shade700,
        ));
  }
}

class CafeImg extends StatelessWidget {
  const CafeImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: (_width / 6), right: (_width / 20)),
      child: SizedBox(
        height: (_height / 8),
        width: (_width / 3),
        child: CircleAvatar(
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: (_width / 10),
            child: Text(
              'QRCAFE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class PersonelDetayInfo extends StatelessWidget {
  const PersonelDetayInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: (_height / 50)),
      child: SizedBox(
        height: (_height / 10),
        width: _width,
        child: Card(
          color: Colors.grey.shade700,
          child: ListTile(
            title: Container(
              margin: EdgeInsets.only(top: (_height / 60)),
              child: Text(
                _name.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

var _status = false;
String _name = _cafe.personelAyar!.pers![_index].name!;

class PersonelDetayList extends StatefulWidget {
  const PersonelDetayList({Key? key}) : super(key: key);

  @override
  State<PersonelDetayList> createState() => _PersonelDetayListState();
}

class _PersonelDetayListState extends State<PersonelDetayList> {
  @override
  Widget build(BuildContext context) {
    if (_cafe.personelAyar!.pers!.length > _index) {
      _name = _cafe.personelAyar!.pers![_index].name!;
    }
    return ListView.builder(
      padding: EdgeInsets.all(0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return SizedBox(
          height: (_height / 10),
          child: Card(
              color: Colors.grey,
              child: ListTile(
                leading: Container(
                  margin: EdgeInsets.only(top: (_height / 50)),
                  child: Text(
                    _yetkiname[index] + ' : ',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                trailing: Container(
                  margin: EdgeInsets.only(top: (_height / 100)),
                  child: IconButton(
                    icon: _isyetkitrue(_pers.persAuth![index]),
                    onPressed: () {
                      if (_pers.persAuth![index]) {
                        _pers.persAuth![index] = false;
                      } else {
                        _pers.persAuth![index] = true;
                      }
                      _cafe.personelAyar!.pers![_index] = _pers;

                      _sendRefPers(context);
                    },
                  ),
                ),
              )),
        );
      },
    );
  }
}

class PersonelSil extends StatelessWidget {
  const PersonelSil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (_width / 1.8),
      child: Container(
        margin: EdgeInsets.only(bottom: (_height / 20)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.red,
              elevation: 10,
              fixedSize: Size((_width * 0.6), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          child: Text('PERSONEL SİL'),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('BU PERSONEL SİLİNECEK EMİNMİSİNİZ'),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        for (var i = 0;
                            i < _cafe.personelAyar!.pers!.length;
                            i++) {
                          if (_cafe.personelAyar!.pers![i].persId ==
                              _pers.persId) {
                            _cafe.personelAyar!.pers!.removeAt(i);
                          }
                        }
                        Puan puan = Puan();
                        puan.musteriId = _pers.persId;
                        _cafe.puan = puan;
                        _sendRefPersdel(context);
                      },
                      child: Text('ONAYLA'),
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          fixedSize: Size((_width * 0.8), (_height / 15)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('VAZGEÇ'),
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          fixedSize: Size((_width * 0.8), (_height / 15)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

_isyetkitrue(bool yetki) {
  if (yetki == true) {
    return Icon(
      Icons.check_box,
      size: 40,
    );
  } else {
    return Icon(
      Icons.indeterminate_check_box,
      size: 40,
    );
  }
}

_sendRefPers(BuildContext context) async {
  var _tok = Tokens();
  _tok.tokenDetails = await getToken(context);
  _cafe.tokens = _tok;

  _cafe.istekTip = 'pers_ref';

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  sendDataRefPers(json, _channel, context, _index);
}

_sendRefPersdel(BuildContext context) async {
  var _tok = Tokens();
  _tok.tokenDetails = await getToken(context);
  _cafe.tokens = _tok;

  _cafe.istekTip = 'pers_ref';

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  sendDataRefPersdel(json, _channel, context);
}
