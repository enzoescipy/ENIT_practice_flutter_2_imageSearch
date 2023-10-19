import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/article_item.dart';

class ArticleSearchView extends StatefulWidget {
  const ArticleSearchView({super.key});

  @override
  State<ArticleSearchView> createState() => _ArticleSearchViewState();
}
class _ArticleSearchViewState extends State<ArticleSearchView> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(title: Text("IMAGE"),),
        body: FutureBuilder(
            future:getJSONData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  return Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ArticleItem(snapshot: snapshot, index: index);
                        }),
                  );
              }
            }
        )
    );
  }

  Future<List> getJSONData() async {
    var url = Uri.parse('https://dapi.kakao.com/v2/search/web?query=호랑이');
    var response = await http.get(url, headers: {"Authorization": "KakaoAK 574d2235c0f9943528e999e640414ac4"});

    var dataConvertedToJSON = json.decode(response.body);
    List result = dataConvertedToJSON["documents"];

    return result;
  }
}


