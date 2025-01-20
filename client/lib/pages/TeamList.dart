import 'package:client/pages/TeamFavoriteWidget.dart';
import 'package:client/pages/constants.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:client/provider/event_provider.dart';
import 'package:client/provider/favorite_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Dùng để parse JSON
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:client/provider/team_provider.dart';

class TeamRankWidget extends ConsumerWidget {
  final String? teamNo;
  final int? eventId;

  TeamRankWidget({required this.teamNo, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamListProviderNotifier = ref.read(teamListProvider.notifier);
    final rank = ref.watch(teamListProvider);

    // if (rank.isNotEmpty) {
    //   rank.sort((a, b) => b.rank.compareTo(a.rank)); // Sắp xếp giảm dần
    // }
    // Nếu rank đã có dữ liệu thì không gọi lại API
    if (rank.isNotEmpty && rank.any((team) => team.team_no == teamNo)) {
      final teamRank = rank.firstWhere((team) => team.team_no == teamNo);

      return RatingBar.builder(
        initialRating: teamRank.rank.toDouble(),
        itemBuilder: (context, index) => const Icon(Icons.star,
            // color: Color(0xffFD8B51),
            color: ColorE.rankColorE),
        onRatingUpdate: (rating) {},
        itemCount: 5,
        allowHalfRating: true,
        unratedColor: ColorE.searchColorE,
        itemSize: 20,
        ignoreGestures: true,
      );
    }

    // Nếu chưa có dữ liệu, gọi API
    return FutureBuilder(
      future: teamListProviderNotifier.getRank(teamNo, eventId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error fetching rank.'));
        }

        return Center(child: Text('Rank not found.'));
      },
    );
  }
}

// final models = [
//   TeamList('I24-001', '7F', 1, 'image1.png'),
//   TeamList('I26-002', '7F', 2, 'image2.png'),
//   TeamList('I25-003', '7F', 3, 'image3.png'),
// ];

// モデル => ウィジェット に変換する
Widget modelToWidget(BuildContext context, WidgetRef ref, TeamList team) {
  final user = ref.read(authProvider).commentUser;
  final eventId = ref.read(eventProvider.notifier).getSelectedEventIdSync();
  print("evenId : ${eventId}");
  final text = Text('${team.floor}');

  final images = ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        '${team.teamfileimages}',
        fit: BoxFit.contain,
        height: 250,
        width: double.infinity,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Icon(Icons.error);
        },
      ));

  return GestureDetector(
    onTap: () {
      ref.read(selectedTeamProvider.notifier).state = team.team_no;
      // ref.read(selectedTeamProvider);
      context.push('/myhome/myteam');

      print('team duoc chon ${team.team_no}');
    },
    child: Container(
      padding: const EdgeInsets.all(1),
      width: double.infinity,
      // height: 120,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  text,
                  TeamRankWidget(teamNo: team.team_no, eventId: eventId),
                ],
              ),
              Row(
                children: [
                  user == 'admin@gmail.com'
                      ? IconButton(
                          icon: const Icon(
                            Icons.edit,
                            size: 30,
                          ),
                          onPressed: () {
                            // ref.read(selectedTeamProvider.notifier).state =
                            //     team.team_no;
                            ref
                                .read(teamListProvider.notifier)
                                .selectTeam(team.team_no!);
                            print(
                                'selectedteam ${ref.read(selectedTeamProvider.notifier).state}');
                            context.go('/myhome/home/updateTeams');
                          },
                        )
                      : SizedBox.shrink(),
                  user == 'admin@gmail.com'
                      ? IconButton(
                          icon: const Icon(
                            Icons.delete_outlined,
                            size: 30,
                          ),
                          onPressed: () {
                            ref
                                .read(teamListProvider.notifier)
                                .deleteTeams(team.team_no);
                            ref
                                .read(favoriteProvider.notifier)
                                .deleteFavorite(user, team.team_no);
                          },
                        )
                      : SizedBox.shrink(),
                  TeamFavoriteWidget(
                    userEmail: user,
                    teamNo: team.team_no,
                    eventId: eventId,
                  ),
                ],
              ) // Return an empty widget if the user is not admin
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          images,
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}
