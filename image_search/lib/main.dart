import 'package:flutter/material.dart';
import 'package:image_search/package/debugConsole.dart';
import 'package:image_search/view/mainView.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_search/controller/vo_controle.dart';
import 'package:image_search/model/hive_controle.dart';

void main() async {
  enableDebug();
  await Hive.initFlutter();
  await HIVEController.initializeHive();
  await HIVEController.clearHive();
  GetVoFromKakao.receptRESTkey('17d7e0a3463cf55e47156470a53522bf');
  // DEBUG();
  runApp(const MyApp());
}

void DEBUG() async {
  enableDebug();

  // var kakaoWebObject = KakaoImageAPI('17d7e0a3463cf55e47156470a53522bf', '악어', 3);
  // kakaoWebObject.Next().then((value) => debugConsole(value));

  // var kakaoImgVO = GetVoFromKakao('17d7e0a3463cf55e47156470a53522bf', true, 3);
  // kakaoImgVO.searchFirst('악어').then((result) {
  //   result?.forEach((element) {
  //     debugConsole(element.toString());
  //   });
  // });

  // for (int i = 0; i < 100; i++) {
  //   kakaoImgVO.searchNext().then((result) {
  //     debugConsole([result.runtimeType, i]);
  //     result?.forEach((element) {
  //       debugConsole([element.toString(), element.runtimeType]);
  //     });
  //   });
  // }

  var kakaoImgVO = GetVoFromKakao('악어', true, 2);
  var imageVOList = await kakaoImgVO.searchFirst();

  var kakaoWebVO = GetVoFromKakao('악어', false, 2);
  var webVOList = await kakaoWebVO.searchFirst();

  debugConsole(imageVOList);
  debugConsole(webVOList);

  // var VOa = imageVOList![0];
  // var VOb = imageVOList![1];
  // var VOc = webVOList![0];
  // var VOd = webVOList![1];

  // VOStageCommitGet.insertVO(VOa);
  // VOStageCommitGet.insertVO(VOa);
  // VOStageCommitGet.commit();
  // debugConsole(VOStageCommitGet.getAll());
}
