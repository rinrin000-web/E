import 'package:client/LoginScreen.dart';
import 'package:client/provider/auth_provider.dart';
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

class Myhome extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Myhome({Key? key, required this.navigationShell}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(tabIndexProvider);
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
    final user = ref.watch(authProvider).commentUser;

    final isPublic = ref.watch(emailVisibilityProvider);
    // final String title_text = "ホーム";
    // // void _onItemTapped(int index) {
    // //   ref.read(tabIndexProvider.notifier).setTabIndex(index);
    // //   if (index == 0) {
    // //     navigationShell.goBranch(index, initialLocation: true);
    // //   } else {
    // //     navigationShell.goBranch(index);
    // //   }
    // // }
    // void _onItemTapped(int index) {
    //   ref.read(tabIndexProvider.notifier).setTabIndex(index); // Cập nhật tab
    //   // Điều hướng đến trang tương ứng dựa trên index
    //   switch (index) {
    //     case 0:
    //       context.go('/myhome/home');
    //       title_text = 'ホーム';
    //       break;
    //     case 1:
    //       context.go('/myhome/it');
    //       title_text = 'IT';
    //       break;
    //     case 2:
    //       context.go('/myhome/web');
    //       title_text = 'WEB系';
    //       break;
    //     case 3:
    //       context.go('/myhome/floor');
    //       title_text = 'フロアガイド';
    //       break;
    //     case 4:
    //       context.go('/myhome/favorite');
    //       title_text = '気に入り';
    //       break;
    //     default:
    //       break;
    //   }
    // }
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
                  isPublic ? '$user' : 'Euser',
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
              ref.read(userLocationProvider.notifier).clearUserLocation(user);
              context.go('/event');
            },
          ),
          // ListTile(
          //   title: const Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Icon(Icons.settings),
          //       SizedBox(width: 8),
          //       Text('新規E展作成'),
          //     ],
          //   ),
          //   onTap: () {
          //     context.go('/myhome/home/newEvents');
          //   },
          // ),
          ListTile(
            title: user == 'admin@gmail.com'
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
              if (user == 'admin@gmail.com') {
                context.go('/myhome/home/floorEdit');
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
              ref.read(userLocationProvider.notifier).clearUserLocation(user);
              ref.read(authProvider.notifier).logout();
              if (user == 'admin@gmail.com') {
                ref.read(floorProvider.notifier).resetFakeUserCount(eventId!);
              }
              context.go('/');
            },
          ),
        ],
      ),
    );

    return Scaffold(
      key: scaffoldKey,
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
              scaffoldKey.currentState!.openEndDrawer();
            },
          ),
        ],
      ),
      endDrawer: enDrawer,
      body: navigationShell,
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
