import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../../main.dart';
import '../../model/cafe.dart';
import '../../model/musterimodel.dart';

Size _size = const Size(0, 0);
double _height = 0;
double _width = 0;

TextEditingController _passcontroller = TextEditingController();
TextEditingController _newpasscontroller = TextEditingController();

class CafeNewPassLoginPage extends StatefulWidget {
  const CafeNewPassLoginPage({Key? key}) : super(key: key);

  @override
  State<CafeNewPassLoginPage> createState() => _CafeNewPassLoginPageState();
}

class _CafeNewPassLoginPageState extends State<CafeNewPassLoginPage> {
  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    _height = _size.height;
    _width = _size.width;
    List<String> code =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    return Column(
      children: [
        const Flexible(child: Pass()),
        const Flexible(child: PassInput()),
        const Flexible(child: NewPass()),
        const Flexible(child: NewPassInput()),
        SendPassButton(code),
      ],
    );
  }
}

sendNewPass(BuildContext context, List<String> code) async {
  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  if (_passcontroller.text == _newpasscontroller.text ||
      _passcontroller.text.isNotEmpty) {
    Cafe _mus = Cafe();
    var sign = Sign();
    sign.phone = code[0];
    sign.code = code[1];

    _mus.istekTip = 'login_pass_new';
    sign.pass = _passcontroller.text;
    _mus.sign = sign;
    var json = jsonEncode(_mus.toMap());

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
          top: (_height / 30), left: (_width / 15), right: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          controller: _passcontroller,
          cursorColor: Colors.blue,
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
      margin: EdgeInsets.only(top: (_height / 7)),
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
          top: (_height / 25), right: (_width / 15), left: (_width / 15)),
      child: Padding(
        padding: const EdgeInsets.only(),
        child: TextField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.blue.shade50),
          controller: _newpasscontroller,
          cursorColor: Colors.blue,
          textInputAction: TextInputAction.go,
        ),
      ),
    );
  }
}

class SendPassButton extends StatelessWidget {
  List<String> code = [];
  SendPassButton(this.code, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: (_height / 5), right: (_width / 10), left: (_width / 10)),
      alignment: Alignment.center,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 10,
            fixedSize: Size((_width / 1.2), (_height / 12.5)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50))),
        child: const Text(
          'ŞİFRE OLUŞTUR',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          sendNewPass(context, code);
        },
      ),
    );
  }
}
