import 'package:client/LoginScreen.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:client/provider/event_provider.dart';
import 'package:client/provider/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/navigation_provider.dart.dart';
import 'package:client/pages/search_bar.dart';
import 'package:client/provider/search_provider.dart';
import 'package:client/provider/emailVisibility_provider.dart';

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

    // void _onItemTapped(int index) {
    //   ref.read(tabIndexProvider.notifier).setTabIndex(index);
    //   if (index == 0) {
    //     navigationShell.goBranch(index, initialLocation: true);
    //   } else {
    //     navigationShell.goBranch(index);
    //   }
    // }
    void _onItemTapped(int index) {
      ref.read(tabIndexProvider.notifier).setTabIndex(index); // Cập nhật tab
      // Điều hướng đến trang tương ứng dựa trên index
      switch (index) {
        case 0:
          context.go('/myhome/home');
          break;
        case 1:
          context.go('/myhome/it');
          break;
        case 2:
          context.go('/myhome/web');
          break;
        case 3:
          context.go('/myhome/floor');
          break;
        case 4:
          context.go('/myhome/favorite');
          break;
        default:
          break;
      }
    }

    final searchQuery = ref.watch(searchProvider);
    final logoImage = Image.asset(
      'assets/images/Logo.png',
    );
    final appbar = Container(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 45.0, 5.0),
      width: double.infinity * 0.8,
      color: const Color(0xffC0E2E3),
      child: Row(
        children: [logoImage, const Spacer(), Searchbar(eventId: eventId)],
      ),
    );

    final enDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              child: Column(children: [
            const Icon(
              Icons.person,
              size: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isPublic ? '$user' : 'Euser',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
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
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.settings),
                SizedBox(width: 8),
                Text('ユーザー編集'),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_back),
                SizedBox(width: 8),
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
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
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
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.logout),
                SizedBox(width: 8),
                Text('ログアウト'),
              ],
            ),
            onTap: () {
              ref.read(userLocationProvider.notifier).clearUserLocation(user);
              ref.read(authProvider.notifier).logout();
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
            icon: const Icon(
              Icons.list,
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
        selectedItemColor: const Color(0xff068288),
        unselectedItemColor: const Color(0xff694702),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xffFFCC66),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.computer),
            label: 'IT',
            backgroundColor: Color(0xffFFCC66),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'Web',
            backgroundColor: Color(0xffFFCC66),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Floor Guide',
            backgroundColor: Color(0xffFFCC66),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
            backgroundColor: Color(0xffFFCC66),
          ),
        ],
      ),
    );
  }
}
