import 'package:docs/pages/login_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dashboard/bookmark_page.dart';
import 'dashboard/main_page.dart';
import 'dashboard/project_list_page.dart';

class DashboardPage extends StatefulWidget {
  static const String id = '/dashboardPage';
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  PageController _pageController;
  int _currentIndex = 0;

  List drawerItems = [
    {
      "icon": Icons.home,
      "name": "메인",
    },
    {
      "icon": Icons.list,
      "name": "프로젝트 리스트",
    },
    {
      "icon": Icons.bookmark,
      "name": "북마크",
    }
  ];

  void onTabNavigate(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Drawer(
          child: Stack(
            children: [
              ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  FutureBuilder(
                    future: getUserInfo(),
                    builder: (context, snapshots) {
                      String name = (snapshots.hasData) ? snapshots.data : '';

                      return UserAccountsDrawerHeader(
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.redAccent,
                          child: Icon(
                            Icons.check,
                          ),
                        ),
                        accountName: Text(name),
                        accountEmail: Text(getUser().email),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('로그아웃'),
                    onTap: () {
                      signOut();
                      Navigator.popAndPushNamed(context, LoginPage.id);
                    },
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: drawerItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map item = drawerItems[index];

                      return ListTile(
                        leading: Icon(item['icon']),
                        title: Text(item['name']),
                        onTap: () {
                          _currentIndex = index;
                          onTabNavigate(_currentIndex);
                        },
                      );
                    },
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text('구글 캘린더'),
                    onTap: () async {
                      String url = 'https://calendar.google.com/calendar';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('icons/logo.png'),
                ),
              ),
            ],
          ),
        ),
        VerticalDivider(
          width: 1,
          thickness: 1,
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: <Widget>[
              MainPage(),
              ProjectListPage(),
              BookmarkPage(),
            ],
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }
}
