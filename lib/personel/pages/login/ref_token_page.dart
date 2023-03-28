import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../../main.dart';
import '../../model/personel.dart';

class PersonelRefTokenPage extends StatefulWidget {
  const PersonelRefTokenPage({Key? key}) : super(key: key);

  @override
  State<PersonelRefTokenPage> createState() => _PersonelRefTokenPageState();
}

class _PersonelRefTokenPageState extends State<PersonelRefTokenPage> {
  @override
  Widget build(BuildContext context) {
    Personel _mus = ModalRoute.of(context)!.settings.arguments as Personel;

    return Container(
      child: _sendreftoken(context, _mus),
    );
  }
}

_sendreftoken(BuildContext context, Personel _mus) {
  sendRefToken(context, _mus);
}

sendRefToken(BuildContext context, Personel mus) async {
  WebSocketChannel _chnnl = IOWebSocketChannel.connect(urlPeronel);
  mus.istekTip = 'ref_token';

  var json = jsonEncode(mus.toMap());
  debugPrint(json.toString());

  sendDataRefToken(context, json, _chnnl);
}
