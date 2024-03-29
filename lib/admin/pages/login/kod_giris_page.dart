import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musterimodel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

TextEditingController _phonecontroller = TextEditingController();
TextEditingController _codecontroller = TextEditingController();
List<String> codeandphone = ['', ''];

class CafeKodGirisPage extends StatelessWidget {
  const CafeKodGirisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    //String as = ModalRoute.of(context)!.settings.arguments as String;
    return const Scaffold(
      body: KodGiris(),
    );
  }
}

class KodGiris extends StatefulWidget {
  const KodGiris({Key? key}) : super(key: key);

  @override
  State<KodGiris> createState() => _KodGirisState();
}

class _KodGirisState extends State<KodGiris> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const GeriButton(),
        Column(
          children: [
            const TelefonNumarasi(),
            Row(
              children: const [Flexible(child: PhoneInput()), CodeSendButton()],
            ),
            const Code(),
            const CodeInput(),
            const SignUpButton(),
          ],
        ),
      ],
    );
  }
}

sendCodeGiris(BuildContext context) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  if (_phonecontroller.text.isNotEmpty) {
    Sign sign = Sign();
    Cafe mus = Cafe();
    sign.phone = _phonecontroller.text;
    mus.sign = sign;
    mus.istekTip = 'login_pass_new_code';
    var json = jsonEncode(mus.toMap());

    sendDataSignUpCode(context, json, channel);
  }
}

sendCodePass(BuildContext context) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  if (_phonecontroller.text.isNotEmpty || _codecontroller.text.isNotEmpty) {
    Sign sign = Sign();
    Cafe mus = Cafe();
    sign.phone = _phonecontroller.text;
    sign.code = _codecontroller.text;
    mus.sign = sign;
    mus.istekTip = 'login_pass_ref';
    codeandphone[0] = sign.phone!;
    codeandphone[1] = sign.code!;
    var json = jsonEncode(mus.toMap());
    sendDataNewPass(context, json, channel, codeandphone);
  }
}

class TelefonNumarasi extends StatelessWidget {
  const TelefonNumarasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 7), right: (_width / 3.5)),
      child: const Text(
        'TELEFON NUMARASI',
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
          top: (_height / 30), left: (_width / 15), right: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
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
  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 30), right: (_width / 25)),
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
            sendCodeGiris(context);
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
  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 6), left: (_width / 25)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 1.2), (_height / 12.5)),
            textStyle: const TextStyle(fontSize: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text(
          'KAYIT OL',
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          setState(() {
            sendCodePass(context);
          });
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
