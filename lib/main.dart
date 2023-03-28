import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'first_page.dart';

String urlAdmin = 'ws://main.ssshht.com/wscaf';
String urlPeronel = 'ws://main.ssshht.com/wsper';
String urlPersonelCagri = 'ws://cagri.ssshht.com/wsper';
String imageurl = 'http://media.ssshht.com/';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Hive.initFlutter('qrcafe');

  runApp(const FirstPage());
}
