import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musterimodel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

bool _duzenle = false;
String _imgurl = '';
Cafe _cafe = Cafe();

class CafeDenemePage extends StatefulWidget {
  const CafeDenemePage({Key? key}) : super(key: key);

  @override
  State<CafeDenemePage> createState() => _CafeDenemePageState();
}

class _CafeDenemePageState extends State<CafeDenemePage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
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
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                fixedSize: Size((_width / 4), (_height / 15)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              if (_duzenle) {
                                _duzenle = false;
                              } else {
                                _duzenle = true;
                              }

                              setState(() {});
                            },
                            child: Text(
                              _duzenlebuton(_duzenle),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Card(
            // margin: EdgeInsets.only(right: (_width / 45)),
            child: MenuKategori(),
          ),
          Flexible(
              child: RefreshIndicator(
                  onRefresh: () {
                    return _sendDataMenuRef(context);
                  },
                  child: const MenuBody()))
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
          } else if (_secilenkat == '') {
            EasyLoading.showToast("LÜTFEN KATEGORİ SEÇİNİZ");
          } else {
            var k = KategoriCafe();
            k.name = _secilenkat;
            if (_gelen.length < 2) {
              _gelen.add(_cafe);
              _gelen.add(k.name);
            } else {
              _gelen[0] = _cafe;
              _gelen[1] = k.name;
            }

            Navigator.pushNamedAndRemoveUntil(context, '/CafeYeniUrunPage',
                (route) => route.settings.name == '/CafeHomePage',
                arguments: _gelen);
          }
        },
      ),
    );
  }

  _sendDataMenuRef(BuildContext cnt) async {
    var tok = Tokens();
    tok.tokenDetails = await tokenGet();
    _cafe.tokens = tok;

    _cafe.istekTip = 'menu_ref';

    WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
    var json = jsonEncode(_cafe.toMap());

    channel.sink.add(json);
    channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Cafe.fromMap(jsonobject);
        if (_cafe.status == true) {
          setState(() {});
        }
        channel.sink.close();
      },
      onError: (error) => {},
      onDone: () => {},
    );
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
        child: const Text('DÜZENLE'),
      ),
    );
  }
}

String _kategoriHint = 'KATEGORİ';

String _secilenkat = '';

class MenuKategori extends StatefulWidget {
  const MenuKategori({Key? key}) : super(key: key);

  @override
  State<MenuKategori> createState() => _MenuKategoriState();
}

class _MenuKategoriState extends State<MenuKategori> {
  @override
  Widget build(BuildContext context) {
    if (_cafe.menu != null && _cafe.menu?.kategori != null) {
      var ok = false;
      for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
        if (_cafe.menu!.kategori![i].name == _kategoriHint) {
          ok = true;
        }
      }
      if (_kategoriHint != 'KATEGORİ' && ok == true) {
      } else {
        _kategoriHint = 'KATEGORİ';
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _isKategoriDuzenleRemove(_duzenle, context),
        DropdownButton<String>(
          hint: Text(
            _kategoriHint,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          items: _menukategori(),
          onChanged: (value) {
            _kategoriHint = value.toString();
            _secilenkat = value.toString();
            setState(() {});
          },
        ),
        _isKategoriDuzenleAdd(_duzenle, context)
      ],
    );
  }
}

var _kategoricontroller = TextEditingController();

_menukategori() {
  List<String> name = [];

  if (_cafe.menu != null && _cafe.menu?.kategori != null) {
    for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
      name.add(_cafe.menu!.kategori![i].name.toString());
    }
  }
  return name
      .map((masa) => DropdownMenuItem(value: masa, child: Text(masa)))
      .toList();
}

_isKategoriDuzenleAdd(bool ok, BuildContext context) {
  if (ok) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: TextField(controller: _kategoricontroller),
              title: const Text('KATEGORİ EKLE'),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (_kategoricontroller.text.isEmpty) {
                        EasyLoading.showToast('KATEGORİ İSMİ BOŞ OLAMAZ');
                      } else {
                        var k = KategoriCafe();
                        var ok = true;
                        if (_cafe.menu != null &&
                            _cafe.menu?.kategori != null) {
                          for (var i = 0;
                              i < _cafe.menu!.kategori!.length;
                              i++) {
                            if (_cafe.menu!.kategori![i].name ==
                                _kategoricontroller.text) {
                              ok = false;
                            }
                          }
                        }

                        if (ok == true) {
                          k.name = _kategoricontroller.text;

                          if (_cafe.menu == null) {
                            var menu = MenuCafe();

                            menu.kategori = [k];
                          } else if (_cafe.menu!.kategori == null) {
                            _cafe.menu!.kategori = [k];
                          } else {
                            _cafe.menu!.kategori!.add(k);
                          }

                          _sendRefMenu(context);
                        } else {
                          EasyLoading.showToast('AYNI İSİMDE KATEGORİ VAR');
                        }
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/CafeMenuPage',
                            arguments: _cafe);
                      }
                    },
                    child: const Text('onay')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('vazgeç'))
              ],
            );
          },
        );
      },
    );
  } else {
    return Container();
  }
}

_isKategoriDuzenleRemove(bool ok, BuildContext context) {
  if (ok) {
    return IconButton(
      icon: const Icon(Icons.remove),
      onPressed: () {
        if (_secilenkat == '') {
          EasyLoading.showToast('SİLMEK İSTEDİĞİNİZ KATEGORİYİ SEÇİNİZ');
        }
        if (_cafe.menu?.kategori != null) {
          for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
            if (_cafe.menu!.kategori![i].name == _secilenkat) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content:
                        Text('$_secilenkat`ı silmek istediğine eminmisin?'),
                    title: const Text('KATEGORİ SİL'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            _cafe.menu!.kategori!.removeAt(i);
                            _sendRefMenu(context);
                          },
                          child: const Text('onay')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('vazgeç'))
                    ],
                  );
                },
              );
            }
          }
        }
      },
    );
  } else {
    return Container();
  }
}

class MenuBody extends StatefulWidget {
  const MenuBody({Key? key}) : super(key: key);

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

bool _bos = true;
UrunCafe _urun = UrunCafe();

class _MenuBodyState extends State<MenuBody> {
  @override
  void initState() {
    _bos = true;
    _urun = UrunCafe();
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<KategoriCafe> list = _kategoriWithoutNull(_cafe.menu!);
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            primary: false,
            padding: const EdgeInsets.all(0),
            itemBuilder: (context, index) {
              return GestureDetector(
                child: _menubodycard(index, _bos, context, list),
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
  var sayac = 0;
  if (_cafe.menu != null && _cafe.menu?.kategori != null) {
    sayac = sayac + _cafe.menu!.kategori!.length;
    for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
      if (_cafe.menu!.kategori![i].urun != null) {
        _bos = false;

        sayac = sayac + _cafe.menu!.kategori![i].urun!.length;
      } else {
        sayac = sayac - 1;
      }
    }
  }

  if (sayac == 0) {
    return 2;
  } else {
    return sayac + 1;
  }
}

List<KategoriCafe> _kategoriWithoutNull(MenuCafe menu) {
  List<KategoriCafe> list = [];
  if (menu.kategori != null) {
    for (var i = 0; i < menu.kategori!.length; i++) {
      if (menu.kategori![i].urun != null) {
        list.add(menu.kategori![i]);
      }
    }
  }

  return list;
}

List<dynamic> _geturun(int index, List<KategoriCafe>? kategorilist) {
  //return => index 0 = kategori name , index 1 = urun

  String name = '';
  UrunCafe urun = UrunCafe();
  List<dynamic> urunandkate = ['', urun];

  if (kategorilist != null) {
    for (var i = 0; i < kategorilist.length; i++) {
      if (index < kategorilist[i].urun!.length + 1) {
        name = kategorilist[i].name.toString();

        urunandkate[0] = name;
        if (index == 0) {
          return urunandkate;
        } else {
          urun = kategorilist[i].urun![index - 1];
          urunandkate[1] = urun;
          return urunandkate;
        }
      } else {
        index = index - (kategorilist[i].urun!.length + 1);
      }
    }
  }

  return urunandkate;
}

List<dynamic> _gelen = []; // index 0 = cafe, index 1 = urun
String _kategoriname = '';
_menubodycard(
    int index, bool bos, BuildContext context, List<KategoriCafe> list) {
  if (bos == true && index == 0) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20), bottom: (_height / 20)),
      alignment: Alignment.center,
      child: const Text(
        'HİÇ ÜRÜN YOK',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  } else {
    List<dynamic> urunandkate = _geturun(index, list);

    _kategoriname = urunandkate[0];
    _urun = urunandkate[1];
    if (index == _sayacf() - 1) {
      return Container();
    } else if (_urun.name == null) {
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
      bool isImage = false;
      if (_urun.resimId != null && _urun.resimId != '') {
        isImage = true;
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
                child: _image(isImage, _urun),
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
                '${_urun.ucret} ₺',
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 15),
              ),
              onTap: () {
                List<dynamic> urunandkate = _geturun(index, list);

                _kategoriname = urunandkate[0];
                _urun = urunandkate[1];
                List<dynamic> gelen2 = [];
                gelen2.add(_cafe);
                gelen2.add(_kategoriname);

                gelen2.add(_urun.name);

                Navigator.pushNamed(context, '/CafeMenuDetayPage',
                    arguments: gelen2);
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
    return SizedBox(
      width: (_width / 20),
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
      son = '$a\n';
    } else {
      son = '$a-\n';
    }

    if (b.length > 20) {
      c = b.substring(0, 20);
      d = b.substring(20, b.length);

      if (c[c.length - 1] == ' ') {
        son = '$son$c\n';
      } else {
        son = '$son$c-\n';
      }

      if (d.length > 19) {
        e = d.substring(0, 19);
        son = '$son$e...';
      } else {
        son = son + d;
      }
    } else {
      son = son + b;
    }
  } else if (text == '') {
    son = ' ';
  } else {
    son = '\n$text';
  }

  return son;
}

String _basliktext(String text) {
  String son = '';
  if (text.length > 23) {
    var b = '${text.substring(0, 23)}...';

    son = b;
  } else {
    son = text;
  }
  return son;
}

_sendRefMenu(BuildContext context) async {
  var tok = Tokens();
  tok.tokenDetails = await tokenGet();
  _cafe.tokens = tok;

  _cafe.istekTip = 'menu_ref';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(_cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataMenuRef(json, channel, context, _cafe);
}
