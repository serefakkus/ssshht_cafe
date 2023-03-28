// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ssshht_cafe/personel/helpers/sqldatabase.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../main.dart';
import '../../model/masa_cagri.dart';
import '../../model/personel.dart';

late WebSocketChannel masaCagriChannel;
bool _isConnOk = false;
bool _isFirst = true;
bool _isFirstTumMasa = true;
bool _isChannelOpen = false;
bool _isFirstListen = true;
List<Masa>? _tumMasalar = [];
List<Masa>? _bagliMasalar = [];
List<Masa>? _bekleyenMasalar = [];

Personel _cafe = Personel();
MasaPersonel _masaPersonel = MasaPersonel();

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

class PersonelMasaCagriPage extends StatefulWidget {
  const PersonelMasaCagriPage({super.key});

  @override
  State<PersonelMasaCagriPage> createState() => _PersonelMasaCagriPageState();
}

class _PersonelMasaCagriPageState extends State<PersonelMasaCagriPage> {
  @override
  void initState() {
    _isFirst = true;
    _isFirstTumMasa = true;
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Personel;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return const CagriMasalar();
  }
}

class CagriMasalar extends StatefulWidget {
  const CagriMasalar({super.key});

  @override
  State<CagriMasalar> createState() => _CagriMasalarState();
}

class _CagriMasalarState extends State<CagriMasalar> {
  @override
  Widget build(BuildContext context) {
    _connMasaCagri(context, _setS, _cafe);
    if (!_isConnOk) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          BekleyenMasaInfo(),
          Flexible(child: BekleyenMasaBody()),
          TumMasaInfo(),
          Flexible(child: TumMasaBody()),
        ],
      ),
    );
  }

  _setS() {
    setState(() {});
  }
}

_connMasaCagri(BuildContext context, Function setS, Personel cafe) async {
  await _sendMasaCagri(context, cafe);
  // ignore: use_build_context_synchronously
  _listenCagri(context, cafe, setS);
}

_sendMasaCagri(BuildContext context, Personel cafe) async {
  if (!_isFirst) {
    return;
  }

  _isFirst = false;
  MasaPersonel personel = MasaPersonel();
  MasaTokens masaTokens = MasaTokens();

  masaTokens.tokenDetails = await getMasaToken(context, _cafe);
  masaCagriChannel = IOWebSocketChannel.connect(urlPersonelCagri);

  if (masaTokens.tokenDetails == null) {
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/PersonelHomePage', arguments: cafe);
    return;
  }
  if (masaTokens.tokenDetails!.accessToken == '' ||
      masaTokens.tokenDetails!.accessToken == null) {
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/PersonelHomePage', arguments: cafe);
    return;
  }

  masaTokens.auth = masaTokens.tokenDetails!.accessToken;
  personel.masaToken = masaTokens;

  personel.istekType = 'add';

  var json = jsonEncode(personel.toJson());

  masaCagriChannel.sink.add(json);

  _isChannelOpen = true;
}

_listenCagri(BuildContext context, Personel cafe, Function setS) async {
  if (!_isChannelOpen) {
    await Future.delayed(const Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    _listenCagri(context, cafe, setS);
    return;
  }

  if (!_isFirstListen) {
    return;
  }
  _isFirstListen = false;
  masaCagriChannel.stream.listen(
    (data) {
      var jsonobject = jsonDecode(data);

      _masaPersonel = MasaPersonel.fromJson(jsonobject);

      if (_masaPersonel.status == true) {
        if (_isFirstTumMasa) {
          _tumMasalar = _masaPersonel.allMasa;
          _siralaMasa(setS);
          if (_tumMasalar != null) {
            _isFirstTumMasa = false;
          }
          _bagliMasalar = _masaPersonel.bagliMasa;
          if (_bagliMasalar != null) {}

          _bekleyenMasalar = _masaPersonel.bekleyenMasa;
          if (_bekleyenMasalar != null) {}
        }

        switch (_masaPersonel.message) {
          case 'cagri':
            _bekleyenMasalar ??= [];
            bool ok = false;

            for (var i = 0; i < _bekleyenMasalar!.length; i++) {
              if (_bekleyenMasalar![i].masaNo == _masaPersonel.masa!.masaNo) {
                ok = true;
              }
            }

            if (!ok) {
              _bekleyenMasalar!.add(_masaPersonel.masa!);
            }

            break;

          case 'conn_masa':
            _bagliMasalar ??= [];
            _bagliMasalar!.add(_masaPersonel.masa!);

            break;

          case 'disconn_masa':
            int? index;
            if (_bagliMasalar != null) {
              if (_bagliMasalar!.isNotEmpty && _masaPersonel.masa != null) {
                for (var i = 0; i < _bagliMasalar!.length; i++) {
                  if (_bagliMasalar![i].masaNo == _masaPersonel.masa!.masaNo) {
                    index = i;
                  }
                }
              }
            }

            if (index != null) {
              _bagliMasalar!.removeAt(index);
            }

            break;

          case 'del_bekleyen':
            int? index;
            if (_bekleyenMasalar != null) {
              if (_bekleyenMasalar!.isNotEmpty && _masaPersonel.masa != null) {
                for (var i = 0; i < _bekleyenMasalar!.length; i++) {
                  if (_bekleyenMasalar![i].masaNo ==
                      _masaPersonel.masa!.masaNo) {
                    index = i;
                  }
                }
              }
            }

            if (index != null) {
              _bekleyenMasalar!.removeAt(index);
            } else {}

            break;

          default:
        }

        if (_masaPersonel.istekType == 'del_bekleyen') {}

        _isConnOk = true;
        setS();
      } else if (_masaPersonel.status != true) {
        EasyLoading.showToast('BİR HATA OLUŞTU TEKRAR DENEYİN!',
            duration: const Duration(seconds: 10));
      }
    },
  );
}

class TumMasaBody extends StatelessWidget {
  const TumMasaBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: (_width / 1.3),
      child: Column(
        children: [Flexible(child: TumMasalar())],
      ),
    );
  }
}

class TumMasaInfo extends StatelessWidget {
  const TumMasaInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'TÜM MASALAR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _height / 30,
            color: Colors.blueAccent,
          ),
        ),
        const ListTile(
          leading: Text(
            'MASA',
            style: TextStyle(fontSize: 20),
          ),
          trailing: Text(
            'AKTİF',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}

class TumMasalar extends StatefulWidget {
  const TumMasalar({Key? key}) : super(key: key);

  @override
  State<TumMasalar> createState() => _TumMasalarState();
}

class _TumMasalarState extends State<TumMasalar> {
  @override
  Widget build(BuildContext context) {
    if (_tumMasalar == null) {
      return Container(
        alignment: Alignment.center,
        child: const Text('HİÇ MASA YOK'),
      );
    }
    if (_tumMasalar!.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text('HİÇ MASA YOK'),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: _tumMasalar!.length,
        itemBuilder: (context, index) {
          var masalar = _tumMasalar![index];
          String aktif = _isMasaAktif(masalar.masaNo);
          Color renk = _aktifRenkSec(aktif);

          return GestureDetector(
            child: SizedBox(
              height: (_height / 12),
              child: Card(
                color: renk,
                child: ListTile(
                  leading: Text(
                    _masaNameGet(masalar.masaNo, masalar.masaName),
                    style: const TextStyle(fontSize: 20),
                  ),
                  trailing: Text(
                    aktif,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}

class BekleyenMasaBody extends StatelessWidget {
  const BekleyenMasaBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: (_width / 1.3),
      child: Column(
        children: [Flexible(child: BekleyenMasalar())],
      ),
    );
  }
}

class BekleyenMasaInfo extends StatelessWidget {
  const BekleyenMasaInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: _height / 20),
      child: Column(
        children: [
          Text(
            'BEKLEYEN MASALAR',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _height / 30,
              color: Colors.blueAccent,
            ),
          ),
          const ListTile(
            leading: Text(
              'MASA',
              style: TextStyle(fontSize: 20),
            ),
            trailing: Text(
              'AKTİF',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class BekleyenMasalar extends StatefulWidget {
  const BekleyenMasalar({Key? key}) : super(key: key);

  @override
  State<BekleyenMasalar> createState() => _BekleyenMasalarState();
}

class _BekleyenMasalarState extends State<BekleyenMasalar> {
  @override
  Widget build(BuildContext context) {
    if (_bekleyenMasalar == null) {
      return Container(
        alignment: Alignment.center,
        child: const Text('HİÇ BEKLEYEN MASA YOK'),
      );
    }
    if (_bekleyenMasalar!.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: const Text('HİÇ BEKLEYEN MASA YOK'),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: _bekleyenMasalar!.length,
        itemBuilder: (context, index) {
          var masalar = _bekleyenMasalar![index];

          String aktif = _isMasaAktif(masalar.masaNo);
          Color renk = _aktifRenkSec(aktif);

          return GestureDetector(
            child: SizedBox(
              height: (_height / 12),
              child: Card(
                color: renk,
                child: ListTile(
                  leading: Text(
                    _masaNameGet(masalar.masaNo, masalar.masaName),
                    style: const TextStyle(fontSize: 15),
                  ),
                  trailing: Text(
                    aktif,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CagriSilOnayButon(masalar.masaNo!),
                          CagriSilRedButon(),
                        ],
                      )
                    ],
                    content: const Text(
                        'Bekleyen masayi silmek istediğine eminmisin ?'),
                  );
                },
              );
            },
          );
        },
      );
    }
  }
}

String _masaNameGet(String? masaNo, String? masaName) {
  if (_tumMasalar == null) {
    EasyLoading.showToast('Masa isimlerí getirilemedi !');
    return '';
  }

  if (masaName == null || masaName == '') {
    return masaNo.toString();
  }

  return masaName;
}

_siralaMasa(Function setS) {
  if (_tumMasalar == null) {
    return;
  }
  List<MasaForShort> masalar = [];

  for (var i = 0; i < _tumMasalar!.length; i++) {
    MasaForShort masaForShort = MasaForShort();
    masaForShort.masaName = _tumMasalar![i].masaName;
    masaForShort.masaNo = _tumMasalar![i].masaNo;
    int? sayi = int.tryParse(_tumMasalar![i].masaNo!);
    masaForShort.sira = sayi;
    masalar.add(masaForShort);
  }

  masalar.sort((a, b) => a.sira!.compareTo(b.sira!));

  List<Masa> siraliMasa = [];

  for (var i = 0; i < masalar.length; i++) {
    Masa masa = Masa();
    masa.masaName = masalar[i].masaName;
    masa.masaNo = masalar[i].masaNo;
    siraliMasa.add(masa);
  }
  _tumMasalar = siraliMasa;
}

String _isMasaAktif(String? masaNo) {
  String sonuc = 'AKTİF DEGİL';
  if (masaNo != null && _bagliMasalar != null) {
    for (var i = 0; i < _bagliMasalar!.length; i++) {
      if (_bagliMasalar![i].masaNo == masaNo) {
        sonuc = 'AKTİF';
      }
    }
  }
  return sonuc;
}

Color _aktifRenkSec(String? aktif) {
  if (aktif == 'AKTİF') {
    return Colors.green;
  }
  return Colors.red;
}

// ignore: must_be_immutable
class CagriSilOnayButon extends StatelessWidget {
  CagriSilOnayButon(this.masaNo, {super.key});
  String masaNo;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        elevation: 10,
        fixedSize: Size(
          (_width / 3),
          (_height / 15),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: const Text('ONAY'),
      onPressed: () {
        Navigator.pop(context);
        _sendDelCagri(context, _cafe, masaNo);
      },
    );
  }
}

class CagriSilRedButon extends StatelessWidget {
  const CagriSilRedButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        elevation: 10,
        fixedSize: Size(
          (_width / 3),
          (_height / 15),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: const Text('VAZGEÇ'),
      onPressed: () async {
        Navigator.pop(context);
      },
    );
  }
}

_sendDelCagri(BuildContext context, Personel cafe, String masaNo) async {
  MasaPersonel personel = MasaPersonel();
  MasaTokens masaTokens = MasaTokens();

  masaTokens.tokenDetails = await getMasaToken(context, _cafe);

  if (masaTokens.tokenDetails == null) {
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/PersonelHomePage', arguments: cafe);
    return;
  }
  if (masaTokens.tokenDetails!.accessToken == '' ||
      masaTokens.tokenDetails!.accessToken == null) {
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/PersonelHomePage', arguments: cafe);
    return;
  }

  masaTokens.auth = masaTokens.tokenDetails!.accessToken;
  personel.masaToken = masaTokens;

  personel.istekType = 'del_bekleyen';
  Masa masa = Masa();
  masa.masaNo = masaNo;
  personel.masa = masa;

  var json = jsonEncode(personel.toJson());

  masaCagriChannel.sink.add(json);
}
