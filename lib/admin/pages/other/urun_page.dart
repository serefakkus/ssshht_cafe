import 'package:flutter/material.dart';

import '../../model/cafe.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

Cafe _cafe = Cafe();
Urun _thisurun = Urun();

class CafeUrunPage extends StatefulWidget {
  const CafeUrunPage({Key? key}) : super(key: key);

  @override
  State<CafeUrunPage> createState() => _CafeUrunPageState();
}

class _CafeUrunPageState extends State<CafeUrunPage> {
  @override
  Widget build(BuildContext context) {
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return Container(
        color: Colors.yellow.shade300,
        child: Column(children: [
          SizedBox(
            child: SiparisAppBar(),
            height: (_height / 6),
          ),
          Container(
            child: SizedBox(
              child: Flexible(child: UrunBody()),
              height: (_height / 1.2),
            ),
          )
        ]));
  }
}

class UrunBody extends StatelessWidget {
  const UrunBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        child: SizedBox(
            //width: (_width / 1.3),
            child: Flexible(
                child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: (_height / 40)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                //color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        'ÜRÜN',
                        style: TextStyle(fontSize: 20),
                      ),
                      margin: EdgeInsets.only(left: (_width / 20)),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: (_width / 20)),
                      child: Text(
                        'ADET',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                //color: Colors.white,
                child: Flexible(
                  child: UrunList(),
                ),
              ),
            ],
          ),
        ))));
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

class UrunList extends StatefulWidget {
  const UrunList({Key? key}) : super(key: key);

  @override
  State<UrunList> createState() => _UrunListState();
}

class _UrunListState extends State<UrunList> {
  int _sayac = 0;
  @override
  Widget build(BuildContext context) {
    if (_cafe.urun == null || _cafe.urun?.urun == null) {
      _sayac = 1;
    } else {
      _sayac = _cafe.urun!.urun!.length;
    }

    return ListView.builder(
      itemCount: _sayac + 1,
      itemBuilder: (context, index) {
        if (_sayac > 2) {
          _thisurun = _cafe.urun!.urun![index];
        } else if (index == 0) {
          return Card(
            child: SizedBox(
                height: (_height / 15),
                child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'HİÇ ÜRÜN YOK',
                      style: TextStyle(fontSize: 20),
                    ))),
          );
        }
        if (index == _sayac) {
          return Container(
            margin: EdgeInsets.only(top: (_height / 20)),
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 30,
              child: IconButton(
                icon: Icon(Icons.add),
                iconSize: 35,
                onPressed: () {
                  Navigator.pushNamed(context, '/CafeYeniUrunPage',
                      arguments: _cafe);
                },
              ),
            ),
          );
        } else {
          return SizedBox(
            height: (_height / 11),
            child: Card(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('kola'),
                  Row(
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                      Text('10'),
                      IconButton(onPressed: () {}, icon: Icon(Icons.remove))
                    ],
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
