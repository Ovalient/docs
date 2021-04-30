import 'package:docs/models/model.dart';
import 'package:docs/pages/auth_page.dart';
import 'package:docs/pages/dashboard/admin_pages/board_manager_pages/edit_content_page.dart';
import 'package:docs/pages/dashboard/admin_pages/board_manager_pages/edit_project_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:flutter/material.dart';

import 'admin_pages/user_manage_pages/edit_user_page.dart';

class AdminPage extends StatefulWidget {
  static const String id = '/admin';
  AdminPage({Key key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

PageController _pageController;
void onTabNavigate(int index) {
  _pageController.jumpToPage(index);
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  final List<BottomNavigationBarItem> _navItems = [
    new BottomNavigationBarItem(
        icon: Icon(Icons.people_outlined), label: '사용자'),
    new BottomNavigationBarItem(icon: Icon(Icons.storage), label: '데이터베이스'),
    new BottomNavigationBarItem(
        icon: Icon(Icons.folder_outlined), label: '스토리지'),
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
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  children: [
                    Drawer(
                      child: Stack(
                        children: [
                          ListView(
                            padding: EdgeInsets.zero,
                            children: [
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
                                leading: Icon(Icons.exit_to_app),
                                title: Text('나가기'),
                                onTap: () {
                                  Navigator.popAndPushNamed(
                                      context, AuthPage.id);
                                },
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                              ),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: drawer.length,
                                itemBuilder: (context, index) =>
                                    new EntryItem(drawer[index], context),
                              ),
                            ],
                          )
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
                          EditUserPage(),
                          EditProjectPage(),
                          EditContentPage(),
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
                        // UserManagePage(),
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
      },
    );
  }
}

class Entry {
  Entry(this.icon, this.title, [this.children = const <Entry>[]]);

  final IconData icon;
  final String title;
  final List<Entry> children;
}

final List<Entry> drawer = <Entry>[
  new Entry(Icons.people_outlined, '사용자', <Entry>[
    new Entry(null, '사용자 관리'),
  ]),
  new Entry(Icons.description_outlined, '게시글', <Entry>[
    new Entry(null, '프로젝트 관리'),
    new Entry(null, '내용 관리'),
  ]),
  new Entry(Icons.cloud_outlined, 'Google Firebase')
];

class EntryItem extends StatelessWidget {
  const EntryItem(this.entry, this.context);

  final Entry entry;
  final BuildContext context;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return new ListTile(
          onTap: () {
            switch (root.title) {
              case '사용자 관리':
                onTabNavigate(0);
                break;
              case '프로젝트 관리':
                onTabNavigate(1);
                break;
              case '내용 관리':
                onTabNavigate(2);
                break;
            }
          },
          title: new Text(root.title));
    return new ExpansionTile(
      initiallyExpanded: true,
      key: new PageStorageKey<Entry>(root),
      leading: new Icon(root.icon),
      title: new Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
