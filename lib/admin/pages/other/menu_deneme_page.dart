// ignore_for_file: unnecessary_const, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../main.dart';
import '../../model/cafe.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

bool _duzenle = false;
String _imgurl = '';
Cafe _cafe = Cafe();
bool _isfirs = true;

class CafeMenuDenemePage extends StatefulWidget {
  const CafeMenuDenemePage({Key? key}) : super(key: key);

  @override
  State<CafeMenuDenemePage> createState() => _CafeMenuDenemePageState();
}

class _CafeMenuDenemePageState extends State<CafeMenuDenemePage> {
  @override
  void initState() {
    _isfirs = true;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;

    if (_isfirs) {
      _isfirs = false;
      if (_cafe.menu!.kategori != null) {
        _secilenKategori = _cafe.menu!.kategori![0];
      }
    }
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: (_height / 6),
            child: Column(
              children: [
                Container(
                  color: Colors.blueGrey.shade700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MenuAppBar(),
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.only(
                              right: (_width / 18), top: (_height / 50)),
                          alignment: Alignment.center,
                          color: Colors.blueGrey.shade700,
                          child: ElevatedButton(
                            child: Text(
                              _duzenlebuton(false),
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                fixedSize: Size((_width / 4), (_height / 15)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              if (_secilenKategori.name != null &&
                                  _secilenKategori.name != '') {
                                _gelen = [];
                                _gelen.add(_cafe);
                                _gelen.add(_secilenKategori.name);
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/CafeKategoriDuzenlePage',
                                    (route) =>
                                        route.settings.name == '/CafeHomePage',
                                    arguments: _gelen);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MenuBody(_setStateCallBack),
          const Flexible(child: UrunBody())
        ],
      ),
      bottomNavigationBar: GestureDetector(
        child: Container(
          margin: EdgeInsets.only(top: (_height / 50)),
          child: const CircleAvatar(
            radius: 30,
            child: Icon(Icons.add),
          ),
        ),
        onTap: () {
          if (_cafe.menu?.kategori == null || _cafe.menu!.kategori!.isEmpty) {
            EasyLoading.showToast("LÜTFEN ÖNCE KATEGORİ OLUŞTURUNUZ");
          } else if (_secilenKategori.name == '') {
            EasyLoading.showToast("LÜTFEN KATEGORİ SEÇİNİZ");
          } else {
            if (_gelen.length < 3) {
              _gelen.add(_cafe);
              _gelen.add(_secilenKategori.name);
            } else {
              _gelen[0] = _cafe;
              _gelen[1] = _secilenKategori.name;
            }

            Navigator.pushNamedAndRemoveUntil(context, '/CafeYeniUrunPage',
                (route) => route.settings.name == '/CafeHomePage',
                arguments: _gelen);
          }
        },
      ),
    );
  }

  _setStateCallBack() {
    setState(() {});
  }
}

_duzenlebuton(bool ok) {
  if (ok == false) {
    return 'DÜZENLE';
  } else {
    return 'ONAYLA';
  }
}

class MenuAppBar extends StatelessWidget {
  const MenuAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey.shade700,
      child: SizedBox(
        //width: (_width),
        height: (_height / 6),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: (_width / 10), top: (_height / 60)),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 45,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: (_width / 20)),
                child: const CafeImg()),
          ],
        ),
      ),
    );
  }
}

class CafeImg extends StatelessWidget {
  const CafeImg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: (_width / 20), right: (_width / 70), top: (_height / 40)),
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

class DuzenleButon extends StatelessWidget {
  const DuzenleButon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 2)),
      child: ElevatedButton(
        child: const Text('DÜZENLE'),
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 4), (_height / 15)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: () {
          if (_duzenle) {
            _duzenle = false;
          } else {
            _duzenle = true;
          }
        },
      ),
    );
  }
}

class MenuKategori extends StatefulWidget {
  const MenuKategori({Key? key}) : super(key: key);

  @override
  State<MenuKategori> createState() => _MenuKategoriState();
}

class _MenuKategoriState extends State<MenuKategori> {
  @override
  Widget build(BuildContext context) {
    int _sayac = 0;
    List<String> _list = _getKategoriNames(_cafe.menu!);
    if (_list.isEmpty) {
      _bos = true;
      _sayac = 1;
    } else {
      _bos = false;
      _sayac = _list.length;
    }
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(
        children: [
          SizedBox(
            height: (_height / 4.5),
            child: ListWheelScrollViewX.useDelegate(
                offAxisFraction: -0.8,
                diameterRatio: 2,
                physics: const FixedExtentScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemExtent: (_width / 2),
                squeeze: 1,
                useMagnifier: true,
                magnification: 0.1,
                onSelectedItemChanged: (value) {},
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _sayac + 1,
                  builder: (context, index) {
                    return _kategoriNameCard(
                        index, _bos, context, _list, _sayac);
                  },
                )),
          ),
        ],
      ),
    );
  }
}

List<String> _getKategoriNames(MenuCafe menu) {
  List<String> _list = [];
  if (menu.kategori != null) {
    for (var i = 0; i < menu.kategori!.length; i++) {
      _list.add(menu.kategori![i].name.toString());
    }
  }

  return _list;
}

_kategoriNameCard(
    int index, bool bos, BuildContext context, List<String> list, int sayac) {
  if (sayac == index) {
    return SizedBox(
      height: (_height / 5),
      child: Card(
        shadowColor: Colors.blueGrey,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.green, width: 1)),
        elevation: 10,
        child: Container(
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: (((_width + _height) / 2) / 10),
            child: Icon(
              Icons.add_outlined,
              color: Colors.blueAccent,
              size: (((_width + _height) / 2) / 10),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  } else {
    KategoriCafe _k = KategoriCafe();
    if (_cafe.menu != null) {
      if (_cafe.menu!.kategori != null) {
        for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
          if (list[index] == _cafe.menu!.kategori![i].name) {
            _k = _cafe.menu!.kategori![i];
          }
        }
      }
    }
    bool _isImage = false;
    if (_k.resimid != null && _k.resimid != '') {
      _isImage = true;
    }

    if (_isImage) {
      return SizedBox(
        height: (_height / 5),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Stack(children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  list[index],
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ]),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                    fit: BoxFit.fill, image: _kateImage(_isImage, _k))),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: (_height / 5),
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Stack(children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                list[index],
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ]),
        ),
      );
    }
  }
}

_kateImage(bool isimage, KategoriCafe kategori) {
  if (isimage) {
    _imgurl = imageurl + kategori.resimid!;
    return Image(
      image: NetworkImage(_imgurl),
    ).image;
  } else {
    return const Image(
      image: AssetImage("assets/images/backgroud.jpg"),
    ).image;
  }
}

FixedExtentScrollController _scrollController = FixedExtentScrollController();

class MenuBody extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const MenuBody(this.resultCallback);
  final void Function() resultCallback;

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

bool _bos = true;

class _MenuBodyState extends State<MenuBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _sayac = 0;
    List<String> _list = _getKategoriNames(_cafe.menu!);
    if (_list.isEmpty) {
      _bos = true;
      _sayac = 1;
    } else {
      _bos = false;
      _sayac = _list.length;
    }

    if (_list.isEmpty) {
      return Column(
        children: [
          SizedBox(
            height: (_height / 4),
            child: ListWheelScrollViewX.useDelegate(
                controller: _scrollController,
                offAxisFraction: -0.8,
                diameterRatio: 2,
                physics: const FixedExtentScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemExtent: (_width / 2),
                squeeze: 1,
                useMagnifier: true,
                magnification: 0.00001,
                onSelectedItemChanged: (value) {
                  if (value >= 0 && value < _sayac) {
                    if (_cafe.menu != null) {
                      if (_cafe.menu!.kategori != null) {
                        if (value < _cafe.menu!.kategori!.length) {
                          _secilenKategori = _cafe.menu!.kategori![value];
                          widget.resultCallback();
                        }
                      }
                    }
                  } else if (value == _sayac) {
                    _secilenKategori = KategoriCafe();
                    _secilenKategori.name = '';
                    widget.resultCallback();
                    //yeni kategori
                  } else if (value < 0) {
                    _scrollController.jumpToItem(0);
                  } else if (value > _sayac) {
                    _scrollController.jumpToItem(_sayac);
                  }
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: _sayac,
                  builder: (context, index) {
                    return _kategoriNameCard(
                        index + 1, _bos, context, _list, _sayac);
                  },
                )),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          height: (_height / 4),
          child: ListWheelScrollViewX.useDelegate(
              controller: _scrollController,
              offAxisFraction: -0.8,
              diameterRatio: 2,
              physics: const FixedExtentScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemExtent: (_width / 2),
              squeeze: 1,
              useMagnifier: true,
              magnification: 0.00001,
              onSelectedItemChanged: (value) {
                if (value >= 0 && value < _sayac) {
                  _secilenKategori = _cafe.menu!.kategori![value];
                  widget.resultCallback();
                } else if (value == _sayac) {
                  _secilenKategori = KategoriCafe();
                  _secilenKategori.name = '';
                  widget.resultCallback();
                  //yeni kategori
                } else if (value < 0) {
                  _scrollController.jumpToItem(0);
                } else if (value > _sayac) {
                  _scrollController.jumpToItem(_sayac);
                }
              },
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: _sayac + 1,
                builder: (context, index) {
                  return _kategoriNameCard(index, _bos, context, _list, _sayac);
                },
              )),
        ),
      ],
    );
  }
}

KategoriCafe _secilenKategori = KategoriCafe();

class UrunBody extends StatefulWidget {
  const UrunBody({Key? key}) : super(key: key);

  @override
  State<UrunBody> createState() => _UrunBodyState();
}

UrunCafe _urun = UrunCafe();

class _UrunBodyState extends State<UrunBody> {
  @override
  void initState() {
    _bos = true;
    _urun = UrunCafe();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<KategoriCafe> _list = _kategoriWithoutNull(_cafe.menu!);
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            primary: false,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: _menubodycard(index, _bos, context, _list),
                onTap: () {},
              );
            },
            itemCount: (_sayacf()),
          ),
        ),
      ],
    );
  }
}

int _sayacf() {
  var _sayac = 0;
  if (_cafe.menu != null && _cafe.menu?.kategori != null) {
    for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
      if (_cafe.menu!.kategori![i].name == _secilenKategori.name) {
        if (_cafe.menu!.kategori![i].urun != null) {
          _bos = false;

          _sayac = _cafe.menu!.kategori![i].urun!.length;
        } else {
          _bos = true;
          _sayac = 1;
        }
      }
    }
  }

  if (_secilenKategori.name == '') {
    _sayac = 1;
  }
  return _sayac;
}

List<KategoriCafe> _kategoriWithoutNull(MenuCafe menu) {
  List<KategoriCafe> _list = [];
  if (menu.kategori != null) {
    for (var i = 0; i < menu.kategori!.length; i++) {
      if (menu.kategori![i].urun != null) {
        _list.add(menu.kategori![i]);
      }
    }
  }

  return _list;
}

List<dynamic> _geturun(int index, List<KategoriCafe>? kategorilist) {
  //return => index 0 = kategori name , index 1 = urun

  String name = '';
  UrunCafe urun = UrunCafe();
  List<dynamic> _urunandkate = ['', urun];

  if (kategorilist != null) {
    for (var i = 0; i < kategorilist.length; i++) {
      if (index < kategorilist[i].urun!.length + 1) {
        name = kategorilist[i].name.toString();

        _urunandkate[0] = name;
        if (index == 0) {
          return _urunandkate;
        } else {
          urun = kategorilist[i].urun![index - 1];
          _urunandkate[1] = urun;
          return _urunandkate;
        }
      } else {
        index = index - (kategorilist[i].urun!.length + 1);
      }
    }
  }

  return _urunandkate;
}

List<dynamic> _gelen = []; // index 0 = cafe, index 1 = urun
String _kategoriname = '';
_menubodycard(
    int index, bool bos, BuildContext context, List<KategoriCafe> list) {
  if (_secilenKategori.name == '' || _secilenKategori.name == null) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 5)),
      alignment: Alignment.center,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.green,
              elevation: 10,
              fixedSize: Size((_width * 0.4), (_height / 15)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/CafeYeniKategoriPage',
                (route) => route.settings.name == '/CafeHomePage',
                arguments: _cafe);
          },
          child: const Text('KATEGORİ EKLE')),
    );
  } else if (bos == true && index == 0) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20), bottom: (_height / 20)),
      alignment: Alignment.center,
      child: const Text(
        'HİÇ ÜRÜN YOK',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  } else {
    _urun = _secilenKategori.urun![index];
    if (_urun.name == null) {
      return Container(
        margin: EdgeInsets.only(top: (_height / 20), bottom: (_height / 100)),
        child: SizedBox(
          height: (_height / 15),
          child: Card(
            margin: EdgeInsets.only(
              left: (_width / 20),
              right: (_width / 20),
            ),
            color: Colors.blueGrey.shade300,
            shadowColor: Colors.red,
            child: Container(
              margin: EdgeInsets.only(top: (_height / 120)),
              child: Text(
                _kategoriname,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    } else {
      UrunCafe _secilenurun = _urun;

      bool _isImage = false;
      if (_urun.resimId != null && _urun.resimId != '') {
        _isImage = true;
      }

      return GestureDetector(
          child: Container(
        margin: EdgeInsets.only(left: (_width / 40), right: (_width / 40)),
        child: Card(
          shadowColor: Colors.grey.shade200,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.only(top: (_height / 50)),
          color: Colors.grey.shade100,
          child: SizedBox(
            height: (_height / 10),
            child: ListTile(
              leading: SizedBox(
                width: (_width / 5),
                height: (_height / 10),
                child: _image(_isImage, _urun),
              ),
              title: Text(
                _basliktext(
                  _urun.name.toString(),
                ),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              subtitle: Text(
                _textbol(_urun.tarif),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Text(
                _urun.ucret.toString() + ' ₺',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 15),
              ),
              onTap: () {
                List<dynamic> _urunandkate = _geturun(index, list);
                _kategoriname = _urunandkate[0];
                _urun = _urunandkate[1];
                List<dynamic> _gelen2 = [];
                _gelen2.add(_cafe);
                _gelen2.add(_secilenKategori.name);
                _gelen2.add(_secilenurun.name);

                Navigator.pushNamed(context, '/CafeMenuDetayPage',
                    arguments: _gelen2);
              },
            ),
          ),
        ),
      ));
    }
  }
}

_image(bool isimage, UrunCafe urun) {
  if (isimage) {
    _imgurl = imageurl + _urun.resimId!;

    return Image(
      fit: BoxFit.cover,
      alignment: Alignment.center,
      image: NetworkImage(_imgurl),
    );
  } else {
    return SizedBox(
      width: (_width / 20),
    );
  }
}

String _textbol(String? text) {
  String son = '';
  String a, b, c, d, e;

  text ??= '';

  if (text.length > 20) {
    a = text.substring(0, 20);
    b = text.substring(20, text.length);
    if (a[a.length - 1] == ' ') {
      son = a + '\n';
    } else {
      son = a + '-' + '\n';
    }

    if (b.length > 20) {
      c = b.substring(0, 20);
      d = b.substring(20, b.length);

      if (c[c.length - 1] == ' ') {
        son = son + c + '\n';
      } else {
        son = son + c + '-' + '\n';
      }

      if (d.length > 19) {
        e = d.substring(0, 19);
        son = son + e + '...';
      } else {
        son = son + d;
      }
    } else {
      son = son + b;
    }
  } else if (text == '') {
    son = ' ';
  } else {
    son = '\n' + text;
  }

  return son;
}

String _basliktext(String text) {
  String son = '';
  if (text.length > 23) {
    var b = text.substring(0, 23) + '...';

    son = b;
  } else {
    son = text;
  }
  return son;
}

class ListWheelScrollViewX extends StatelessWidget {
  final Axis scrollDirection;
  final List<Widget>? children;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final double diameterRatio;
  final double perspective;
  final double offAxisFraction;
  final bool useMagnifier;
  final double magnification;
  final double overAndUnderCenterOpacity;
  final double itemExtent;
  final double squeeze;
  final ValueChanged<int>? onSelectedItemChanged;
  final bool renderChildrenOutsideViewport;
  final ListWheelChildDelegate? childDelegate;
  final Clip clipBehavior;

  const ListWheelScrollViewX({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.physics,
    this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.overAndUnderCenterOpacity = 1.0,
    required this.itemExtent,
    this.squeeze = 1.0,
    this.onSelectedItemChanged,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    required this.children,
  })  : childDelegate = null,
        super(key: key);

  const ListWheelScrollViewX.useDelegate({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.physics,
    this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    this.overAndUnderCenterOpacity = 1.0,
    required this.itemExtent,
    this.squeeze = 1.0,
    this.onSelectedItemChanged,
    this.renderChildrenOutsideViewport = false,
    this.clipBehavior = Clip.hardEdge,
    required this.childDelegate,
  })  : children = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _childDelegate = children != null
        ? ListWheelChildListDelegate(
            children: children!.map((child) {
            return RotatedBox(
              quarterTurns: scrollDirection == Axis.horizontal ? 1 : 0,
              child: child,
            );
          }).toList())
        : ListWheelChildBuilderDelegate(
            builder: (context, index) {
              return RotatedBox(
                quarterTurns: scrollDirection == Axis.horizontal ? 1 : 0,
                child: childDelegate!.build(context, index),
              );
            },
          );

    return RotatedBox(
      quarterTurns: scrollDirection == Axis.horizontal ? 3 : 0,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: diameterRatio,
        perspective: perspective,
        offAxisFraction: offAxisFraction,
        useMagnifier: useMagnifier,
        magnification: magnification,
        overAndUnderCenterOpacity: overAndUnderCenterOpacity,
        itemExtent: itemExtent,
        squeeze: squeeze,
        onSelectedItemChanged: onSelectedItemChanged,
        renderChildrenOutsideViewport: renderChildrenOutsideViewport,
        clipBehavior: clipBehavior,
        childDelegate: _childDelegate,
      ),
    );
  }
}
