import 'package:flutter/material.dart';
import 'package:image_search/package/kakao_api.dart';
import 'package:image_search/model/vo.dart';
import 'package:image_search/model/hive_controle.dart';

class GetVoFromKakao {
  final String REST_key;
  bool isImageVO;
  KakaoAPI? kakaoAPI;
  final int size;
  GetVoFromKakao(this.REST_key, this.isImageVO, this.size);

  Future<List?> searchFirst(String keyword) async {
    // if searchFirst already called, function should not be called.
    if (kakaoAPI != null) {
      return null;
    }
    // set the kakaoAPI instance
    if (isImageVO) {
      kakaoAPI = KakaoImageAPI(REST_key, keyword, size);
      final kakaoImageAPI = kakaoAPI as KakaoImageAPI;

      var resultMapList = kakaoImageAPI.Next();

      return resultMapList.then((mapList) {
        if (mapList == null) {
          return null;
        }
        List<ImageVO> voList = [];
        mapList.forEach((map) {
          var newVO = ImageVO(map["doc_url"]!, DateTime.parse(map["datetime"]!), map["thumbnail_url"]!, map["image_url"]!, map["name"]!);
          voList.add(newVO);
        });
        return voList;
      });
    } else {
      kakaoAPI = KakaoWebAPI(REST_key, keyword, size);
      final kakaoWebAPI = kakaoAPI as KakaoWebAPI;

      var resultMapList = kakaoWebAPI.Next();

      return resultMapList.then((mapList) {
        if (mapList == null) {
          return null;
        }
        List<WebVO> voList = [];
        mapList.forEach((map) {
          var newVO = WebVO(map["url"]!, DateTime.parse(map["datetime"]!), map["title"]!, map["contents"]!);
          voList.add(newVO);
        });
        return voList;
      });
    }
  }

  Future<List?> searchNext() async {
    // if searchFirst() ever called even once, return null.
    if (kakaoAPI == null) {
      return null;
    }

    // set the kakaoAPI instance
    if (isImageVO) {
      final kakaoImageAPI = kakaoAPI as KakaoImageAPI;

      var resultMapList = kakaoImageAPI.Next();

      return resultMapList.then((mapList) {
        if (mapList == null) {
          return null;
        }
        List<ImageVO> voList = [];
        mapList.forEach((map) {
          var newVO = ImageVO(map["doc_url"]!, DateTime.parse(map["datetime"]!), map["thumbnail_url"]!, map["image_url"]!, map["name"]!);
          voList.add(newVO);
        });
        return voList;
      });
    } else {
      final kakaoWebAPI = kakaoAPI as KakaoWebAPI;

      var resultMapList = kakaoWebAPI.Next();

      return resultMapList.then((mapList) {
        if (mapList == null) {
          return null;
        }
        List<WebVO> voList = [];
        mapList.forEach((map) {
          var newVO = WebVO(map["url"]!, DateTime.parse(map["datetime"]!), map["title"]!, map["contents"]!);
          voList.add(newVO);
        });
        return voList;
      });
    }
  }
}

enum StagedType { insert, delete }

class VOStageCommit {
  /// this field's children are:
  /// [enum StagedType, VO vo]
  /// for the which vo to stage, and which action to perform.
  static List<List> stagedList = [];
  static HIVEController hiveController = HIVEController();

  static void insertVO(dynamic vo) {
    // check if vo is imageVO or WebVO
    if ((vo is! VO)) {
      throw Exception("vo must be the imageVO or WebVO");
    }

    // search if there are some VO already inserted/deleted before.
    for (int i = 0; i < stagedList.length; i++) {
      var stage = stagedList[i];
      final VO stagedVO = stage[1];
      final StagedType stageType = stage[0];
      if (stagedVO.url == vo.url && stagedVO.isImageVO == vo.isImageVO) {
        // this means there already staged action for this vo.
        if (stageType == StagedType.insert) {
          continue;
        } else {
          stagedList.removeAt(i);
          i--;
          continue;
        }
      } else {
        // this means vo is new for stagedList.
        stagedList.add([StagedType.insert, vo]);
      }
    }
  }

  static void deleteVO(dynamic vo) {
    // check if vo is imageVO or WebVO
    if ((vo is! VO)) {
      throw Exception("vo must be the imageVO or WebVO");
    }

    // search if there are some VO already inserted/deleted before.
    for (int i = 0; i < stagedList.length; i++) {
      final VO stagedVO = stagedList[i][1];
      final StagedType stageType = stagedList[i][0];
      if (stagedVO.url == vo.url && stagedVO.isImageVO == vo.isImageVO) {
        // this means there already staged action for this vo.
        if (stageType == StagedType.delete) {
          continue;
        } else {
          stagedList.removeAt(i);
          i--;
          continue;
        }
      } else {
        // this means vo is new for stagedList.
        stagedList.add([StagedType.delete, vo]);
      }
    }
  }

  static void commit() {
    for (int i = 0; i < stagedList.length; i++) {
      final VO stagedVO = stagedList[i][1];
      final StagedType stageType = stagedList[i][0];
      if (stageType == StagedType.insert) {
        hiveController.insertVO(stagedVO);
      } else {
        hiveController.deleteVO(stagedVO);
      }
    }
  }
}
