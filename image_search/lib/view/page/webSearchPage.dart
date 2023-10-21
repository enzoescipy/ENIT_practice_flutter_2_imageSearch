import 'package:flutter/material.dart';
import 'package:image_search/view/static/myOrdinaryStyle.dart';
import 'package:image_search/model/vo.dart';
import 'package:image_search/controller/vo_controle.dart';
import 'package:like_button/like_button.dart';

import 'package:image_search/view/component/component.dart' as Component;

class WebSearchPage extends StatefulWidget {
  const WebSearchPage({Key? key}) : super(key: key);

  @override
  State<WebSearchPage> createState() => _WebSearchPageState();
}

class _WebSearchPageState extends State<WebSearchPage> {
  final List<WebVO> _contentVOList = [
    getDebugVO(false,isLiked:true),
    getDebugVO(false,isLiked:true),
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false),
    getDebugVO(false)
  ];

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
      scrolledUnderElevation: 0,
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


  Widget listView() {
    final contentWidgetList = _contentVOList.map((vo) => Component.webVOtoListViewItem(vo, context)).toList();

    final listView = ListView(
      children: contentWidgetList,
    );

    return Expanded(child: listView);
  }
}

class WebDetailArguments {
  final WebVO webVO;
  WebDetailArguments(this.webVO);
}

class WebDetail extends StatelessWidget {
  const WebDetail({super.key});

  static const routeName = '/WebDetail';

  @override
  Widget build(BuildContext context) {
    WebVO webVO = (ModalRoute.of(context)!.settings.arguments as WebDetailArguments).webVO;

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          appBar(context),
          description(context, webVO),
        ],
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return AppBar(
      title: Container(
        width: 350,
        height: 30,
        alignment: Alignment.center,
        decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
        child: Text(
          "이미지 상세",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
    );
  }

  Widget description(BuildContext context, WebVO webVO) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              webVO.title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              webVO.dateTime.toIso8601String(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              webVO.url,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              webVO.contents,
              overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
