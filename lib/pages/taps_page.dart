import 'package:flutter/material.dart';

import './settings_page.dart';
import './history_page.dart';
import './home_page.dart';
import 'players_view_page.dart';

class TapsPage extends StatefulWidget {
  const TapsPage({Key? key}) : super(key: key);

  @override
  State<TapsPage> createState() => _TapsPageState();
}

class _TapsPageState extends State<TapsPage> {
  List<Widget> pages = const [
    SettingsPage(),
    HomePage(),
    HistoryPage(),
    PlayersViewPage()
  ];
  int _index = 1;
  final pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageView,
      bottomNavigationBar: bottomBar(),
    );
  }

  BottomNavigationBar bottomBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Theme.of(context).iconTheme.color,
      unselectedItemColor: Theme.of(context).iconTheme.color,
      elevation: 2,
      enableFeedback: true,
      onTap: (i) => setState(() {
        _index = i;
        pageController.animateToPage(
          i,
          duration: const Duration(microseconds: 500),
          curve: Curves.bounceInOut,
        );
      }),
      currentIndex: _index,
      items: const [
        BottomNavigationBarItem(
          label: 'Settings',
          activeIcon: Icon(Icons.settings_applications_sharp),
          icon: Icon(Icons.settings_applications_outlined),
        ),
        BottomNavigationBarItem(
          label: 'home',
          activeIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
        ),
        BottomNavigationBarItem(
          label: 'History',
          activeIcon: Icon(Icons.history),
          icon: Icon(Icons.history),
        ),
        BottomNavigationBarItem(
          label: 'Players',
          activeIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outline),
        ),
      ],
    );
  }

  //used to make screen slides
  PageView get _pageView {
    return PageView(
      controller: pageController,
      children: pages,
      onPageChanged: (index) => setState(
        () {
          //index used here to apply changing the page to the bottom navigation bar 'Icons and labels'
          _index = index;
        },
      ),
    );
  }
}
