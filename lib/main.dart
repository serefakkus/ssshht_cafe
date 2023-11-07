import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'first_page.dart';

String urlAdmin = 'ws://main.ssshht.store/wscaf';
String urlPeronel = 'ws://main.ssshht.store/wsper';
String urlPersonelCagri = 'ws://cagri.ssshht.store/wsper';
String imageurl = 'http://media.ssshht.store/';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Hive.initFlutter('qrcafe');

  runApp(const FirstPage());
}
