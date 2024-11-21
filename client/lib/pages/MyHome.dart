import 'package:client/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/navigation_provider.dart.dart';
import 'package:client/pages/search_bar.dart';
import 'package:client/provider/search_provider.dart';

class Myhome extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Myhome({Key? key, required this.navigationShell}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(tabIndexProvider);
    final user = ref.watch(authProvider).commentUser;

    void _onItemTapped(int index) {
      ref.read(tabIndexProvider.notifier).setTabIndex(index);
      if (index == 0) {
        navigationShell.goBranch(index, initialLocation: true);
      } else {
        navigationShell.goBranch(index);
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
        children: [logoImage, const Spacer(), Searchbar()],
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
            Text(
              '$user',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )
          ])),
          ListTile(
            title: const Text('logout'),
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('item2'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
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
            icon: Icon(Icons.history),
            label: 'History',
            backgroundColor: Color(0xffFFCC66),
          ),
        ],
      ),
    );
  }
}
