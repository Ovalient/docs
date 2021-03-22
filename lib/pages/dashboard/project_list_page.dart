import 'package:docs/pages/dashboard/add_project_page.dart';
import 'package:docs/pages/dashboard/tab_pages/factory_list.dart';
import 'package:docs/pages/dashboard/tab_pages/recent_list.dart';
import 'package:docs/pages/dashboard/tab_pages/search_list.dart';
import 'package:docs/pages/dashboard_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectListPage extends StatefulWidget {
  static const String id = '/dashboard/projectList';
  ProjectListPage({Key key}) : super(key: key);

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage>
    with SingleTickerProviderStateMixin {
  final firestore = FirebaseFirestore.instance;

  TabController _tabController;
  int _selectedTabIndex = 0;

  List<Widget> _tabList = [
    Tab(icon: Icon(Icons.access_time), text: '최신 순'),
    Tab(icon: Icon(Icons.location_on), text: '사이트 별'),
    Tab(icon: Icon(Icons.search), text: '상세 검색')
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: _selectedTabIndex, length: _tabList.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('프로젝트 리스트'),
          bottom: TabBar(
            onTap: (index) {},
            controller: _tabController,
            tabs: _tabList,
          )),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          RecentList(),
          FactoryList(),
          SearchList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (MediaQuery.of(context).size.width > 600)
            onTabNavigate(4);
          else
            Navigator.pop(context, AddProjectPage());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
        tooltip: '새 프로젝트 추가',
      ),
    );
  }
}
