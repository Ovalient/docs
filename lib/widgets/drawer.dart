import 'package:docs/pages/dashboard/main_page.dart';
import 'package:docs/pages/login_page.dart';
import 'package:docs/utils/firebase_provider.dart';
import 'package:docs/widgets/route_observer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({@required this.permanentlyDisplay, Key key})
      : super(key: key);

  final bool permanentlyDisplay;

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with RouteAware {
  String _selectedRoute;
  AppRouteObserver _routeObserver;

  /// Closes the drawer if applicable (which is only when it's not been displayed permanently) and navigates to the specified route
  /// In a mobile layout, the a modal drawer is used so we need to explicitly close it when the user selects a page to display
  Future<void> _navigateTo(BuildContext context, String routeName) async {
    if (widget.permanentlyDisplay) {
      Navigator.pop(context);
    }
    await Navigator.pushNamed(context, routeName);
  }

  void _updateSelectedRoute() {
    setState(() {
      _selectedRoute = ModalRoute.of(context).settings.name;
    });
  }

  @override
  void initState() {
    super.initState();
    _routeObserver = AppRouteObserver();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(
                    Icons.check,
                  ),
                ),
                accountName: Text('user'),
                accountEmail: Text(getUser().email),
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
              ListTile(
                leading: Icon(Icons.home),
                title: Text('메인'),
                onTap: () async {
                  await _navigateTo(context, MainPage.id);
                },
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('프로젝트 리스트'),
                onTap: () async {
                  await _navigateTo(context, MainPage.id);
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark),
                title: Text('북마크'),
                onTap: () async {
                  await _navigateTo(context, MainPage.id);
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
    );
  }
}
