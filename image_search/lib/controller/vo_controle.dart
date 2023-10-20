import 'package:flutter/material.dart';
import 'package:image_search/package/debugConsole.dart';
import 'package:image_search/package/kakao_api.dart';
import 'package:image_search/model/vo.dart';
import 'package:image_search/model/hive_controle.dart';

class GetVoFromKakao {
  final String REST_key;
  bool isImageVO;
  KakaoAPI? kakaoAPI;
  final int size;

  GetVoFromKakao(this.REST_key, this.isImageVO, this.size);

  /// return the list of VO from keyword, kakao api.
  /// purposed for the first call
  /// null for the,
  ///   - repeated call deny
  ///   - page reached its limitation
  ///   - invalid response (mainly wrong password or option)
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
          // debugMap(map);
          var newVO = ImageVO(map["doc_url"]!, map["datetime"]!, map["thumbnail_url"]!, map["image_url"]!, map["name"]!);
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
          var newVO = WebVO(map["url"]!, map["datetime"]!, map["title"]!, map["contents"]!);
          voList.add(newVO);
        });
        return voList;
      });
    }
  }

  /// return the list of VO from keyword, kakao api.
  /// purposed for the next calls.
  /// null for the,
  ///   - not called searchFirst() deny
  ///   - page reached its limitation
  ///   - invalid response (mainly wrong password or option)
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
          var newVO = ImageVO(map["doc_url"]!, map["datetime"]!, map["thumbnail_url"]!, map["image_url"]!, map["name"]!);
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
          var newVO = WebVO(map["url"]!, map["datetime"]!, map["title"]!, map["contents"]!);
          voList.add(newVO);
        });
        return voList;
      });
    }
  }
}

int _debugCount = 9;

/// make the debug-only meaningless VO object.
dynamic getDebugVO(bool isImageVO) {
  _debugCount++;
  if (_debugCount > 100) {
    throw Exception("no over 90 debug Obj not allowed");
  }
  if (isImageVO) {
    return ImageVO(
        "$_debugCount url",
        "20${_debugCount.toString()}.11.22",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu_lrik6ff2CC0Og2xVh6iwQHo-S-JTFHGvw&usqp=CAU",
        "https://www.cnet.com/a/img/resize/6bff5bab34782dfb1b316eb9b186d749060ff47d/hub/2021/06/04/00f4dd44-e56e-4097-bb8b-8be5f27ae7b6/percymarsbuttcrackrock.jpg?auto=webp&fit=crop&height=675&width=1200",
        "test $_debugCount");
  } else {
    return WebVO("$_debugCount url", "20${_debugCount.toString()}.11.22", "$_debugCount title", "$_debugCount contents");
  }
}

enum StagedType { insert, delete }

class VOStageCommitGet {
  /// this field's children are:
  /// [enum StagedType, VO vo]
  /// for the which vo to stage, and which action to perform.
  static List<List> stagedList = [];

  static void insertVO(dynamic vo) {
    // check if vo is imageVO or WebVO
    if ((vo is! VO)) {
      throw Exception("vo must be the imageVO or WebVO");
    }

    // search if there are some VO already inserted/deleted before.
    bool isAlreadyVOStaged = false;
    for (int i = 0; i < stagedList.length; i++) {
      var stage = stagedList[i];
      final VO stagedVO = stage[1];
      final StagedType stageType = stage[0];
      if (stagedVO.url == vo.url && stagedVO.isImageVO == vo.isImageVO) {
        // this means there already staged action for this vo.
        isAlreadyVOStaged = true;
        if (stageType == StagedType.delete) {
          stagedList.removeAt(i);
          i--;
        }
        break;
      }
    }

    if (isAlreadyVOStaged == false) {
      stagedList.add([StagedType.insert, vo]);
    }
  }

  static void deleteVO(dynamic vo) {
    // check if vo is imageVO or WebVO
    if ((vo is! VO)) {
      throw Exception("vo must be the imageVO or WebVO");
    }

    // search if there are some VO already inserted/deleted before.
    bool isAlreadyVOStaged = false;
    for (int i = 0; i < stagedList.length; i++) {
      final VO stagedVO = stagedList[i][1];
      final StagedType stageType = stagedList[i][0];
      if (stagedVO.url == vo.url && stagedVO.isImageVO == vo.isImageVO) {
        // this means there already staged action for this vo.
        isAlreadyVOStaged = true;
        if (stageType == StagedType.insert) {
          stagedList.removeAt(i);
          i--;
        }
        break;
      }
    }
    if (isAlreadyVOStaged == false) {
      // this means vo is new for stagedList.
      stagedList.add([StagedType.delete, vo]);
    }
  }

  static void commit() {
    debugConsole(stagedList);
    for (int i = 0; i < stagedList.length; i++) {
      final VO stagedVO = stagedList[i][1];
      final StagedType stageType = stagedList[i][0];
      if (stageType == StagedType.insert) {
        HIVEController.insertVO(stagedVO);
      } else {
        HIVEController.deleteVO(stagedVO);
      }
    }
  }

  /// get the all of VO , by decending order of likeOrder.
  static List getAll() {
    // debugConsole("getAll called");
    // get and convert
    final mapListAll = HIVEController.getAll(null);
    var voListAll = [];
    mapListAll.forEach((map) {
      if (map["isImageVO"] == true) {
        // debugConsole(map["dateTime"]!);
        var newVO = ImageVO(map["url"]!, map["dateTime"]!, map["thumbnailURL"]!, map["imageURL"]!, map["name"]!);
        voListAll.add(newVO);
      } else {
        var newVO = WebVO(map["url"]!, map["dateTime"]!, map["title"]!, map["contents"]!);
        voListAll.add(newVO);
      }
    });

    voListAll.sort((a, b) => a.likeOrder.compareTo(b.likeOrder));
    return voListAll;
  }

  static List getImageVoAll() {
    // get and convert
    final mapListAll = HIVEController.getAll(true);
    var voListAll = [];
    mapListAll.forEach((map) {
      if (map["isImageVO"] == true) {
        var newVO = ImageVO(map["doc_url"]!, map["datetime"]!, map["thumbnail_url"]!, map["image_url"]!, map["name"]!);
        voListAll.add(newVO);
      }
    });

    voListAll.sort((a, b) => a.likeOrder.compareTo(b.likeOrder));
    return voListAll;
  }

  static List getWebVoAll() {
    // get and convert
    final mapListAll = HIVEController.getAll(false);
    var voListAll = [];
    mapListAll.forEach((map) {
      if (map["isImageVO"] == false) {
        var newVO = WebVO(map["url"]!, map["datetime"]!, map["title"]!, map["contents"]!);
        voListAll.add(newVO);
      }
    });

    voListAll.sort((a, b) => a.likeOrder.compareTo(b.likeOrder));
    return voListAll;
  }
}
