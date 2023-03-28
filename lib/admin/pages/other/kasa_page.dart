import 'package:flutter/material.dart';
import '../../model/cafe.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Cafe _cafe = Cafe();

class CafeKasaPage extends StatefulWidget {
  const CafeKasaPage({Key? key}) : super(key: key);

  @override
  State<CafeKasaPage> createState() => _CafeKasaPageState();
}

class _CafeKasaPageState extends State<CafeKasaPage> {
  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/backgroud.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          SiparisAppBar(),
          Container(
            child: Flexible(child: KasaBody()),
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

double _kredi = 0;
double _nakit = 0;
double _puan = 0;
String _gun = '-';

class KasaBody extends StatefulWidget {
  const KasaBody({Key? key}) : super(key: key);

  @override
  State<KasaBody> createState() => _KasaBodyState();
}

class _KasaBodyState extends State<KasaBody> {
  @override
  Widget build(BuildContext context) {
    if (_cafe.hesapIstek != null) {
      if (_cafe.hesapIstek!.kredi != null) {
        _kredi = _cafe.hesapIstek!.kredi!;
      }
      if (_cafe.hesapIstek!.nakit != null) {
        _nakit = _cafe.hesapIstek!.nakit!;
      }
      if (_cafe.hesapIstek!.day != null) {
        _gun = _cafe.hesapIstek!.day!;
        var _now = DateTime.now();
        _gun = _now.day.toString() +
            '-' +
            _now.month.toString() +
            '-' +
            _now.year.toString();
      }
    }
    if (_cafe.puan != null) {
      if (_cafe.puan!.puan != null) {
        for (var i = 0; i < _cafe.puan!.puan!.length; i++) {
          if (_cafe.puan!.puan![i].puan != null) {
            _puan = _puan + _cafe.puan!.puan![i].puan!;
          }
        }
      }
    }

    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemExtent: (_height / 10),
        itemCount: 5,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: _width,
                    height: (_height / 22),
                    child: Card(
                      color: Colors.grey.shade700,
                      child: Text(
                        'GELİRLER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(
                          'GÜNLÜK\n ($_gun)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        margin: EdgeInsets.only(right: (_width / 16)),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else if (index == 1) {
            return Card(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NAKİT',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: (_width / 10)),
                        child: Text(
                          _nakit.toString() + ' TL',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else if (index == 2) {
            return Card(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KART',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: (_width / 10)),
                        child: Text(
                          _kredi.toString() + ' TL',
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else if (index == 3) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: _width,
                    height: (_height / 22),
                    child: Card(
                      color: Colors.grey.shade700,
                      child: Text(
                        'PUAN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(
                          'KALAN',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        margin: EdgeInsets.only(right: (_width / 10)),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else {
            return Card(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KALAN PUAN',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: (_width / 10)),
                        child: Text(
                          _puan.toString() + ' TL',
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
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
