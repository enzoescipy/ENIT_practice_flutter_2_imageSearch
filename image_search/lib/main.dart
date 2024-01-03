import 'package:flutter/material.dart';
import 'package:image_search/package/debugConsole.dart';
import 'package:image_search/view/mainView.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_search/controller/vo_controle.dart';
import 'package:image_search/model/hive_controle.dart';

void main() async {
  // enableDebug();
  await Hive.initFlutter();
  await HIVEController.initializeHive();
  // await HIVEController.clearHive();
  GetVoFromKakao.receptRESTkey('17d7e0a3463cf55e47156470a53522bf');
  // DEBUG();
  runApp(const MyApp());
}

void DEBUG() async {
  enableDebug();

  var kakaoImgVO = GetVoFromKakao('악어', true, 2);
  var imageVOList = await kakaoImgVO.searchFirst();

  var kakaoWebVO = GetVoFromKakao('악어', false, 2);
  var webVOList = await kakaoWebVO.searchFirst();

  debugConsole(imageVOList);
  debugConsole(webVOList);

}
