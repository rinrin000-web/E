import 'package:client/pages/CommentScreen.dart';
import 'package:client/pages/FullScreenImage.dart';
import 'package:client/pages/MemberScreen.dart';
import 'package:client/pages/OverviewScreen.dart';
import 'package:client/pages/TeamFavoriteWidget.dart';
import 'package:client/pages/TeamList.dart';
import 'package:client/pages/UserReview.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:client/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTeamScreen extends ConsumerStatefulWidget {
  const MyTeamScreen({super.key});
  @override
  _MyTeamScreenState createState() => _MyTeamScreenState();
}

class _MyTeamScreenState extends ConsumerState<MyTeamScreen> {
  int selectedIndex = 0;
  String selectedTab = 'overview';

  @override
  Widget build(BuildContext context) {
    final selectedTeamNo = ref.watch(selectedTeamProvider);
    final user = ref.watch(authProvider).commentUser;
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();

    print('commentuser: $user');
    final teams = ref.watch(teamListProvider);
    final selectedTeam = teams.firstWhere(
      (team) => team.team_no == selectedTeamNo,
    );

    final teamfileimages = ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
          selectedTeam.teamfileimages,
          fit: BoxFit.contain,
          height: 300.h,
          width: 1.sw,
        ));
    final icon_rank = GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserReview(
                teamNo: selectedTeamNo,
              ),
            ),
          );
        },
        child: TeamRankWidget(
          teamNo: selectedTeamNo,
          eventId: eventId,
        ));

    final row = Row(
      children: [Text(selectedTeam.floor), icon_rank],
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              teamfileimages,
              SizedBox(
                height: 10,
              ),
              row,
              SizedBox(
                height: 10,
              ),
              MemberScreen(selectedTeamNo: selectedTeamNo),
              Row(
                children: [
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedTab = 'overview'; // Chọn tab overview
                          });
                        },
                        child: Text(
                          '概要',
                          style: TextStyle(
                              color: Color(0xff068288),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 2.h,
                        width: 40.w,
                        color: selectedTab == 'overview'
                            ? const Color(0xff068288)
                            : Colors.transparent,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            selectedTab = 'comment'; // Chọn tab comment
                          });
                        },
                        child: Text(
                          '評価',
                          style: TextStyle(
                              color: Color(0xff068288),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Container(
                        height: 2.h,
                        width: 40.w,
                        color: selectedTab == 'comment'
                            ? const Color(0xff068288)
                            : Colors.transparent,
                      )
                    ],
                  ),
                ],
              ),
              IndexedStack(
                index: selectedTab == 'overview'
                    ? 0
                    : 1, // Chọn tab dựa trên selectedTab
                children: [
                  OverviewScreen(
                    teamNo: selectedTeamNo,
                  ), // Tab Overview
                  CommentScreen(
                      teamNo: selectedTeamNo, commentUser: user), // Tab Comment
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: TeamFavoriteWidget(
          userEmail: user,
          teamNo: selectedTeamNo,
          eventId: eventId,
        ),
      ),
    );
  }
}
