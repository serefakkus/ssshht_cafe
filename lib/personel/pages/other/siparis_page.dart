import 'package:flutter/material.dart';

import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Personel _cafe = Personel();
SiparisSor _siparisSor = SiparisSor();
Siparis _siparis = Siparis();

class PersonelSiparisPage extends StatefulWidget {
  const PersonelSiparisPage({Key? key}) : super(key: key);

  @override
  State<PersonelSiparisPage> createState() => _PersonelSiparisPageState();
}

class _PersonelSiparisPageState extends State<PersonelSiparisPage> {
  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Personel;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Container(
        child: Column(children: [
      SizedBox(
        child: SiparisAppBar(),
        height: (_height / 6),
      ),
      Container(
        child: SizedBox(
          child: Flexible(child: SiparisBody()),
          height: (_height / 1.2),
        ),
      )
    ]));
  }
}

class SiparisBody extends StatelessWidget {
  const SiparisBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: (_height / 20),
        ),
        Flexible(
          child: BekleyenSiparis(),
        ),
      ],
    );
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
              CafeImg()
            ],
          ),
          color: Colors.yellow.shade300,
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

class BekleyenSiparis extends StatefulWidget {
  const BekleyenSiparis({Key? key}) : super(key: key);

  @override
  State<BekleyenSiparis> createState() => _BekleyenSiparisState();
}

class _BekleyenSiparisState extends State<BekleyenSiparis> {
  @override
  Widget build(BuildContext context) {
    int _sayac = -1;
    int _aktifSayac = 0;
    int _bekleyenSayac = 0;
    int _telimSayac = 0;
    int _aktifAdet = 0;
    int _bekleyenAdet = 0;
    int _telimAdet = 0;
    bool _isaktifnull = false;
    bool _isbekleyennull = false;
    bool _istelimnull = false;
    List<Siparis> _bekleyenList = [];
    List<Siparis> _aktifList = [];
    List<Siparis> _teslimList = [];

    if (_cafe.siparisSor == null || (_cafe.siparisSor?.aktif == null)) {
      _sayac = 6;

      _aktifAdet = 1;
      _bekleyenAdet = 1;
      _telimAdet = 1;
      _istelimnull = true;
      _isbekleyennull = true;
      _isaktifnull = true;
    } else {
      for (var i = 0; i < _cafe.siparisSor!.aktif!.length; i++) {
        if (_cafe.siparisSor!.aktif![i].garsonId != null &&
            _cafe.siparisSor!.aktif![i].garsonId != 0) {
          debugPrint('1');
          _teslimList.add(_cafe.siparisSor!.aktif![i]);
        } else if (_cafe.siparisSor!.aktif![i].hazirlayanId != null &&
            _cafe.siparisSor!.aktif![i].hazirlayanId != 0) {
          debugPrint('2');
          _aktifList.add(_cafe.siparisSor!.aktif![i]);
        } else {
          debugPrint('3');
          _bekleyenList.add(_cafe.siparisSor!.aktif![i]);
        }
      }
      _aktifAdet = _aktifList.length;
      _bekleyenAdet = _bekleyenList.length;
      _telimAdet = _teslimList.length;

      _sayac = 3 + _aktifAdet + _bekleyenAdet + _telimAdet;
      if (_aktifAdet == 0) {
        _sayac++;
        _aktifAdet++;
        _isaktifnull = true;
      }

      if (_bekleyenAdet == 0) {
        _sayac++;

        _bekleyenAdet++;
        _isbekleyennull = true;
      }
      if (_telimAdet == 0) {
        _sayac++;
        _telimAdet++;
        _istelimnull = true;
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SizedBox(
            height: (_height / 10),
            child: Card(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'BEKLEYEN SİPARİŞ',
                  style: TextStyle(fontSize: (20)),
                ),
              ),
            ),
          );
        } else if (index == _bekleyenAdet + 1) {
          return SizedBox(
            height: (_height / 10),
            child: Card(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'AKTİF SİPARİŞ',
                  style: TextStyle(fontSize: (20)),
                ),
              ),
            ),
          );
        } else if (index == _bekleyenAdet + _aktifAdet + 2) {
          return SizedBox(
            height: (_height / 10),
            child: Card(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'TESLİLM EDİLMİŞ SİPARİŞ',
                  style: TextStyle(fontSize: (20)),
                ),
              ),
            ),
          );
        } else if (index < _aktifAdet + 1 && _isaktifnull) {
          return Container(
            height: (_height / 15),
            alignment: Alignment.center,
            child: Text('BEKLEYEN SİPARİŞ YOK'),
          );
        } else if (index < _aktifAdet + 1) {
          _bekleyenSayac++;
          return GestureDetector(
            child: SizedBox(
              height: (_height / 15),
              child: Card(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('MASA NO : ' +
                      _bekleyenList[_bekleyenSayac - 1].masaNo.toString()),
                ),
              ),
            ),
            onTap: () {
              List<dynamic> _gelen = [_cafe, _bekleyenList[_bekleyenSayac - 1]];
              Navigator.pushNamed(context, '/SiparisDetayPage',
                  arguments: _gelen);
            },
          );
        } else if (index < _aktifAdet + _bekleyenAdet + 2 && _isbekleyennull) {
          return Container(
            height: (_height / 15),
            alignment: Alignment.center,
            child: Text('AKTİF SİPARİŞ YOK'),
          );
        } else if (index < _aktifAdet + _bekleyenAdet + 2) {
          _aktifSayac++;
          return GestureDetector(
            child: SizedBox(
              height: (_height / 15),
              child: Card(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('MASA NO : ' +
                        _aktifList[_aktifSayac - 1].masaNo.toString())),
              ),
            ),
            onTap: () {
              List<dynamic> _gelen = [_cafe, _aktifList[_aktifSayac - 1]];
              Navigator.pushNamed(context, '/SiparisDetayPage',
                  arguments: _gelen);
            },
          );
        } else if (_istelimnull) {
          return Container(
            height: (_height / 15),
            alignment: Alignment.center,
            child: Text('TESLİM EDİLMİŞ SİPARİŞ YOK'),
          );
        } else {
          _telimSayac++;
          return GestureDetector(
            child: SizedBox(
              height: (_height / 15),
              child: Card(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('MASA NO : ' +
                      _teslimList[_telimSayac - 1].masaNo.toString()),
                ),
              ),
            ),
            onTap: () {
              List<dynamic> _gelen = [_cafe, _teslimList[_telimSayac - 1]];
              Navigator.pushNamed(context, '/SiparisDetayPage',
                  arguments: _gelen);
            },
          );
        }
      },
      itemCount: _sayac,
    );
  }
}
