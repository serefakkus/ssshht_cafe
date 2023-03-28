import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musterimodel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Cafe _cafe = Cafe();
List<String> _masalar = [];
Siparis _siparis = Siparis();
String _hint = 'MASA SEÇ';
bool _masasec = false;

class CafeHesapPage extends StatefulWidget {
  const CafeHesapPage({Key? key}) : super(key: key);

  @override
  State<CafeHesapPage> createState() => _CafeHesapPageState();
}

class _CafeHesapPageState extends State<CafeHesapPage> {
  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    List<String> masalist = [];

    if (_cafe.siparisSor != null && _cafe.siparisSor?.aktif != null) {
      for (var i = 0; i < _cafe.siparisSor!.aktif!.length; i++) {
        masalist.add(_cafe.siparisSor!.aktif![i].masaNo.toString());
      }
      _masalar = masalist;
    } else {
      _masalar = masalist;
    }
    return Column(
      children: [
        const HesapAppBar(),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/backgroud.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SizedBox(
            width: (_width),
            height: (_height / 1.2),
            child: Column(
              children: [
                SizedBox(
                  height: (_height / 7),
                  child: Column(
                    children: [
                      SizedBox(
                        width: (_width / 3),
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(30),
                          menuMaxHeight: (_height / 1.3),
                          items: _masalar
                              .asMap()
                              .entries
                              .map((e) => DropdownMenuItem<String>(
                                  value: e.key.toString(),
                                  child: Text(e.value)))
                              .toList(),
                          hint: Center(
                            child: Text(
                              _hint,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          onChanged: (value) {
                            _hint = _masalar[int.parse(value!)];

                            _masasec = true;

                            _siparis =
                                _cafe.siparisSor!.aktif![int.parse(value)];
                            setState(() {});
                          },
                        ),
                      ),
                      const HesapBaslik(),
                    ],
                  ),
                ),
                const Flexible(child: HesapBody()),
                const OdemeButon()
              ],
            ),
          ),
        )
      ],
    );
  }
}

class HesapBaslik extends StatelessWidget {
  const HesapBaslik({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: (_width / 7)),
            child: const Text(
              'İÇERİK',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const Text(
            'ADET',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            margin: EdgeInsets.only(right: (_width / 7)),
            child: const Text(
              'FİYAT',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
        ],
      ),
    );
  }
}

class HesapBody extends StatefulWidget {
  const HesapBody({Key? key}) : super(key: key);

  @override
  State<HesapBody> createState() => _HesapBodyState();
}

class _HesapBodyState extends State<HesapBody> {
  @override
  Widget build(BuildContext context) {
    int sayac = 0;
    if (_siparis.urun != null) {
      sayac = _siparis.urun!.length;
    }

    sayac = sayac + 1;
    if (_masalar.isEmpty) {
      sayac++;
    }

    return ListView.builder(
      itemExtent: (_height / 15),
      itemCount: sayac,
      itemBuilder: (context, index) {
        if (index == sayac - 1) {
          return const Tutar();
        } else if (_masalar.isEmpty) {
          return SizedBox(
              height: (_height / 15),
              child: Container(
                alignment: Alignment.center,
                child: const Text(
                  'HİÇ SİPARİŞ YOK',
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ));
        } else {
          return Card(
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: (_width / 8)),
                  child: Text(
                    _siparis.urun![index].name.toString(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ),
                Text(
                  _siparis.urun![index].adet.toString(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
                Container(
                  margin: EdgeInsets.only(right: (_width / 8)),
                  child: Text(
                    _siparis.urun![index].tl.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}

class Tutar extends StatefulWidget {
  const Tutar({Key? key}) : super(key: key);

  @override
  State<Tutar> createState() => _TutarState();
}

class _TutarState extends State<Tutar> {
  @override
  Widget build(BuildContext context) {
    double tutar = 0;
    if (_siparis.urun != null) {
      for (var i = 0; i < _siparis.urun!.length; i++) {
        if (_siparis.urun![i].tl != null) {
          tutar = tutar + _siparis.urun![i].tl!;
        } else {
          debugPrint('tl bos');
        }
      }
    }

    return Container(
      margin: EdgeInsets.only(left: (_width / 1.6), top: (_height / 50)),
      child: Text(
        'TUTAR : $tutar tl',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class OdemeButon extends StatelessWidget {
  const OdemeButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: (_height / 50)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.6), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        child: const Text('ÖDEME'),
        onPressed: () {
          if (_masasec) {
            _sendPuanSor(context, _cafe, _siparis);
          }
        },
      ),
    );
  }
}

class HesapAppBar extends StatelessWidget {
  const HesapAppBar({Key? key}) : super(key: key);

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
              const CafeImg()
            ],
          ),
          //color: Colors.yellow.shade100,
        ));
  }
}

class CafeImg extends StatelessWidget {
  const CafeImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: (_width / 6),
      ),
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

_sendPuanSor(BuildContext context, Cafe cafe, Siparis siparis) async {
  var tok = Tokens();
  tok.tokenDetails = await getToken(context);
  cafe.tokens = tok;
  var puan = Puan();
  puan.musteriId = siparis.musteriId;
  cafe.puan = puan;
  cafe.istekTip = 'puan_sor';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);

  var json = jsonEncode(cafe.toMap());

  channel.sink.add(json);
  channel.stream.listen((data) {
    var jsonobject = jsonDecode(data);
    Cafe cafe2 = Cafe();
    cafe2 = Cafe.fromMap(jsonobject);

    if (cafe2.status == true) {
      cafe.puan = cafe2.puan;
      var gelen = [cafe, siparis];
      Navigator.pushNamed(context, '/CafeOdemePage', arguments: gelen);
    } else if (cafe2.status == false) {
      var gelen = [cafe, siparis];
      Navigator.pushNamed(context, '/CafeOdemePage', arguments: gelen);
    } else {
      EasyLoading.showToast('BİR HATA OLUŞTU\nTEKRAR DENEYİNİZ');
    }

    channel.sink.close();
  });
}
