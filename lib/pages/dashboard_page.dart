import 'package:docs/models/model.dart';
import 'package:docs/pages/dashboard/add_project_page.dart';
import 'package:docs/pages/dashboard/admin_page.dart';
import 'package:docs/pages/dashboard/list_detail_page.dart';
import 'package:docs/pages/login_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dashboard/bookmark_page.dart';
import 'dashboard/main_page.dart';
import 'dashboard/project_list_page.dart';

class DashboardPage extends StatefulWidget {
  static const String id = '/dashboard';
  DashboardPage({Key key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

PageController _pageController;

void onTabNavigate(int index) {
  _pageController.jumpToPage(index);
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  List userInfo = [];
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

  final List<BottomNavigationBarItem> _navItems = [
    new BottomNavigationBarItem(icon: Icon(Icons.home), label: '메인'),
    new BottomNavigationBarItem(icon: Icon(Icons.list), label: '프로젝트 리스트'),
    new BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: '북마크'),
  ];

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
    return FutureBuilder(
        future: getUserInfo(getUser().uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(child: CircularProgressIndicator()));
          } else {
            return LayoutBuilder(
              builder: (build, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    children: [
                      Drawer(
                        child: Stack(
                          children: [
                            ListView(
                              // Important: Remove any padding from the ListView.
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                UserAccountsDrawerHeader(
                                  decoration:
                                      BoxDecoration(color: Color(0xF2404B60)),
                                  currentAccountPicture: CircleAvatar(
                                    backgroundColor: Colors.redAccent,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                  accountName: Text(userName),
                                  accountEmail: Text(userEmail),
                                ),
                                ListTile(
                                  leading: Icon(Icons.logout),
                                  title: Text('로그아웃'),
                                  onTap: () {
                                    signOut();
                                    Navigator.popAndPushNamed(
                                        context, LoginPage.id);
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                    String url =
                                        'https://calendar.google.com/calendar';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                ),
                                userRank == '관리자'
                                    ? Divider(height: 1, thickness: 1)
                                    : SizedBox(),
                                userRank == '관리자'
                                    ? ListTile(
                                        leading: Icon(Icons.construction),
                                        title: Text('관리자 페이지'),
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, AdminPage.id);
                                        },
                                      )
                                    : SizedBox(),
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
                          physics: NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          children: <Widget>[
                            MainPage(),
                            ProjectListPage(),
                            BookmarkPage(),
                            ListDetailPage(),
                            AddProjectPage(),
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
                } else {
                  return Scaffold(
                    body: PageView(
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
                        }),
                    bottomNavigationBar: BottomNavigationBar(
                      elevation: 0.0,
                      onTap: onTabNavigate,
                      currentIndex: _currentIndex,
                      items: _navItems,
                    ),
                  );
                }
              },
            );
          }
        });
  }
}
