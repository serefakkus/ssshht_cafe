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

class CafePersonelPage extends StatefulWidget {
  const CafePersonelPage({Key? key}) : super(key: key);

  @override
  State<CafePersonelPage> createState() => _CafePersonelPageState();
}

class _CafePersonelPageState extends State<CafePersonelPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    if (_cafe.personelAyar != null && _cafe.personelAyar?.pers != null) {
      var ok = false;
      for (var i = 0; i < _cafe.personelAyar!.pers!.length; i++) {
        for (var c = 0; c < _cafe.personelAyar!.pers!.length; c++) {
          if (c != i) {
            if (_cafe.personelAyar!.pers![i].persId ==
                _cafe.personelAyar!.pers![c].persId) {
              _cafe.personelAyar!.pers!.removeAt(c);
              ok = true;
            }
          }
        }
      }
      if (ok == true) {
        _sendRefPers(context);
      }
    }
    return Column(
      children: const [PersonelAppBar(), Flexible(child: PersonelBody())],
    );
  }
}

class PersonelPageInfo extends StatelessWidget {
  const PersonelPageInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (_height / 10),
      width: _width,
      child: Card(
        color: Colors.blueGrey,
        child: Container(
          margin: EdgeInsets.only(top: (_height / 40)),
          child: const Text(
            'İSİM',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
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
          color: Colors.blueGrey.shade700,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: (_width / 20)),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const CafeImg(),
              Container(
                margin: EdgeInsets.only(left: (_width / 40)),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: (_height / 30),
                  child: IconButton(
                      //color: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, '/CafeNewPersonelPage',
                            arguments: _cafe);
                      },
                      icon: Icon(
                        Icons.add,
                        size: (_height / 25),
                        color: Colors.blueGrey.shade700,
                      )),
                ),
              )
            ],
          ),
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
            child: const Text(
              'QRCAFE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class PersonelBody extends StatelessWidget {
  const PersonelBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backgroud.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: const [
            PersonelPageInfo(),
            Flexible(child: PersonelList()),
          ],
        ));
  }
}

class PersonelList extends StatefulWidget {
  const PersonelList({Key? key}) : super(key: key);

  @override
  State<PersonelList> createState() => _PersonelListState();
}

class _PersonelListState extends State<PersonelList> {
  int _sayac = 0;
  @override
  Widget build(BuildContext context) {
    bool isnull = true;
    if (_cafe.personelAyar == null || _cafe.personelAyar?.pers == null) {
      _sayac = 1;
    } else {
      isnull = false;
      _sayac = _cafe.personelAyar!.pers!.length;
    }
    if (isnull == true) {
      return Container(
        alignment: Alignment.center,
        child: const Text('HİÇ PERSONEL YOK'),
      );
    } else {
      return ListView.builder(
        itemCount: _sayac,
        itemBuilder: (context, index) {
          {
            var pers = _cafe.personelAyar!.pers![index];
            return GestureDetector(
              child: SizedBox(
                height: (_height / 12),
                child: Card(
                  color: Colors.grey,
                  child: Container(
                      margin: EdgeInsets.only(top: (_width / 25)),
                      child: Text(
                        pers.name.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      )),
                ),
              ),
              onTap: () {
                List<dynamic> gelen = [];
                gelen.add(_cafe);
                gelen.add(pers.persId);

                Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/CafePersonelDetayPage',
                    (route) => route.settings.name == '/CafePersonelPage',
                    arguments: gelen);
              },
            );
          }
        },
      );
    }
  }
}

_sendRefPers(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  _cafe.tokens = tok;

  _cafe.istekTip = 'pers_ref';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataRefPersdel(json, channel, context);
}
