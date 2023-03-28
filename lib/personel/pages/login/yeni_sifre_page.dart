import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../../main.dart';
import '../../model/musteri_model.dart';
import '../../model/personel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

TextEditingController _passcontroller = TextEditingController();
TextEditingController _newpasscontroller = TextEditingController();
TextEditingController _namecontroller = TextEditingController();

class PersonelNewLoginPage extends StatefulWidget {
  const PersonelNewLoginPage({Key? key}) : super(key: key);

  @override
  State<PersonelNewLoginPage> createState() => _PersonelNewLoginPageState();
}

class _PersonelNewLoginPageState extends State<PersonelNewLoginPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;

    List<String> code =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    return Column(
      children: [
        Pass(),
        PassInput(),
        NewPass(),
        NewPassInput(),
        Name(),
        NameInput(),
        SendPassButton(code),
      ],
    );
  }
}

sendPass(BuildContext context, List<String> code) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  if (_passcontroller.text == _newpasscontroller.text &&
      _passcontroller.text.isNotEmpty &&
      _namecontroller.text.isNotEmpty &&
      _namecontroller.text.length > 2) {
    debugPrint(_passcontroller.text.isNotEmpty.toString());
    debugPrint(_namecontroller.text.isNotEmpty.toString());
    debugPrint(_newpasscontroller.text.isNotEmpty.toString());
    Personel _pers = Personel();
    var sign = Sign();
    sign.phone = code[0];
    sign.code = code[1];
    sign.name = _namecontroller.text;

    _pers.istekTip = 'signup';
    sign.pass = _passcontroller.text;
    _pers.sign = sign;
    var json = jsonEncode(_pers.toMap());

    sendDataNewLogin(context, json, channel);
  } else {
    EasyLoading.showToast('GİRDİĞİNİZ ŞİFRELER\n UYUŞMUYOR');
  }
}

class Pass extends StatelessWidget {
  const Pass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 7)),
      child: const Text(
        'YENİ ŞİFRE',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class PassInput extends StatelessWidget {
  const PassInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 100), left: (_width / 15), right: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          controller: _passcontroller,
          cursorColor: Colors.blue,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class Name extends StatelessWidget {
  const Name({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: const Text(
        'İSİM',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 100), left: (_width / 15), right: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          controller: _namecontroller,
          cursorColor: Colors.blue,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class NewPass extends StatelessWidget {
  const NewPass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (_height / 20)),
      child: const Text(
        'YENİ ŞİFRE',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

class NewPassInput extends StatelessWidget {
  const NewPassInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 100), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          controller: _newpasscontroller,
          cursorColor: Colors.blue,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: true),
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class SendPassButton extends StatelessWidget {
  SendPassButton(this.code, {Key? key}) : super(key: key);
  List<String> code = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 4), right: (_width / 10), left: (_width / 10)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 1.2), (_height / 12.5)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text(
          'ŞİFRE OLUŞTUR',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () {
          sendPass(context, code);
        },
      ),
    );
  }
}
