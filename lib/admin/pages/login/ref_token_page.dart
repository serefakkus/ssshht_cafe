import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../helpers/send.dart';
import '../../../main.dart';
import '../../model/cafe.dart';

class CafeRefTokenPage extends StatefulWidget {
  const CafeRefTokenPage({Key? key}) : super(key: key);

  @override
  State<CafeRefTokenPage> createState() => _CafeRefTokenPageState();
}

class _CafeRefTokenPageState extends State<CafeRefTokenPage> {
  @override
  Widget build(BuildContext context) {
    Cafe mus = ModalRoute.of(context)!.settings.arguments as Cafe;

    return Container(
      child: _sendreftoken(context, mus),
    );
  }
}

_sendreftoken(BuildContext context, Cafe mus) {
  sendRefToken(context, mus);
}

sendRefToken(BuildContext context, Cafe mus) async {
  WebSocketChannel chnnl = IOWebSocketChannel.connect(urlAdmin);
  mus.istekTip = 'ref_token';
  mus.tokens!.auth = mus.tokens!.tokenDetails!.refreshToken;

  var json = jsonEncode(mus.toMap());
  debugPrint(json.toString());

  sendDataRefToken(context, json, chnnl);
}
