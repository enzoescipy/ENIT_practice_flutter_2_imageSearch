import 'package:flutter/material.dart';
import 'package:untitled/article_search_view.dart';
import 'package:untitled/favorite_view.dart';
import 'package:untitled/image_search_view.dart';

class Tabs extends StatefulWidget {
  @override
  State<Tabs> createState() => _TabsState();
}
class _TabsState extends State<Tabs> {

  late PageController pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
  void navigationTapped(int page) {
    print("PAGE!!!!!");
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: onPageChanged,
              children: [
                ImageSearchView(),
                ArticleSearchView(),
                FavoriteView(),
              ]
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            barIcon(0),
            barIcon(1),
            barIcon(2),
          ],
        ),
      ),
    );
  }
  Widget barIcon(int page) {
    return InkWell(
      child: Container(
          height: 60,
          child: page==0?Icon(Icons.image):page==1?Icon(Icons.edit):Icon(Icons.favorite),
    ),
    onTap: ()=>{
      print(page),
      navigationTapped(page),
      },
    );
  }
}
