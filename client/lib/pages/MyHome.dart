import 'package:client/LoginScreen.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:client/provider/comment_provider.dart';
import 'package:client/provider/event_provider.dart';
import 'package:client/provider/fake_usercount_provider.dart';
import 'package:client/provider/floor_provider.dart';
import 'package:client/provider/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/navigation_provider.dart.dart';
import 'package:client/pages/search_bar.dart';
import 'package:client/provider/search_provider.dart';
import 'package:client/provider/emailVisibility_provider.dart';
import 'package:client/pages/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Myhome extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Myhome({Key? key, required this.navigationShell}) : super(key: key);
  @override
  MyhomeState createState() => MyhomeState();
}

class MyhomeState extends ConsumerState<Myhome> {
  @override
  void initState() {
    super.initState();
    ref.read(userLocationProvider.notifier).fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(tabIndexProvider);
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
    final currentUser = ref.watch(authProvider).commentUser;

    final isAdmin = ref.watch(authProvider).isAdmin;

    final isPublic = ref.watch(emailVisibilityProvider);

    final titles = ["ホーム", "IT系", "WEB系", "フロアガイド", "気に入り"];
    final currentTitle = titles[selectedIndex];

    void _onItemTapped(int index) {
      ref.read(tabIndexProvider.notifier).setTabIndex(index);
      final routes = [
        '/myhome/home',
        '/myhome/it',
        '/myhome/web',
        '/myhome/floor',
        '/myhome/favorite'
      ];
      context.go(routes[index]);
    }

    final searchQuery = ref.watch(searchProvider);
    final logoImage = Image.asset(
      'assets/images/echanlogo.png',
      width: 70.w,
    );

    final appbar = Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      width: 1.sw,
      color: ColorE.headerColorE,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: logoImage,
          ),
          Center(
            child: Text(
              currentTitle,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  // color: ColorE.backgroundColorE
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );

    final enDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              child: Column(children: [
            Icon(
              Icons.person,
              size: 50,
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isPublic ? '$currentUser' : 'Euser',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8.w),
                IconButton(
                  icon: Icon(
                    isPublic ? Icons.visibility : Icons.visibility_off,
                    color: isPublic ? Color(0xff068288) : Colors.grey,
                    size: 30,
                  ),
                  onPressed: () {
                    ref
                        .read(emailVisibilityProvider.notifier)
                        .toggleVisibility();
                    ref
                        .read(commentProvider.notifier)
                        .updateIsPublic(currentUser, !isPublic);
                  },
                ),
              ],
            )
          ])),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.settings),
                SizedBox(width: 8.w),
                Text('ユーザー編集'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back),
                SizedBox(width: 8.w),
                Text('E展画面移動'),
              ],
            ),
            onTap: () {
              ref
                  .read(userLocationProvider.notifier)
                  .clearUserLocation(currentUser);
              context.go('/event');
            },
          ),
          ListTile(
            title: isAdmin!
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8.w),
                      Text('フロアガイド編集'),
                    ],
                  )
                : null, // Không hiển thị nếu không phải admin
            onTap: () {
              if (isAdmin) {
                context.go('/myhome/home/floorEdit');
              }
            },
          ),
          ListTile(
            title: isAdmin
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8.w),
                      Text('メンバー管理'),
                    ],
                  )
                : null, // Không hiển thị nếu không phải admin
            onTap: () {
              if (isAdmin) {
                context.go('/myhome/home/member_manage');
              }
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.logout),
                SizedBox(width: 8.w),
                Text('ログアウト'),
              ],
            ),
            onTap: () {
              ref
                  .read(userLocationProvider.notifier)
                  .clearUserLocation(currentUser);
              ref.read(authProvider.notifier).logout();
              if (isAdmin) {
                ref.read(floorProvider.notifier).resetFakeUserCount(eventId!);
              }
              context.go('/');
            },
          ),
        ],
      ),
    );

    return Scaffold(
      key: widget.scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: const EdgeInsets.all(0.0),
          child: appbar,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.list,
              color: ColorE.backgroundColorE,
              size: 35,
            ),
            onPressed: () {
              widget.scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: enDrawer,
      body: widget.navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: ColorE.backgroundColorE,
        unselectedItemColor: ColorE.searchColorE,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: ColorE.headerColorE,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'IT',
            backgroundColor: ColorE.headerColorE,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'Web',
            backgroundColor: ColorE.headerColorE,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Floor Guide',
            backgroundColor: ColorE.headerColorE,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
            backgroundColor: ColorE.headerColorE,
          ),
        ],
      ),
    );
  }
}
