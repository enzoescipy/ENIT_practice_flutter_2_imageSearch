import 'package:flutter/material.dart';
import 'package:image_search/model/vo.dart';
import 'package:image_search/package/debugConsole.dart';
import 'package:like_button/like_button.dart';
import 'package:image_search/view/static/myOrdinaryStyle.dart';
import 'package:image_search/controller/vo_controle.dart';

import 'package:image_search/view/page/imageSearchPage.dart' as ImagePage;
import 'package:image_search/view/page/webSearchPage.dart' as WebPage;
import 'package:image_search/view/page/likedListPage.dart' as LikePage;

Future<bool> _changeIsLiked(status) async {
  return Future.value(!status);
}

Widget webVOtoListViewItem(WebVO vo, BuildContext context) {
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
  final likeButton = LikeButton(
    isLiked: vo.likeOrder < 0 ? false : true,
  );

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, WebPage.WebDetail.routeName, arguments: WebPage.WebDetailArguments(vo));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: [Expanded(flex: 4, child: contents), Flexible(flex: 4, child: itemDescription), Flexible(flex: 1, child: likeButton)],
        ),
      ),
    ),
  );
}

Widget imageVOtoListViewItem(ImageVO vo, BuildContext context) {
  final img = Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(borderRadius: BorderRadius.circular(8.0), child: Image.network(vo.thumbnailURL)),
  );

  final itemDescription = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(
            vo.name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(
            "${vo.dateTime.year}년 ${vo.dateTime.month}월 ${vo.dateTime.day}일",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Text(
            vo.url,
            overflow: TextOverflow.fade,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    ),
  );
  final likeButton = LikeButton(
    isLiked: vo.likeOrder < 0 ? false : true,
    onTap: (isLiked) async {
      debugConsole(isLiked);
      if (!isLiked) {
        VOStageCommitGet.insertVO(vo);
      } else {
        VOStageCommitGet.deleteVO(vo);
      }
      return _changeIsLiked(isLiked);
    },
  );

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, ImagePage.ImageDetail.routeName, arguments: ImagePage.ImageDetailArguments(vo));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: [Expanded(flex: 4, child: img), Flexible(flex: 4, child: itemDescription), Flexible(flex: 1, child: likeButton)],
        ),
      ),
    ),
  );
}

Widget loadingWidgetItem() {
  return const SizedBox.square(dimension: 30, child: CircularProgressIndicator());
}
