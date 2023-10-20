import 'package:flutter/material.dart';
import 'package:image_search/view/static/myOrdinaryStyle.dart';
import 'package:image_search/model/vo.dart';
import 'package:image_search/controller/vo_controle.dart';
import 'package:like_button/like_button.dart';

class WebSearchPage extends StatefulWidget {
  const WebSearchPage({Key? key}) : super(key: key);

  @override
  State<WebSearchPage> createState() => _WebSearchPageState();
}

class _WebSearchPageState extends State<WebSearchPage> {
  final List<WebVO> _contentVOList = [getDebugVO(false),getDebugVO(false),getDebugVO(false),getDebugVO(false),getDebugVO(false), getDebugVO(false), getDebugVO(false), getDebugVO(false)];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appBar(),
        search(),
        listView(),
      ],
    );
  }

  Widget appBar() {
    return AppBar(
      title: Container(
        width: 350,
        height: 30,
        alignment: Alignment.center,
        decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
        child: Text(
          "내용 검색",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      centerTitle: true,
    );
  }

  void onSubmit() {
    // TODO:
  }

  Widget search() {
    final textField = Container(
      width: 250,
      padding: const EdgeInsets.only(right: 20),
      child: TextField(
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );

    final submit = ElevatedButton(
      onPressed: onSubmit,
      child: const Icon(Icons.search),
    );

    return Container(
      // color: Colors.black12,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textField,
          submit,
        ],
      ),
    );
  }

  Widget webVOtoListViewItem(WebVO vo) {
    final contents = Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(vo.contents,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,),
    );

    final itemDescription = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:3.0),
            child: Text("${vo.dateTime.year}년 ${vo.dateTime.month}월 ${vo.dateTime.day}일",
            style: Theme.of(context).textTheme.bodyMedium,),
          ),
          Padding(
            padding: const EdgeInsets.only(top:3.0),
            child: Text(vo.url,
            style: Theme.of(context).textTheme.bodyMedium,),
          ),
        ],
      ),
    );
    final likeButton = LikeButton();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: [Expanded(flex:4, child: contents), Flexible(flex:4, child: itemDescription), Flexible(flex:1, child: likeButton)],
        ),
      ),
    );
  }

  Widget listView() {
    final contentWidgetList = _contentVOList.map((vo) => webVOtoListViewItem(vo)).toList();

    final listView = ListView(
      children: contentWidgetList,
    );

    return Expanded(child: listView);
  }
}

