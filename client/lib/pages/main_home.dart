// import 'package:client/pages/CommentScreen.dart';
// import 'package:client/pages/HistoryScreen.dart';
// import 'package:client/pages/MyHome.dart';
// import 'package:client/pages/FloorGuide.dart';
// import 'package:client/pages/HomeScreen.dart';
// import 'package:client/pages/ItScreen.dart';
// import 'package:client/pages/MyTeamScreen.dart';
// import 'package:client/pages/OverviewScreen.dart';
// import 'package:client/pages/WebScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:client/provider/auth_provider.dart';

// class MainHome extends ConsumerWidget {
//   MainHome({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.read(authProvider).commentUser;

//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       routerConfig: GoRouter(
//         initialLocation: '/home',
//         routes: [
//           StatefulShellRoute.indexedStack(
//             builder: (context, state, navigationShell) {
//               return Myhome(navigationShell: navigationShell);
//             },
//             branches: [
//               // HomeScreen branch
//               StatefulShellBranch(
//                 routes: [
//                   GoRoute(
//                       path: '/home',
//                       pageBuilder: (context, state) =>
//                           const MaterialPage(child: Homescreen()),
//                       routes: [
//                         GoRoute(
//                           path: 'myteam',
//                           builder: (context, state) => MyTeamScreen(),
//                           // routes: [
//                           //   GoRoute(
//                           //       path: 'overview',
//                           //       builder: (context, state) => OverviewScreen()),
//                           //   GoRoute(
//                           //       path: 'comment',
//                           //       builder: (context, state) => CommentScreen()),
//                           // ]
//                         ),
//                       ]),
//                 ],
//               ),
//               // ItScreen branch
//               StatefulShellBranch(
//                 routes: [
//                   GoRoute(
//                     path: '/it',
//                     pageBuilder: (context, state) =>
//                         const MaterialPage(child: Itscreen()),
//                   ),
//                 ],
//               ),
//               // WebScreen branch
//               StatefulShellBranch(
//                 routes: [
//                   GoRoute(
//                     path: '/web',
//                     pageBuilder: (context, state) =>
//                         const MaterialPage(child: Webscreen()),
//                   ),
//                 ],
//               ),
//               // FloorGuide branch
//               StatefulShellBranch(
//                 routes: [
//                   GoRoute(
//                     path: '/floor',
//                     pageBuilder: (context, state) =>
//                         const MaterialPage(child: Floorguide()),
//                   ),
//                 ],
//               ),

//               StatefulShellBranch(
//                 routes: [
//                   GoRoute(
//                     path: '/favorite',
//                     pageBuilder: (context, state) => MaterialPage(
//                         child: HistoryScreen(
//                       user: user,
//                     )),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
