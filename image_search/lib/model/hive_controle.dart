import 'package:flutter/material.dart';
import 'package:image_search/model/vo.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// RULE : DO NOT USE the box.put() for insertion.
/// only use the box.add() for insertion. (however update or override, put() can be used.)
/// from that rule, the key will be set auto-increase by hive.

class HIVEController {
  static Box<Map>? box;
  static const mainBoxName = "main";

  static int likeOrder = -1;

  /// this asynchronous function must be called and returned before calling other function.
  static Future<void> initializeHive() async {
    box = await Hive.openBox<Map>(mainBoxName);
  }

  static Future<void> clearHive() async {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }
    await box?.clear();
  }

  static Map? getSingleVO(dynamic key) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }

    return box!.get(key);
  }

  /// get the all of vo from the box.
  /// if param is true or false,
  ///   - true : get only for image VO.
  ///   - false : get only for web VO.
  static List getAll(bool? isImageVO) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }

    if (isImageVO == null) {
      return box!.values.toList();
    } else if (isImageVO == true) {
      return box!.values.where((map) => map["isImageVO"] == true).toList();
    } else {
      return box!.values.where((map) => map["isImageVO"] == false).toList();
    }
  }

  /// find and return VO Key by its url and isImageVO.
  /// Return:
  ///   unsigned int : object found.
  ///   null : object not found.
  static int? findVOKeybyURL(String url, bool isImageVO) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }
    List<int> keyList = [];
    var boxKeyList = box!.keys.toList();

    for (int i = 0; i < box!.keys.length; i++) {
      final key = boxKeyList[i];
      final voMap = box!.get(key);
      if (voMap == null) {
        continue;
      }
      if (voMap["url"] == url && voMap["isImageVO"] == isImageVO) {
        return key;
      }
    }
    return null;
  }

  /// insert, or update the ImageVO in the hive box.
  /// in this case, likeOrder of vo is defined automatically by controller.
  /// (inserting vo will reguarded as being liked)
  /// and, likeOrder will be always >= 0.
  static void insertVO(VO vo) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }

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
      voMap["dateTime"] = imageVO.dateTime.toString();
      voMap["thumbnailURL"] = imageVO.thumbnailURL;
      voMap["imageURL"] = imageVO.imageURL;
      voMap["name"] = imageVO.name;
    } else {
      WebVO webVO = vo as WebVO;
      voMap["dateTime"] = webVO.dateTime.toString();
      voMap["title"] = webVO.title;
      voMap["contents"] = webVO.contents;
    }

    // put voMap in the box
    // if vo already exists, override that.
    if (key != null) {
      box!.put(key, voMap);
      return;
    }
    box!.add(voMap);
  }

  static void deleteVO(VO vo) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }

    // search if there are already vo inside the hive box.
    final key = findVOKeybyURL(vo.url, vo.isImageVO);
    if (key != null) {
      box!.delete(key);
    }
  }
}
