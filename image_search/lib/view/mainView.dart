import 'package:flutter/material.dart';
import 'static/colors.dart';
import 'page/imageSearchPage.dart';
import 'page/webSearchPage.dart';
import 'page/likedListPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: WinterGreenColor.snowBlue,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: WinterGreenColor.deepGrayBlue, fontFamily: "Tmoney")),
        useMaterial3: true,
      ),
      home: const NavigateHomePage(),
    );
  }

}

class NavigateHomePage extends StatefulWidget {
  const NavigateHomePage({Key? key}) : super(key: key);

  @override
  State<NavigateHomePage> createState() => _NavigateHomePageState();
}

class _NavigateHomePageState extends State<NavigateHomePage> {
  final List<Widget> _widgetOption = const [ImageSearchPage(), WebSearchPage(), LikedListPage()];
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
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

