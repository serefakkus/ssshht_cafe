import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'admin/helpers/send.dart';
import 'admin/helpers/sqldatabase.dart';
import 'admin/model/cafe.dart';
import 'admin/model/musterimodel.dart';
import 'main.dart';
import 'route_generator.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      onGenerateRoute: RouteGenerator.routeGenerator,
      home: const Islogin(),
    );
  }
}

class Islogin extends StatefulWidget {
  const Islogin({Key? key}) : super(key: key);

  @override
  State<Islogin> createState() => _IsloginState();
}

class _IsloginState extends State<Islogin> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isUserLogin(context),
    );
  }
}

_gettoken(BuildContext context) async {
  Cafe mus = Cafe();
  var token = await tokenGet();
  var type = await typeGet();
  if (token.accessToken == null || token.accessToken == '') {
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, '/WelcomePage');
  } else {
    Tokens tokens = Tokens();
    tokens.tokenDetails = token;
    mus.tokens = tokens;
    Sign sign = Sign();
    sign.userType = type;
    mus.sign = sign;
    var date = DateTime.fromMillisecondsSinceEpoch(token.atExpires! * 1000);
    var date2 = DateTime.fromMillisecondsSinceEpoch(token.rtExpires! * 1000);
    if (date.isAfter(DateTime.now())) {
      if (type == 1) {
        // ignore: use_build_context_synchronously
        _sendIsTokenOkAdmin(context);
      } else if (type == 2) {
        // ignore: use_build_context_synchronously
        _sendIsTokenOkPersonel(context);
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/WelcomePage');
      }
    } else if (date2.isAfter(DateTime.now())) {
      if (type == 1) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/CafeRefTokenPage', arguments: mus);
        return;
      }
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/PersonelRefTokenPage', arguments: mus);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/WelcomePage');
    }
  }
}

isUserLogin(BuildContext cnt) {
  _gettoken(cnt);
}

_sendIsTokenOkAdmin(BuildContext context) async {
  var tok = Tokens();
  Cafe cafe = Cafe();
  tok.tokenDetails = await getToken(context);
  cafe.tokens = tok;

  cafe.istekTip = 'is_ok';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlAdmin);
  var json = jsonEncode(cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataIsOkAdmin(json, channel, context);
}

_sendIsTokenOkPersonel(BuildContext context) async {
  var tok = Tokens();
  Cafe cafe = Cafe();
  tok.tokenDetails = await getToken(context);
  cafe.tokens = tok;

  cafe.istekTip = 'is_ok';

  WebSocketChannel channel = IOWebSocketChannel.connect(urlPeronel);
  var json = jsonEncode(cafe.toMap());

  // ignore: use_build_context_synchronously
  sendDataIsOkPersonel(json, channel, context);
}
