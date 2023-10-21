import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_search/package/debugConsole.dart';
import 'package:image_search/view/static/myOrdinaryStyle.dart';
import 'package:image_search/model/vo.dart';
import 'package:image_search/controller/vo_controle.dart';
import 'package:like_button/like_button.dart';
import 'package:photo_view/photo_view.dart';

import 'package:image_search/view/component/component.dart' as Component;

class ImageSearchPage extends StatefulWidget {
  const ImageSearchPage({Key? key}) : super(key: key);

  @override
  State<ImageSearchPage> createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  final List<ImageVO> _contentVOList = [];
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
        _kakaoInstance = GetVoFromKakao(_currentKeyword!, true, 10);
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
                final appendListVO = (snapshot.data ?? []) as List<ImageVO>;
                final contentWidgetList = _contentWidgetList + appendListVO.map((vo) => Component.imageVOtoListViewItem(vo, context)).toList();
                return Expanded(
                  child: ListView(
                    controller: _listViewScrollController,
                    children: contentWidgetList,
                  ),
                );
              case ConnectionState.done:
                final appendListVO = (snapshot.data ?? []) as List<ImageVO>;
                _contentVOList.addAll(appendListVO);
                _contentWidgetList.addAll(appendListVO.map((vo) => Component.imageVOtoListViewItem(vo, context)).toList());
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
              final appendListVO = (snapshot.data ?? []) as List<ImageVO>;
              final contentWidgetList = _contentWidgetList + appendListVO.map((vo) => Component.imageVOtoListViewItem(vo, context)).toList();
              final resultListView = ListView(
                controller: _listViewScrollController,
                children: contentWidgetList,
              );
              return resultListView;
            } else {
              // case snapshot.connectionState == ConnectionState.done
              final appendListVO = (snapshot.data ?? []) as List<ImageVO>;
              _contentVOList.addAll(appendListVO);
              _contentWidgetList.addAll(appendListVO.map((vo) => Component.imageVOtoListViewItem(vo, context)).toList());
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
          "이미지 검색",
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
        controller: _searchTextController,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'))],
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
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

class ImageDetailArguments {
  final ImageVO imageVO;
  ImageDetailArguments(this.imageVO);
}

class ImageDetail extends StatelessWidget {
  const ImageDetail({super.key});

  static const routeName = '/ImageDetail';

  @override
  Widget build(BuildContext context) {
    ImageVO imageVO = (ModalRoute.of(context)!.settings.arguments as ImageDetailArguments).imageVO;

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          appBar(context),
          image(context, imageVO.imageURL),
          description(context, imageVO),
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

  Widget image(BuildContext context, String url) {
    final img = Container(
      padding: const EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height * 0.6,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            url,
            fit: BoxFit.cover,
          )),
    );
    return GestureDetector(
      child: img,
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Stack(children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: PhotoView(
                      imageProvider: NetworkImage(url),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    )),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    child: Text(
                      "X",
                      style: TextStyle(
                        fontFamily: "Tmoney",
                        color: const Color.fromARGB(255, 255, 105, 94),
                        fontSize: 40,
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                )
              ]);
            });
      },
    );
  }

  Widget description(BuildContext context, ImageVO imageVO) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              imageVO.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              imageVO.dateTime.toIso8601String(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              imageVO.url,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
