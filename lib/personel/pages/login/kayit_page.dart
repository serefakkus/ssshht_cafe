import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../../main.dart';
import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

TextEditingController _phonecontroller = TextEditingController();
TextEditingController _codecontroller = TextEditingController();
List<String> _codeandphone = ['', ''];

class PersonelKayitPage extends StatelessWidget {
  const PersonelKayitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //String as = ModalRoute.of(context)!.settings.arguments as String;
    return const Scaffold(
      body: Kayit(),
    );
  }
}

class Kayit extends StatefulWidget {
  const Kayit({Key? key}) : super(key: key);

  @override
  State<Kayit> createState() => _KayitState();
}

class _KayitState extends State<Kayit> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    return ListView(
      children: [
        GeriButton(),
        Column(
          children: [
            const TelefonNumarasi(),
            Row(
              children: const [PhoneInput(), CodeSendButton()],
            ),
            const Code(),
            const CodeInput(),
            const SignUpButton(),
            const GirisButon()
          ],
        ),
      ],
    );
  }
}

sendCode(BuildContext context) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  if (_phonecontroller.text.isNotEmpty) {
    Phone ph = Phone();
    Personel pers = Personel();
    ph.no = _phonecontroller.text;
    pers.phone = ph;
    pers.istekTip = 'signup_new';
    var json = jsonEncode(pers.toMap());

    sendDataSignUpCode(context, json, channel);
  }
}

sendSignUp(BuildContext context) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  if (_phonecontroller.text.isNotEmpty || _codecontroller.text.isNotEmpty) {
    Phone ph = Phone();
    Personel pers = Personel();
    ph.no = _phonecontroller.text;
    ph.code = _codecontroller.text;
    pers.phone = ph;
    pers.istekTip = 'signup_ref';
    _codeandphone[0] = ph.no!;
    _codeandphone[1] = ph.code!;
    var json = jsonEncode(pers.toMap());
    sendDataSignUp(context, json, channel, _codeandphone);
  }
}

class TelefonNumarasi extends StatelessWidget {
  const TelefonNumarasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'TELEFON NUMARASI',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20),
    );
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 30), left: (_width / 15)),
      child: SizedBox(
        height: (_height / 15),
        width: (_width / 1.65),
        child: TextField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          controller: _phonecontroller,
          cursorColor: Colors.blue,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class Code extends StatelessWidget {
  const Code({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 7)),
      child: const Text(
        'KOD',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class CodeInput extends StatelessWidget {
  const CodeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 25), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          controller: _codecontroller,
          cursorColor: Colors.blue,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class CodeSendButton extends StatefulWidget {
  const CodeSendButton({Key? key}) : super(key: key);

  @override
  State<CodeSendButton> createState() => _CodeSendButtonState();
}

class _CodeSendButtonState extends State<CodeSendButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 30), left: (_width / 25)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 10,
          fixedSize: Size((_width / 4), (_height / 15)),
        ),
        child: const Text(
          'KOD\n GÖNDER',
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          setState(() {
            sendCode(context);
          });
        },
      ),
    );
  }
}

class SignUpButton extends StatefulWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 6), right: (_width / 10), left: (_width / 10)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 1.2), (_height / 15)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text(
          'KAYIT OL',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          setState(() {
            sendSignUp(context);
          });
        },
      ),
    );
  }
}

class GirisButon extends StatelessWidget {
  const GirisButon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: (_height / 80), top: (_height / 20)),
      child: TextButton(
        onPressed: () => {
          Navigator.pushNamed(context, '/PersonelGirisPage'),
        },
        child: const Text("GİRİŞ YAP"),
      ),
    );
  }
}

class GeriButton extends StatelessWidget {
  const GeriButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: _width / 1.3, top: _height / 20),
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
