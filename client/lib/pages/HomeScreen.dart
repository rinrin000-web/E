import 'package:client/pages/constants.dart';
import 'package:client/pages/createTeams.dart';
import 'package:client/pages/search_bar.dart';
import 'package:client/provider/event_provider.dart';
import 'package:client/provider/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:client/pages/TeamList.dart';
import 'package:client/provider/team_provider.dart';
import 'package:client/pages/CurrentfloorCheck.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
  //   ref.read(teamListProvider.notifier).fetchTeamsbyId(eventId);
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
    print('eventId: $eventId');
    ref.read(teamListProvider.notifier).fetchTeamsbyId(eventId);
    // ref.read(userLocationProvider.notifier).fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(teamListProvider);
    // final user = ref.watch(authProvider).commentUser;
    final currentUser =
        ref.watch(authProvider).commentUser; // Lấy thông tin user hiện tại
    final isAdmin = ref.watch(authProvider).isAdmin;
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
    final list = ListView.builder(
      itemCount: teams.length,
      itemBuilder: (c, i) {
        print(teams[i].team_no);
        // ref.read(teamListProvider.notifier).getRank();
        return modelToWidget(context, ref, teams[i]);
      },
    );
    final echan = Image.asset(
      'assets/images/pet.png',
      height: 80.h,
      fit: BoxFit.contain,
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Searchbar(eventId: eventId),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 50.h),
                child: list,
              ),
            ),
            // list,
            if (!isAdmin!)
              Positioned(
                  bottom: 0,
                  // right: 10,
                  child: Container(
                      color: ColorE.backgroundColorE,
                      padding: EdgeInsets.only(top: 5.h),
                      child: Row(
                        children: [
                          echan,
                          SizedBox(
                            width: 10.w,
                          ),
                          CurrentfloorCheck(
                            user: currentUser,
                            eventId: eventId,
                          )
                        ],
                      )))
          ],
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {},
              child: IconButton(
                  onPressed: () {
                    context.go('/myhome/home/newTeams');
                  },
                  icon: Icon(
                    Icons.add,
                    size: 30,
                  )))
          : null,
    );
  }
}
