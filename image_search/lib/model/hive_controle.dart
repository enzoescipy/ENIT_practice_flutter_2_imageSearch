import 'package:flutter/material.dart';
import 'package:image_search/model/vo.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// RULE : DO NOT USE the box.put() for insertion.
/// only use the box.add() for insertion. (however update or override, put() can be used.)
/// from that rule, the key will be set auto-increase by hive.
class HIVEController {
  static late Box<Map> box;
  static const mainBoxName = "main";

  static int likeOrder = -1;
  HIVEController() {
    _initializeHive();
  }

  static void _initializeHive() async {
    box = await Hive.openBox<Map>(mainBoxName);
  }

  /// find and return VO Key by its url and isImageVO.
  /// Return:
  ///   unsigned int : object found.
  ///   null : object not found.
  int? findVOKeybyURL(String url, bool isImageVO) {
    List<int> keyList = [];
    box.keys.forEach((key) {
      final voMap = box.get(key);
      if (voMap == null) {
        return;
      }
      if (voMap["url"] == url && voMap["isImageVO"] == isImageVO) {
        keyList.add(key);
      }
    });
    if (keyList.length > 1) {
      throw Exception("unexpected row has found : same url and isImageVO row cannot be at the DB.");
    } else if (keyList.isEmpty) {
      return null;
    } else {
      return keyList[0];
    }
  }

  /// insert, or update the ImageVO in the hive box.
  /// in this case, likeOrder of vo is defined automatically by controller.
  /// (inserting vo will reguarded as being liked)
  /// and, likeOrder will be always >= 0.
  void insertVO(VO vo) {
    // search if there are already vo inside the hive box.
    final key = findVOKeybyURL(vo.url, vo.isImageVO);
    // Auto increase the like order
    likeOrder++;
    // turn VO into the compatible Map object.
    final voMap = {
      "likeOrder": likeOrder,
      "isImageVO": vo.isImageVO,
      "url": vo.url,
    };

    if (vo.isImageVO == true) {
      ImageVO imageVO = vo as ImageVO;
      voMap["dateTime"] = imageVO.dateTime;
      voMap["thumbnailURL"] = imageVO.thumbnailURL;
      voMap["imageURL"] = imageVO.imageURL;
      voMap["name"] = imageVO.name;
    } else {
      WebVO webVO = vo as WebVO;
      voMap["dateTime"] = webVO.dateTime;
      voMap["title"] = webVO.title;
      voMap["contents"] = webVO.contents;
    }

    // put voMap in the box
    // if vo already exists, override that.
    if (key != null) {
      box.put(key, voMap);
    }
    box.add(voMap);
  }

  void deleteVO(VO vo) {
    // search if there are already vo inside the hive box.
    final key = findVOKeybyURL(vo.url, vo.isImageVO);
    if (key != null) {
      box.delete(key);
    }
  }
}
