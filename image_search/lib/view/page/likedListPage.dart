import 'package:flutter/material.dart';
import 'package:image_search/package/debugConsole.dart';
import 'package:image_search/view/static/myOrdinaryStyle.dart';
import 'package:image_search/model/vo.dart';
import 'package:image_search/controller/vo_controle.dart';
import 'package:like_button/like_button.dart';

import 'imageSearchPage.dart' as ImagePage;
import 'webSearchPAge.dart' as WebPage;

import 'package:image_search/view/component/component.dart' as Component;

class LikedListPage extends StatefulWidget {
  const LikedListPage({Key? key}) : super(key: key);

  @override
  State<LikedListPage> createState() => _LikedListPageState();
}

class _LikedListPageState extends State<LikedListPage> {
  final List<VO> _contentVOList = VOStageCommitGet.getAll();

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

  Widget listView() {
    final contentWidgetList = _contentVOList.where((vo) {
      if (vo is WebVO && (_dropDownSelection == 0 || _dropDownSelection == 2)) {
        return true;
      } else if (vo is ImageVO && (_dropDownSelection == 0 || _dropDownSelection == 1)) {
        return true;
      } else {
        return false;
      }
    }).map((vo) {
      Widget voToWidget;
      if (vo is WebVO) {
        voToWidget = Component.webVOtoListViewItem(vo, context);
      } else if (vo is ImageVO) {
        voToWidget = Component.imageVOtoListViewItem(vo, context);
      } else {
        throw Exception("어쩌피 이 메시지는 볼 일이 없겠지. 그러니 한마디 하겠다. 디버깅 이미지는 나사에서 발견한 엉덩이 모양 우주 바위이다!!");
      }
      return voToWidget;
    }).toList();

    final listView = ListView(
      children: contentWidgetList,
    );
    return Expanded(child: listView);
  }
}
