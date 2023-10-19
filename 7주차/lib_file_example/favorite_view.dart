import 'package:flutter/material.dart';
import 'package:untitled/article_item.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}
class _FavoriteViewState extends State<FavoriteView> {
    @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("FAVORITE"),),
        body:Text("FAVORITE"),
        );

  }
}