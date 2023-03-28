import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Personel _cafe = Personel();
List<String> _masalar = [];
Siparis _siparis = Siparis();
String _hint = 'MASA SEÇ';
bool _masasec = false;
bool _yetki = false;

class PersonelHesapPage extends StatefulWidget {
  const PersonelHesapPage({Key? key}) : super(key: key);

  @override
  State<PersonelHesapPage> createState() => _PersonelHesapPageState();
}

class _PersonelHesapPageState extends State<PersonelHesapPage> {
  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Personel;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    if (_cafe.siparisSor != null && _cafe.siparisSor?.aktif != null) {
      for (var i = 0; i < _cafe.siparisSor!.aktif!.length; i++) {
        _masalar.add(_cafe.siparisSor!.aktif![i].masaNo.toString());
      }
    }
    if (_cafe.yetki != null) {
      _yetki = _cafe.yetki![4];
    }
    return Container(
      color: Colors.yellow.shade300,
      child: Column(
        children: [
          const HesapAppBar(),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            child: SizedBox(
              width: (_width),
              height: (_height / 1.2),
              child: Column(
                children: [
                  SizedBox(
                    height: (_height / 7),
                    child: Column(
                      children: [
                        Container(
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(30),
                            menuMaxHeight: (_height / 1.3),
                            items: _masalar
                                .map((masa) => DropdownMenuItem(
                                    child: Text(masa), value: masa))
                                .toList(),
                            hint: Text(_hint),
                            onChanged: (value) {
                              debugPrint(value);
                              _hint = value.toString();
                              for (var i = 0;
                                  i < _cafe.siparisSor!.aktif!.length;
                                  i++) {
                                if (_cafe.siparisSor!.aktif![i].masaNo ==
                                    value) {
                                  _masasec = true;

                                  _siparis = _cafe.siparisSor!.aktif![i];
                                }
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        const HesapBaslik(),
                      ],
                    ),
                  ),
                  Flexible(child: HesapBody()),
                ],
              ),
            ),
          )
        ],
      ),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
    int _sayac = 0;
    if (_siparis.urun != null) {
      _sayac = _siparis.urun!.length;
    }

    _sayac = _sayac + 2;
    if (_masalar.length == 0) {
      _sayac++;
    }

    return Container(
      child: ListView.builder(
        itemExtent: (_height / 15),
        itemCount: _sayac,
        itemBuilder: (context, index) {
          if (index == _sayac - 1) {
            return const OdemeButon();
          } else if (index == _sayac - 2) {
            return Tutar();
          } else if (_masalar.length == 0) {
            return SizedBox(
                height: (_height / 15),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
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
                    child: Text(
                      _siparis.urun![index].name.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    margin: EdgeInsets.only(left: (_width / 8)),
                  ),
                  Container(
                    child: Text(
                      _siparis.urun![index].adet.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    child: Text(
                      _siparis.urun![index].tl.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    margin: EdgeInsets.only(right: (_width / 8)),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

double _tutar = 0;

class Tutar extends StatefulWidget {
  const Tutar({Key? key}) : super(key: key);

  @override
  State<Tutar> createState() => _TutarState();
}

class _TutarState extends State<Tutar> {
  @override
  Widget build(BuildContext context) {
    if (_siparis.urun != null) {
      for (var i = 0; i < _siparis.urun!.length; i++) {
        if (_siparis.urun![i].tl != null) {
          _tutar = _tutar + _siparis.urun![i].tl!;
        } else {
          debugPrint('tl bos');
        }
      }
    }

    return Container(
      margin: EdgeInsets.only(left: (_width / 1.6), top: (_height / 50)),
      child: Text(
        'TUTAR : ' + _tutar.toString() + ' tl',
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class OdemeButon extends StatelessWidget {
  const OdemeButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: (_width / 1.5), right: (_width / 15), bottom: (_height / 50)),
      child: ElevatedButton(
        child: const Text('ÖDEME'),
        onPressed: () {
          if (_yetki == true) {
            if (_masasec) {
              var _gelen = [_cafe, _siparis];
              Navigator.pushNamed(context, '/OdemePage', arguments: _gelen);
            }
          } else {
            EasyLoading.showToast('YETKİNİZ YOK');
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
