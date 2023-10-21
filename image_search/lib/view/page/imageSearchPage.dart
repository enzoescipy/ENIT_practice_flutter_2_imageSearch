import 'package:flutter/material.dart';
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
final List<ImageVO> _contentVOList = [
    getDebugVO(true),
    getDebugVO(true),
    getDebugVO(true),
    getDebugVO(true),
    getDebugVO(true),
    getDebugVO(true),
    getDebugVO(true),
    getDebugVO(true)
  ];
  Widget listView() {
    final contentWidgetList = _contentVOList.map((vo) => Component.imageVOtoListViewItem(vo, context)).toList();

    final listView = ListView(
      children: contentWidgetList,
    );

    return Expanded(child: listView);
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
    // TODO:
  }

  Widget search() {
    final textField = Container(
      width: 250,
      padding: const EdgeInsets.only(right: 20),
      child: TextField(
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
    final img = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.network(url)),
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
