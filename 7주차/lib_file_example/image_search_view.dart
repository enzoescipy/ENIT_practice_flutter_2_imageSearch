import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled/constants.dart';
import 'package:untitled/model/image_model.dart';

class ImageSearchView extends StatefulWidget {
  const ImageSearchView({super.key});

  @override
  State<ImageSearchView> createState() => _ImageSearchViewState();
}
class _ImageSearchViewState extends State<ImageSearchView> {
  List data = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("IMAGE"),),
      body: TextButton(
          child: Column(
            children: [
              Text("INSERT"),
            ],
          ),
          onPressed: () async{


            Constants.prefs.setString("abc", "abc12312312");

            print(Constants.prefs.getString("abc"));


            String favoriteStr = Constants.prefs.getString(Constants.FAVORITE) ?? "";

            ArticleModel articleModel = ArticleModel();
            articleModel.name = "홍길동";
            articleModel.date = "2023";
            articleModel.siteName = "naver";

            /// encode
            favoriteStr = json.encode(articleModel.toJson());
            Constants.prefs.setString(Constants.FAVORITE, favoriteStr);

            String favoriteStr1 = Constants.prefs.getString(Constants.FAVORITE) ?? "";
            print(favoriteStr1);

            /// decode
            ArticleModel articleModel1 = ArticleModel.fromJson(json.decode(favoriteStr1));
            print(articleModel1.name);
            print(articleModel1.date);
            print(articleModel1.siteName);
          },)
    );
  }
}



