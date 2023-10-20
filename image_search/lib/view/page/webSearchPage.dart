import 'package:flutter/material.dart';

class WebSearchPage extends StatefulWidget {
  const WebSearchPage({Key? key}) : super(key: key);

  @override
  State<WebSearchPage> createState() => _WebSearchPageState();
}

class _WebSearchPageState extends State<WebSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "WebSearchPage",
      style: TextStyle(fontSize: 100),
    );
  }
}
