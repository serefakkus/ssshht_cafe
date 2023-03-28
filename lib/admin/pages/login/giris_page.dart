import 'dart:convert';

import 'package:flutter/material.dart';
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
Cafe _pers = Cafe();

TextEditingController _phonecontroller = TextEditingController();
TextEditingController _passcontroller = TextEditingController();

class CafeGirisPage extends StatefulWidget {
  const CafeGirisPage({Key? key}) : super(key: key);

  @override
  State<CafeGirisPage> createState() => _CafeGirisPageState();
}

class _CafeGirisPageState extends State<CafeGirisPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    //String as = ModalRoute.of(context)!.settings.arguments as String;
    return const Scaffold(
      body: Giris(),
    );
  }
}

class Giris extends StatefulWidget {
  const Giris({Key? key}) : super(key: key);

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  @override
  void initState() {
    super.initState();
    _getpass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            children: const [
              GeriButton(),
              TelefonNumarasi(),
            ],
          ),
          const PhoneInput(),
          const Sifre(),
          const SifreInput(),
          const GirisButon(),
          const KodGirisButton(),
        ],
      ),
    );
  }

  _getpass() async {
    var s = await passGet();

    if (s.pass != null && s.pass != '' && s.phone != null && s.phone != '') {
      _phonecontroller.text = s.phone!;
      _passcontroller.text = s.pass!;

      setState(() {});
    }
  }
}

sendLogin(BuildContext context) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);

  if (_phonecontroller.text.isNotEmpty || _passcontroller.text.isNotEmpty) {
    //data.sign?.phone = _phonecontroller.text;
    //data.sign?.pass = _passcontroller.text;
    Sign sign = Sign();
    sign.pass = _passcontroller.text;
    sign.phone = _phonecontroller.text;
    _pers.sign = sign;

    _pers.istekTip = 'login_pass';

    var json = jsonEncode(_pers.toMap());
    sendDataSignIn(context, json, channel);
  }
}

class TelefonNumarasi extends StatelessWidget {
  const TelefonNumarasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: _width / 5, top: _height / 10),
      //margin: const EdgeInsets.only(top: 180),
      child: const Text(
        'TELEFON\n NUMARASI',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 90), left: (_width / 10), right: (_width / 10)),
      child: TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.blue.shade50),
        controller: _phonecontroller,
        cursorColor: Colors.blue,
        keyboardType:
            const TextInputType.numberWithOptions(signed: true, decimal: true),
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class Sifre extends StatelessWidget {
  const Sifre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 12)),
      child: const Text(
        'SIFRE',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class SifreInput extends StatelessWidget {
  const SifreInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 120), left: (_width / 10), right: (_width / 10)),
      child: TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.blue.shade50),
        controller: _passcontroller,
        textInputAction: TextInputAction.go,
      ),
    );
  }
}

class GirisButon extends StatelessWidget {
  const GirisButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 3), left: (_width / 10), right: (_width / 10)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width * 0.8), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text('GİRİŞ YAP'),
        onPressed: () {
          sendLogin(context);
        },
      ),
    );
  }
}

class KodGirisButton extends StatelessWidget {
  const KodGirisButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: TextButton(
        child: const Text('ŞİFREMİ UNUTTUM'),
        onPressed: () {
          Navigator.pushNamed(context, '/CafeKodGirisPage');
        },
      ),
    );
  }
}

class GeriButton extends StatelessWidget {
  const GeriButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: _width / 20),
      child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: _width / 10,
          )),
    );
  }
}
