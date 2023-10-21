import 'package:flutter/material.dart';
import 'static/myOrdinaryStyle.dart';
import 'package:image_search/controller/vo_controle.dart';
import 'page/imageSearchPage.dart' as ImagePage;
import 'page/webSearchPage.dart' as WebPage;
import 'page/likedListPage.dart' as LikePage;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: WinterGreenColor.winterGreenTheme,
        textTheme: CuteText.cuteTextTheme,
        useMaterial3: true,
      ),
      home: const NavigateHomePage(),
      routes: {
        ImagePage.ImageDetail.routeName: (context) => const ImagePage.ImageDetail(),
        WebPage.WebDetail.routeName: (context) => const WebPage.WebDetail()
      },
    );
  }
}

class NavigateHomePage extends StatefulWidget {
  const NavigateHomePage({Key? key}) : super(key: key);

  @override
  State<NavigateHomePage> createState() => _NavigateHomePageState();
}

class _NavigateHomePageState extends State<NavigateHomePage> {
  final List<Widget> _widgetOption = const [ImagePage.ImageSearchPage(), WebPage.WebSearchPage(), LikePage.LikedListPage()];
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
      VOStageCommitGet.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOption.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.image_search_rounded), label: '이미지 '),
          BottomNavigationBarItem(icon: Icon(Icons.manage_search_rounded), label: '내용'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: '좋아요'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
