import 'package:flutter/material.dart';

class LikedListPage extends StatefulWidget {
  const LikedListPage({Key? key}) : super(key: key);

  @override
  State<LikedListPage> createState() => _LikedListPageState();
}

class _LikedListPageState extends State<LikedListPage> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "LikedListPage",
      style: TextStyle(fontSize: 100),
    );
  }
}
