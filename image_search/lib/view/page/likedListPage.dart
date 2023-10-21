import 'package:flutter/material.dart';
import 'package:image_search/package/debugConsole.dart';
import 'package:image_search/view/static/myOrdinaryStyle.dart';
import 'package:image_search/model/vo.dart';
import 'package:image_search/controller/vo_controle.dart';
import 'package:like_button/like_button.dart';

class LikedListPage extends StatefulWidget {
  const LikedListPage({Key? key}) : super(key: key);

  @override
  State<LikedListPage> createState() => _LikedListPageState();
}

class _LikedListPageState extends State<LikedListPage> {
  final List<WebVO> _contentVOList = [
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false)
  ];

  final _dropDownTextList = const ["전체", "이미지", "내용"];
  int _dropDownSelection = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        appBar(),
        choice(),
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
      scrolledUnderElevation: 0,
    );
  }

  void onChanged(dynamic index) {
    setState(() {
      debugConsole(index);
      _dropDownSelection = index;
    });
    // TODO:
  }

  Widget choice() {
    List<DropdownMenuItem> dropDownMenuItemList = [];
    for (int i = 0; i < _dropDownTextList.length; i++) {
      final item = DropdownMenuItem(
        child: Text(_dropDownTextList[i]),
        value: i,
      );
      dropDownMenuItemList.add(item);
    }
    final dropDownMenu = Container(
        width: 250,
        padding: const EdgeInsets.only(right: 20),
        child: DropdownButton(
          value: _dropDownSelection,
          items: dropDownMenuItemList,
          onChanged: onChanged,
        ));
    return Container(
        // color: Colors.black12,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: dropDownMenu);
  }

  Widget webVOtoListViewItem(WebVO vo) {
    final contents = Container(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        vo.contents,
        maxLines: 4,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );

    final itemDescription = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              "${vo.dateTime.year}년 ${vo.dateTime.month}월 ${vo.dateTime.day}일",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              vo.url,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
          children: [Expanded(flex: 4, child: contents), Flexible(flex: 4, child: itemDescription), Flexible(flex: 1, child: likeButton)],
        ),
      ),
    );

    // return GestureDetector(
    //   onTap: () {
    //     Navigator.pushNamed(context, WebDetail.routeName, arguments: WebDetailArguments(vo));
    //   },
    //   child: Padding(
    //     padding: const EdgeInsets.all(8.0),
    //     child: Container(
    //       decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
    //       margin: const EdgeInsets.all(8.0),
    //       child: Row(
    //         children: [Expanded(flex: 4, child: contents), Flexible(flex: 4, child: itemDescription), Flexible(flex: 1, child: likeButton)],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget listView() {
    final contentWidgetList = _contentVOList.map((vo) => webVOtoListViewItem(vo)).toList();

    final listView = ListView(
      children: contentWidgetList,
    );

    return Expanded(child: listView);
  }
}
