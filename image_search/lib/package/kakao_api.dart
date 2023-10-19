import 'dart:convert';
import 'package:image_search/package/debugConsole.dart';
import 'package:http/http.dart' as http;

class KakaoAPI {
  // loginHeaderMap = {"Authorization": "KakaoAK 17d7e0a3463cf55e47156470a53522bf"};
  late final basicURL; // = "https://dapi.kakao.com/v2/search/image?";
  late Map<String, String> loginHeaderMap;
  late String keyword;
  late final size;
  int page = 0;
  bool isReachedEnd = false;

}

class KakaoWebAPI extends KakaoAPI {
  KakaoWebAPI(String REST_key, String keyword, int size) {
    basicURL = "https://dapi.kakao.com/v2/search/web?";
    loginHeaderMap = {"Authorization": "KakaoAK $REST_key"};
    if (keyword.length < 0 || !(0 < size || size <= 50)) {
      throw Exception();
    }

    this.keyword = keyword;
    this.size = size;
  }

  /// get the next page from kakao image api.
  /// return the map that thas:
  ///   - datetime : creation datetime
  ///   - contents : string content of document
  ///   - title : string title of document
  Future<List<Map<String, String>>?> Next() async {
    // validate the current page
    if (page > 50) {
      return null;
    }
    // increase the paging
    page++;

    // get the main body of response
    var url = Uri.parse('${basicURL}query=$keyword&page=$page&size=$size');
    var res = http.get(url, headers: loginHeaderMap);

    return res.then((response) {
      var dataConvertedToJSON = json.decode(response.body);
      final List convertedJSON = dataConvertedToJSON["documents"];
      // get the doc_text, and make the map object list
      List<Map<String, String>> correctedMapList = [];
      convertedJSON.forEach((row) {
        final Map<String, String> correctedRow = {
          "url": row["url"],
          "datetime": row["datetime"],
          "title": row["title"],
          "contents": row["contents"],
        };
        correctedMapList.add((correctedRow));
      });
      return correctedMapList;
    });
  }
}

class KakaoImageAPI extends KakaoAPI {
  KakaoImageAPI(String REST_key, String keyword, int size) {
    // loginHeaderMap = {"Authorization": "KakaoAK 17d7e0a3463cf55e47156470a53522bf"};
    basicURL = "https://dapi.kakao.com/v2/search/image?";
    loginHeaderMap = {"Authorization": "KakaoAK $REST_key"};
    if (keyword.length < 0 || !(0 < size || size <= 80)) {
      throw Exception();
    }

    this.keyword = keyword;
    this.size = size;
  }

  /// get the next page from kakao image api.
  /// return the map that thas:
  ///   - thumbnail_url : link of thumbnail
  ///   - image_url : link of image
  ///   - dateTime : creation datetime
  ///   - name : name of image
  ///   - doc_url : source of image
  Future<List<Map<String, String>>?> Next() async {
    // validate the current page
    if (page > 50) {
      return null;
    }
    // increase the paging
    page++;

    // get the main body of response
    var url = Uri.parse('${basicURL}query=$keyword&page=$page&size=$size');
    var res = http.get(url, headers: loginHeaderMap);

    return res.then((response) {
      var dataConvertedToJSON = json.decode(response.body);
      final List convertedJSON = dataConvertedToJSON["documents"];
      // get the doc_text, and make the map object list
      List<Map<String, String>> correctedMapList = [];
      convertedJSON.forEach((row) {
        final Map<String, String> correctedRow = {
          "doc_url": row["doc_url"],
          "datetime": row["datetime"],
          "thumbnail_url": row["thumbnail_url"],
          "image_url": row["image_url"],
          "name": row["display_sitename"] + " " + keyword,
        };
        correctedMapList.add((correctedRow));
      });
      return correctedMapList;
    });
  }
}
