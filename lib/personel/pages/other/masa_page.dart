import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Masalar _masalar = Masalar();
int _sayac = 0;
Personel _cafe = Personel();

class PersonelMasaPage extends StatefulWidget {
  const PersonelMasaPage({Key? key}) : super(key: key);

  @override
  State<PersonelMasaPage> createState() => _PersonelMasaPageState();
}

class _PersonelMasaPageState extends State<PersonelMasaPage> {
  @override
  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Personel;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    if (_cafe.masa == null || _cafe.masa?.masa == null) {
      _sayac = 0;
    } else {
      _sayac = _cafe.masa!.masa!.length;
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: const [
          SiparisAppBar(),
          MasaInfo(),
          Flexible(child: MasaBody())
        ],
      ),
    );
  }
}

class MasaInfo extends StatelessWidget {
  const MasaInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Text('MASA'),
      title: Text(
        'KAPASİTE',
        textAlign: TextAlign.center,
      ),
      trailing: Text('REZERVASYON'),
    );
  }
}

class MasaBody extends StatelessWidget {
  const MasaBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: (_width / 1.3),
      child: Column(
        children: const [Flexible(child: MasalarW())],
      ),
    );
  }
}

class MasalarW extends StatefulWidget {
  const MasalarW({Key? key}) : super(key: key);

  @override
  State<MasalarW> createState() => _MasalarWState();
}

class _MasalarWState extends State<MasalarW> {
  @override
  Widget build(BuildContext context) {
    if (_sayac == 0) {
      return Container(
        alignment: Alignment.center,
        child: const Text('HİÇ MASA YOK'),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: _sayac,
        itemBuilder: (context, index) {
          _masalar = _cafe.masa!.masa![index];

          return GestureDetector(
            child: SizedBox(
              height: (_height / 12),
              child: Card(
                color: _renk(_cafe.masa!.masa![index].rezerv),
                child: ListTile(
                  leading: Text(
                    _masaNameGet(_masalar.no.toString()),
                    style: const TextStyle(fontSize: 15),
                  ),
                  title: Text(
                    _masalar.cap.toString(),
                    textAlign: TextAlign.center,
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      debugPrint(_cafe.masa!.masa![index].rezerv.toString());
                      if (_cafe.masa!.masa![index].rezerv == true) {
                        _cafe.masa!.masa![index].rezerv = false;
                      } else {
                        _cafe.masa!.masa![index].rezerv = true;
                      }

                      _sendRefMasa(context, _cafe);
                    },
                    child: Text(
                      _rezervtext(_cafe.masa!.masa![index].rezerv),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    List<dynamic> gelen = [];
                    gelen.add(_cafe);
                    gelen.add(index);
                    Navigator.pushNamed(context, '/CafeMasaDetayPage',
                        arguments: gelen);
                  },
                ),
              ),
            ),
            onTap: () {
              List<dynamic> gelen = [];
              gelen.add(_cafe);
              gelen.add(index);
              Navigator.pushNamed(context, '/CafeMasaDetayPage',
                  arguments: gelen);
            },
          );
        },
      );
    }
  }
}

_renk(bool? ok) {
  if (ok == true) {
    return Colors.red;
  } else {
    return Colors.blueAccent;
  }
}

_rezervtext(bool? ok) {
  if (ok == true) {
    return 'REZERVE\n İPTAL';
  } else {
    return 'REZERVE\n ET';
  }
}

class SiparisAppBar extends StatelessWidget {
  const SiparisAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: (_height / 6),
        width: _width,
        child: Container(
          color: Colors.grey.shade700,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: (_width / 20)),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    size: 45,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const CafeImg()
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
      margin: EdgeInsets.only(left: (_width / 6), right: (_width / 25)),
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

_sendRefMasa(BuildContext context, Personel cafe) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  cafe.token = tok;

  cafe.istekTip = 'masa_ref';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);

  var json = jsonEncode(cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataRefMasa(json, channel, context);
}

String _masaNameGet(String masaNo) {
  if (_cafe.masaCode == null) {
    EasyLoading.showToast('Masa isimlerí getirilemedi !');
    return masaNo;
  }

  if (_cafe.masaCode!.masaNameS == null) {
    EasyLoading.showToast('Masa isimlerí getirilemedi !');
    return masaNo;
  }

  for (var i = 0; i < _cafe.masaCode!.masaNameS!.length; i++) {
    if (masaNo == _cafe.masaCode!.masaNameS![i].masaNo) {
      String? masaName;
      masaName = _cafe.masaCode!.masaNameS![i].masaName;
      if (masaName == null || masaName == '') {
        return masaNo;
      }
      return masaName;
    }
  }
  return masaNo;
}
