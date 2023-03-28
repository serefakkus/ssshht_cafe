import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../helpers/sqldatabase.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

bool _duzenle = false;
String _baslik = 'baslik';
String _icerik =
    'asdasdfasdf asd sad faasdf asd fsad fasd fasdf sadf asdf asd asd fasdf sd fasd fasdf asdf asd fasdf asdf asd fasdf sda fsad fasd dfa';
String _fiyat = '120.00 tl';
String _imgurl =
    'https://cdn.yemek.com/mnresize/940/940/uploads/2020/05/atom-tost-yemekcom.jpg';
KategoriCafe _kategori = KategoriCafe();
Personel _cafe = Personel();

class PersonelMenuPage extends StatefulWidget {
  const PersonelMenuPage({Key? key}) : super(key: key);

  @override
  State<PersonelMenuPage> createState() => _PersonelMenuPageState();
}

class _PersonelMenuPageState extends State<PersonelMenuPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = ModalRoute.of(context)!.settings.arguments as Personel;
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: (_height / 6),
            child: Column(
              children: [
                Container(
                  color: Colors.grey.shade700,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MenuAppBar(),
                      SizedBox(
                        child: Container(
                          margin: EdgeInsets.only(
                              right: (_width / 18), top: (_height / 50)),
                          alignment: Alignment.center,
                          color: Colors.grey.shade700,
                          child: ElevatedButton(
                            child: Text(
                              _duzenlebuton(_duzenle),
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: 10,
                                fixedSize: Size((_width / 4), (_height / 15)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            onPressed: () {
                              if (_cafe.yetki?[0] == true) {
                                if (_duzenle) {
                                  _duzenle = false;
                                } else {
                                  _duzenle = true;
                                }

                                setState(() {});
                              } else {
                                EasyLoading.showToast('YETKİNİZ YOK');
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
          Card(
            // margin: EdgeInsets.only(right: (_width / 45)),
            child: MenuKategori(),
          ),
          Flexible(
              child: RefreshIndicator(
            child: MenuBody(),
            onRefresh: () {
              return _sendDataMenuRef(context);
            },
          ))
        ],
      ),
    );
  }

  _sendDataMenuRef(BuildContext cnt) async {
    var _tok = Tokens();
    _tok.tokenDetails = await tokenGet();
    _cafe.token = _tok;

    _cafe.istekTip = 'menu_ref';

    WebSocketChannel _channel = IOWebSocketChannel.connect(urlPeronel);
    var json = jsonEncode(_cafe.toMap());

    _channel.sink.add(json);
    _channel.stream.listen(
      (data) {
        var jsonobject = jsonDecode(data);
        _cafe = Personel.fromMap(jsonobject);
        if (_cafe.status == true) {
          setState(() {});
        }
        _channel.sink.close();
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
  MenuAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade700,
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
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: 45,
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(left: (_width / 20)), child: CafeImg()),
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
  DuzenleButon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 2)),
      child: ElevatedButton(
        child: Text('DÜZENLE'),
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

String _kategoriHint = 'KATEGORİ';

String _secilenkat = '';

class MenuKategori extends StatefulWidget {
  MenuKategori({Key? key}) : super(key: key);

  @override
  State<MenuKategori> createState() => _MenuKategoriState();
}

class _MenuKategoriState extends State<MenuKategori> {
  @override
  Widget build(BuildContext context) {
    if (_cafe.menu != null && _cafe.menu?.kategori != null) {
      var _ok = false;
      for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
        if (_cafe.menu!.kategori![i].name == _kategoriHint) {
          _ok = true;
        }
      }
      if (_kategoriHint != 'KATEGORİ' && _ok == true) {
      } else {
        _kategoriHint = 'KATEGORİ';
      }
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isKategoriDuzenleRemove(_duzenle, context),
          DropdownButton<String>(
            hint: Text(
              _kategoriHint,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
      ),
    );
  }
}

var _kategoricontroller = TextEditingController();

_menukategori() {
  List<String> _name = [];

  if (_cafe.menu != null && _cafe.menu?.kategori != null) {
    for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
      _name.add(_cafe.menu!.kategori![i].name.toString());
    }
  }
  return _name
      .map((masa) => DropdownMenuItem(child: Text(masa), value: masa))
      .toList();
}

_isKategoriDuzenleAdd(bool ok, BuildContext context) {
  var _tiklandi = false;
  if (ok) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: TextField(controller: _kategoricontroller),
                title: Text('KATEGORİ EKLE'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        if (_kategoricontroller.text.isEmpty) {
                          EasyLoading.showToast('KATEGORİ İSMİ BOŞ OLAMAZ');
                        } else {
                          var k = KategoriCafe();
                          var _ok = true;
                          if (_cafe.menu != null &&
                              _cafe.menu?.kategori != null) {
                            for (var i = 0;
                                i < _cafe.menu!.kategori!.length;
                                i++) {
                              if (_cafe.menu!.kategori![i].name ==
                                  _kategoricontroller.text) {
                                _ok = false;
                              }
                            }
                          }

                          if (_ok == true) {
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
                          Navigator.pushNamed(context, '/MenuPage',
                              arguments: _cafe);
                        }
                      },
                      child: Text('onay')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('vazgeç'))
                ],
              );
            },
          );
        },
      ),
    );
  } else {
    return Container();
  }
}

_isKategoriDuzenleRemove(bool ok, BuildContext context) {
  if (ok) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.remove),
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
                      title: Text('KATEGORİ SİL'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              _cafe.menu!.kategori!.removeAt(i);
                              _sendRefMenu(context);
                            },
                            child: Text('onay')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('vazgeç'))
                      ],
                    );
                  },
                );
              }
            }
          }
        },
      ),
    );
  } else {
    return Container();
  }
}

class MenuBody extends StatefulWidget {
  MenuBody({Key? key}) : super(key: key);

  @override
  State<MenuBody> createState() => _MenuBodyState();
}

bool _bos = true;
UrunCafe _urun = UrunCafe();

class _MenuBodyState extends State<MenuBody> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<KategoriCafe> _list = _kategoriWithoutNull(_cafe.menu!);
    return Container(
      child: Column(
        children: [
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              primary: false,
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
      ),
    );
  }
}

int _sayacf() {
  var _sayac = 0;
  if (_cafe.menu != null && _cafe.menu?.kategori != null) {
    _sayac = _sayac + _cafe.menu!.kategori!.length;
    for (var i = 0; i < _cafe.menu!.kategori!.length; i++) {
      if (_cafe.menu!.kategori![i].urun != null) {
        _bos = false;

        _sayac = _sayac + _cafe.menu!.kategori![i].urun!.length;
      } else {
        _sayac = _sayac - 1;
      }
    }
  }

  if (_sayac == 0) {
    return 2;
  } else {
    return _sayac + 1;
  }
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
  if (bos == true) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20), bottom: (_height / 20)),
      alignment: Alignment.center,
      child: Text(
        'HİÇ ÜRÜN YOK',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  } else {
    List<dynamic> _urunandkate = _geturun(index, list);

    _kategoriname = _urunandkate[0];
    _urun = _urunandkate[1];
    if (index == _sayacf() - 1) {
      return GestureDetector(
        child: Container(
          margin: EdgeInsets.only(top: (_height / 50)),
          child: CircleAvatar(
            radius: 30,
            child: Icon(Icons.add),
          ),
        ),
        onTap: () {
          if (_cafe.yetki?[0] == true) {
            if (_cafe.menu?.kategori == null ||
                _cafe.menu!.kategori!.length == 0) {
              EasyLoading.showToast("LÜTFEN ÖNCE KATEGORİ OLUŞTURUNUZ");
            } else if (_secilenkat == '') {
              EasyLoading.showToast("LÜTFEN KATEGORİ SEÇİNİZ");
            } else {
              var _k = KategoriCafe();
              _k.name = _secilenkat;
              if (_gelen.length < 2) {
                _gelen.add(_cafe);
                _gelen.add(_k.name);
              } else {
                _gelen[0] = _cafe;
                _gelen[1] = _k.name;
              }

              Navigator.pushNamedAndRemoveUntil(context, '/YeniUrunPage',
                  (Route) => Route.settings.name == '/HomePage',
                  arguments: _gelen);
            }
          } else {
            EasyLoading.showToast('YETKİNİZ YOK');
          }
        },
      );
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
            color: Colors.blueGrey,
            shadowColor: Colors.red,
            child: Container(
              margin: EdgeInsets.only(top: (_height / 120)),
              child: Text(
                _kategoriname,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      );
    } else {
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: (_height / 12),
                    width: (_width / 3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(30)),
                      child: Image.network(_imgurl),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(),
                    child: Column(
                      children: [
                        Text(
                          _basliktext(_urun.name.toString()),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: (_height / 90)),
                          child: Expanded(
                            child: Text(
                              _textbol(_urun.tarif),
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: (_width / 20)),
                    child: Text(
                      _urun.ucret.toString() + ' ₺',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              height: (_height / 10),
            ),
          ),
        ),
        onTap: () {
          if (_cafe.yetki?[0] == true) {
            List<dynamic> _urunandkate = _geturun(index, list);

            _kategoriname = _urunandkate[0];
            _urun = _urunandkate[1];
            List<dynamic> _gelen2 = [];
            _gelen2.add(_cafe);
            _gelen2.add(_kategoriname);

            _gelen2.add(_urun.name);

            Navigator.pushNamed(context, '/MenuDetayPage', arguments: _gelen2);
          } else {
            EasyLoading.showToast('YETKİNİZ YOK');
          }
        },
      );
    }
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
    son = text;
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

_sendRefMenu(BuildContext context) async {
  var _tok = Tokens();
  _tok.tokenDetails = await tokenGet();
  _cafe.token = _tok;

  _cafe.istekTip = 'menu_ref';

  WebSocketChannel _channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(_cafe.toMap());

  sendDataMenuRef(json, _channel, context, _cafe);
}
