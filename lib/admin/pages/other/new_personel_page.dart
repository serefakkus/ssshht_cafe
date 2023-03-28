import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
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

String phoneurl = 'ws://main.ssshht.com/wsmus';
String data = "";
bool ok = false;
int count = 0;
Cafe _cafe = Cafe();
Sign _sign = Sign();
//var token = TokenDetails();
//TokenDetails tok = TokenDetails();

class CafeNewPersonelPage extends StatefulWidget {
  const CafeNewPersonelPage({Key? key}) : super(key: key);

  @override
  State<CafeNewPersonelPage> createState() => _CafeNewPersonelPageState();
}

class _CafeNewPersonelPageState extends State<CafeNewPersonelPage> {
  Future<void> scanQrCode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "İPTAL", true, ScanMode.QR);

    data = barcodeScanRes;
    ok = _isStringOk(data);
    if (ok) {
      // ignore: use_build_context_synchronously
      _sendMasaCode(context);
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    scanQrCode();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    _cafe = ModalRoute.of(context)!.settings.arguments as Cafe;
    return _qrContainer(ok, context);
  }
}

_isStringOk(String data) {
  debugPrint('data = $data');

  if (data.length < 9) {
    return ok;
  }

  var a = data.substring(0, 8);

  if (a == 'perscode') {
    debugPrint(data.toString());
    ok = true;
    var b = data.substring(9);
    _sign.code = b;
  }

  if (_cafe.personelAyar != null && _cafe.personelAyar?.pers != null) {
    for (var i = 0; i < _cafe.personelAyar!.pers!.length; i++) {
      if (_sign.id == _cafe.personelAyar!.pers![i].persId) {
        EasyLoading.showToast('BU PERSONEL ZATEN KAYITLI');
        return false;
      }
    }
  }
  return ok;
}

_qrContainer(bool ok, BuildContext cnt) {
  if (!ok) {
    return const QrPageFail();
  } else {
    return Container(
      child: _sendmasaCodeContainer(cnt),
    );
  }
}

_sendmasaCodeContainer(BuildContext cnt) {
  _sendMasaCode(cnt);
}

_sendMasaCode(BuildContext cnt) async {
  var isthere = false;
  if (_cafe.personelAyar != null && _cafe.personelAyar?.pers != null) {
    for (var i = 0; i < _cafe.personelAyar!.pers!.length; i++) {
      if (_sign.id == _cafe.personelAyar!.pers![i].persId) {
        isthere = true;
      }
    }
  }

  if (isthere == false) {
    _cafe.sign = _sign;
    _cafe.istekTip = 'add_pers';
    var tok = Tokens();
    tok.tokenDetails = await getToken(cnt);
    _cafe.tokens = tok;

    WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
    var json = jsonEncode(_cafe.toMap());

    // ignore: use_build_context_synchronously
    sendDataNewPersonel(json, channel, cnt);
  } else {
    EasyLoading.showToast('BU PERSONEL ZATEN KAYITLI');
  }
}

class QrPageFail extends StatefulWidget {
  const QrPageFail({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _QrPageFailState createState() => _QrPageFailState();
}

class _QrPageFailState extends State<QrPageFail> {
  Future<void> scanQrCode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#000000", "İPTAL", true, ScanMode.QR);
    setState(() {
      data = barcodeScanRes;
      ok = _isStringOk(data);
      if (ok) {
        _sendMasaCode(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(top: (_height / 20), left: (_width / 20)),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 50,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: (_height / 2)),
          child: ElevatedButton(
            onPressed: () => scanQrCode(),
            style: ElevatedButton.styleFrom(
                elevation: 10,
                fixedSize: Size((_width * 0.8), (_height / 15)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            child: const Text("Yeniden Tarat"),
          ),
        ),
      ],
    );
  }
}
