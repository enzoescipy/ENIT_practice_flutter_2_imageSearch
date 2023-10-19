import 'package:flutter/material.dart';
import 'package:image_search/package/debugConsole.dart';
import 'package:image_search/view/mainView.dart';

import 'package:image_search/package/kakao_api.dart';

import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  enableDebug();
  var kakaoWebObject = KakaoImageAPI('17d7e0a3463cf55e47156470a53522bf', '악어', 3);
  kakaoWebObject.Next().then((value) => debugConsole(value));
  runApp(const MyApp());
}
