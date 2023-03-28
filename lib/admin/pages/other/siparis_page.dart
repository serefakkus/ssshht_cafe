import 'package:flutter/material.dart';

import '../../model/cafe.dart';
import '../../model/musterimodel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Cafe _cafe = Cafe();
SiparisSor _siparisSor = SiparisSor();
Siparis _siparis = Siparis();

class CafeSiparisPage extends StatefulWidget {
  const CafeSiparisPage({Key? key}) : super(key: key);

  @override
  State<CafeSiparisPage> createState() => _CafeSiparisPageState();
}

class _CafeSiparisPageState extends State<CafeSiparisPage> {
  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Container(
        child: Column(children: [
      SizedBox(
        child: SiparisAppBar(),
        height: (_height / 6),
      ),
      const Flexible(child: SiparisBody())
    ]));
  }
}

class SiparisBody extends StatelessWidget {
  const SiparisBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/backgroud.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: (_height / 20),
          ),
          Flexible(
            child: BekleyenSiparis(),
          ),
        ],
      ),
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
        if (_cafe.siparisSor!.aktif![i].masaNo == null ||
            _cafe.siparisSor!.aktif![i].masaNo == "" ||
            _cafe.siparisSor!.aktif![i].masaNo == " ") {
          _cafe.siparisSor!.aktif!.removeAt(i);
        }
      }
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
                color: Colors.yellow,
                alignment: Alignment.center,
                child: Text(
                  'BEKLEYEN SİPARİŞ',
                  style: TextStyle(fontSize: (20), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        } else if (index == _bekleyenAdet + 1) {
          return SizedBox(
            height: (_height / 10),
            child: Card(
              child: Container(
                color: Colors.greenAccent.shade400,
                alignment: Alignment.center,
                child: Text(
                  'AKTİF SİPARİŞ',
                  style: TextStyle(fontSize: (20), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        } else if (index == _bekleyenAdet + _aktifAdet + 2) {
          return SizedBox(
            height: (_height / 10),
            child: Card(
              child: Container(
                color: Colors.blue,
                alignment: Alignment.center,
                child: Text(
                  'TESLİLM EDİLMİŞ SİPARİŞ',
                  style: TextStyle(fontSize: (20), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        } else if (index < _bekleyenAdet + 1 && _isbekleyennull) {
          return Container(
            height: (_height / 15),
            alignment: Alignment.center,
            child: Text('BEKLEYEN SİPARİŞ YOK'),
          );
        } else if (index < _bekleyenAdet + 1) {
          _bekleyenSayac++;
          var _siparis = _bekleyenList[_bekleyenSayac - 1];
          return GestureDetector(
            child: SizedBox(
              height: (_height / 15),
              child: Card(
                child: Container(
                  color: Colors.yellow.shade200,
                  alignment: Alignment.center,
                  child: Text(
                    'MASA NO : ' +
                        _bekleyenList[_bekleyenSayac - 1].masaNo.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.8),
                  ),
                ),
              ),
            ),
            onTap: () {
              debugPrint(_bekleyenSayac.toString());
              List<dynamic> _gelen = [_cafe, _siparis];
              Navigator.pushNamed(context, '/CafeSiparisDetayPage',
                  arguments: _gelen);
            },
          );
        } else if (index < _aktifAdet + _bekleyenAdet + 2 && _isaktifnull) {
          return Container(
            height: (_height / 15),
            alignment: Alignment.center,
            child: Text('AKTİF SİPARİŞ YOK'),
          );
        } else if (index < _aktifAdet + _bekleyenAdet + 2) {
          _aktifSayac++;
          var _siparis = _aktifList[_aktifSayac - 1];
          return GestureDetector(
            child: SizedBox(
              height: (_height / 15),
              child: Card(
                child: Container(
                  color: Colors.greenAccent,
                  alignment: Alignment.center,
                  child: Text(
                    'MASA NO : ' +
                        _aktifList[_aktifSayac - 1].masaNo.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.8),
                  ),
                ),
              ),
            ),
            onTap: () {
              List<dynamic> _gelen = [_cafe, _siparis];
              Navigator.pushNamed(context, '/CafeSiparisDetayPage',
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
          var _siparis = _teslimList[_telimSayac - 1];
          return GestureDetector(
            child: SizedBox(
              height: (_height / 15),
              child: Card(
                child: Container(
                  color: Colors.blue.shade300,
                  alignment: Alignment.center,
                  child: Text(
                    'MASA NO : ' +
                        _teslimList[_telimSayac - 1].masaNo.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17.8),
                  ),
                ),
              ),
            ),
            onTap: () {
              List<dynamic> _gelen = [_cafe, _siparis];
              Navigator.pushNamed(context, '/CafeSiparisDetayPage',
                  arguments: _gelen);
            },
          );
        }
      },
      itemCount: _sayac,
    );
  }
}
