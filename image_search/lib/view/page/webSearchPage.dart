import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_search/view/static/myOrdinaryStyle.dart';
import 'package:image_search/package/debugConsole.dart';
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
  final List<WebVO> _contentVOList = [];
  final List<Widget> _contentWidgetList = [];
  GetVoFromKakao? _kakaoInstance;
  String? _currentKeyword;
  bool _isListViewShouldReLoad = false;

  ScrollController _listViewScrollController = ScrollController();
  TextEditingController _searchTextController = TextEditingController();

  Widget listView() {
    if (_kakaoInstance == null) {
      if (_currentKeyword == null) {
        // no keyword found : just return the empty view
        return Expanded(child: ListView());
      } else {
        // keyword exists but no kakaoInstance : kakaoInstance.searchFirst should be fired.
        // also, erase the initialoffset of scroll controller.
        _listViewScrollController = ScrollController();
        _listViewScrollController.addListener(onScrollReachedEnd);
        _kakaoInstance = GetVoFromKakao(_currentKeyword!, false, 10);
        return FutureBuilder(
          future: _kakaoInstance!.searchFirst(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Component.loadingWidgetItem()],
                  ),
                );
              case ConnectionState.waiting:
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Component.loadingWidgetItem()],
                  ),
                );
              case ConnectionState.active:
                final appendListVO = (snapshot.data ?? []) as List<WebVO>;
                final contentWidgetList = _contentWidgetList + appendListVO.map((vo) => Component.webVOtoListViewItem(vo, context)).toList();
                return Expanded(
                  child: ListView(
                    controller: _listViewScrollController,
                    children: contentWidgetList,
                  ),
                );
              case ConnectionState.done:
                debugConsole((snapshot.data ?? []));
                final appendListVO = (snapshot.data ?? []) as List<WebVO>;
                _contentVOList.addAll(appendListVO);
                _contentWidgetList.addAll(appendListVO.map((vo) => Component.webVOtoListViewItem(vo, context)).toList());
                return Expanded(
                  child: ListView(
                    controller: _listViewScrollController,
                    children: _contentWidgetList,
                  ),
                );
            }
          },
        );
      }
    } else if (_isListViewShouldReLoad == true) {
      debugConsole("searchNext fire!");
      // this means that some "watching needed" view had reached its end position.
      // so, we should get the kakaoInstance.searchNext() then re-build the view.

      // turn off the _isListViewShouldReLoad
      _isListViewShouldReLoad = false;
      // build the view.
      return Expanded(
          child: FutureBuilder(
        future: _kakaoInstance!.searchNext(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Flexible(
                  child: ListView(
                    controller: _listViewScrollController,
                    children: _contentWidgetList,
                  ),
                ),
                Component.loadingWidgetItem()
              ],
            );
          } else {
            if (snapshot.data == null) {
              // kakaoInstance reached its maximum page : just build view from the _contentVOList.
              return ListView(
                children: _contentWidgetList,
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              final appendListVO = (snapshot.data ?? []) as List<WebVO>;
              final contentWidgetList = _contentWidgetList + appendListVO.map((vo) => Component.webVOtoListViewItem(vo, context)).toList();
              final resultListView = ListView(
                controller: _listViewScrollController,
                children: contentWidgetList,
              );
              return resultListView;
            } else {
              // case snapshot.connectionState == ConnectionState.done
              final appendListVO = (snapshot.data ?? []) as List<WebVO>;
              _contentVOList.addAll(appendListVO);
              _contentWidgetList.addAll(appendListVO.map((vo) => Component.webVOtoListViewItem(vo, context)).toList());
              final resultListView = ListView(
                controller: _listViewScrollController,
                children: _contentWidgetList,
              );
              return resultListView;
            }
          }
        },
      ));
    } else {
      // kakaoInstance exists : just build view from the _contentVOList.
      return Expanded(
          child: ListView(
        controller: _listViewScrollController,
        children: _contentWidgetList,
      ));
    }
  }

  void onScrollReachedEnd() {
    if (_listViewScrollController.position.atEdge) {
      bool isTop = _listViewScrollController.position.pixels == 0;
      final scrollPositionSaved = _listViewScrollController.position.pixels;
      if (isTop == false) {
        // is bot.
        _listViewScrollController = ScrollController(initialScrollOffset: scrollPositionSaved);
        _listViewScrollController.addListener(onScrollReachedEnd);
        setState(() {
          _isListViewShouldReLoad = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _listViewScrollController.addListener(onScrollReachedEnd);
  }

  @override
  void dispose() {
    _listViewScrollController.dispose();
    super.dispose();
  }

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
    final text = _searchTextController.text.replaceAll(RegExp(r"[ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]"), "");
    if (text.isEmpty) {
      return;
    }
    if (_currentKeyword != null) {
      VOStageCommitGet.commit();
    }
    setState(() {
      _currentKeyword = text;
      _kakaoInstance = null;
      _contentVOList.clear();
      _contentWidgetList.clear();
    });
  }

  Widget search() {
    final textField = Container(
      width: 250,
      padding: const EdgeInsets.only(right: 20),
      child: TextField(
        maxLines: 1,
        controller: _searchTextController,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'))],
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
