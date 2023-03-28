import 'package:flutter/material.dart';

import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

TextEditingController _nakit = TextEditingController();
TextEditingController _kart = TextEditingController();
Personel _cafe = Personel();
List<dynamic> _gelen = [];
Siparis _siparis = Siparis();
double _toplam = 0;

class PersonelOdemePage extends StatefulWidget {
  const PersonelOdemePage({Key? key}) : super(key: key);

  @override
  State<PersonelOdemePage> createState() => _PersonelOdemePageState();
}

class _PersonelOdemePageState extends State<PersonelOdemePage> {
  @override
  Widget build(BuildContext context) {
    _gelen = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    _cafe = _gelen[0];
    _siparis = _gelen[1];
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Container(
      color: Colors.yellow.shade300,
      child: Column(
        children: [
          HesapAppBar(),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            child: Container(
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Tutar(), OdemeButon()],
                  )
                ],
              ),
            ),
          )
        ],
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
              CafeImg()
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

class Tutar extends StatefulWidget {
  const Tutar({Key? key}) : super(key: key);

  @override
  State<Tutar> createState() => _TutarState();
}

class _TutarState extends State<Tutar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kart.text = '1.5';
    _nakit.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    double _hesaptoplam = 0;
    if (_siparis.urun != null) {
      for (var i = 0; i < _siparis.urun!.length; i++) {
        if (_siparis.urun![i].tl != null) {
          _hesaptoplam = _hesaptoplam + _siparis.urun![i].tl!;
        }
      }
    }

    double _toplam = _gethesap(_nakit.text) + _gethesap(_kart.text);
    return Column(
      children: [
        Card(
          margin: EdgeInsets.only(top: (_height / 15)),
          child: SizedBox(
            height: (_height / 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('HESAP'),
                Container(
                  margin: EdgeInsets.only(right: (_width / 30)),
                  child: SizedBox(
                    width: (_width / 5),
                    child: Flexible(
                        child: Text(
                      _hesaptoplam.toString(),
                      textAlign: TextAlign.center,
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('NAKİT'),
              Container(
                margin: EdgeInsets.only(right: (_width / 30)),
                child: SizedBox(
                  width: (_width / 5),
                  child: Flexible(
                      child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    textInputAction: TextInputAction.go,
                    controller: _nakit,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.blue.shade50),
                    onChanged: (value) {
                      _kart.text =
                          (_toplam - _gethesap(_nakit.text)).toString();
                    },
                  )),
                ),
              )
            ],
          ),
        ),
        Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('KART'),
              Container(
                margin: EdgeInsets.only(right: (_width / 30)),
                child: SizedBox(
                  width: (_width / 5),
                  child: Flexible(
                      child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    textInputAction: TextInputAction.go,
                    controller: _kart,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.blue.shade50),
                    onChanged: (value) {
                      _nakit.text =
                          (_toplam - _gethesap(_kart.text)).toString();
                    },
                  )),
                ),
              )
            ],
          ),
        ),
        Card(
          child: SizedBox(
            height: (_height / 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('TOPLAM'),
                Container(
                  margin: EdgeInsets.only(right: (_width / 30)),
                  child: SizedBox(
                    width: (_width / 5),
                    child: Flexible(
                        child: Text(_toplam.toString(),
                            textAlign: TextAlign.center)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

double _gethesap(String text) {
  for (var i = 0; i < text.length; i++) {
    if (text[i] == ',') {
      var a = text.substring(0, i);
      text = a + '.' + text.substring(i + 1, text.length);
    }
  }
  return double.parse(text);
}

class OdemeButon extends StatelessWidget {
  const OdemeButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          //height: (_height / 20),
          width: (_width / 2),
          child: Container(
            margin: EdgeInsets.only(top: (_height / 3.25)),
            child: ElevatedButton(
              child: Text('ÖDEME'),
              onPressed: () {
                debugPrint(_kart.text.toString());
                debugPrint(_nakit.text.toString());
              },
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  fixedSize: Size((_width * 0.8), (_height / 15)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          ),
        ),
        SizedBox(
          height: (_height / 20),
          child: Container(
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
