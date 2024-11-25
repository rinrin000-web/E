import 'package:client/pages/TeamFavoriteWidget.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // Dùng để parse JSON
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:client/provider/team_provider.dart';

class TeamRankWidget extends ConsumerWidget {
  final String? teamNo;

  TeamRankWidget({required this.teamNo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teamListProviderNotifier = ref.read(teamListProvider.notifier);
    final rank = ref.watch(teamListProvider);

    // Nếu rank đã có dữ liệu thì không gọi lại API
    if (rank.isNotEmpty && rank.any((team) => team.team_no == teamNo)) {
      final teamRank = rank.firstWhere((team) => team.team_no == teamNo);

      return RatingBar.builder(
        initialRating: teamRank.rank.toDouble(),
        itemBuilder: (context, index) => const Icon(
          Icons.star,
          color: Color(0xffFD8B51),
        ),
        onRatingUpdate: (rating) {},
        itemCount: 5,
        allowHalfRating: true,
        unratedColor: const Color.fromARGB(255, 81, 139, 187),
        itemSize: 20,
        ignoreGestures: true,
      );
    }

    // Nếu chưa có dữ liệu, gọi API
    return FutureBuilder(
      future: teamListProviderNotifier.getRank(teamNo),
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
  final text = Text('${team.floor}');
  // final icon_rank = RatingBar.builder(
  //   itemBuilder: (context, index) => const Icon(
  //     Icons.star,
  //     color: Color(0xffFD8B51),
  //   ),
  //   onRatingUpdate: (rating) {
  //     print('rank: $rating');
  //   },
  //   initialRating: team.rank.toDouble(),
  //   itemCount: 5,
  //   allowHalfRating: true,
  //   unratedColor: Colors.blue[100],
  //   itemSize: 20,
  //   ignoreGestures: true,
  // );
  // print('Image URL: ${team.image}');

  final images = ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Image.network(
        '${team.image}',
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
      context.push('/myhome/home/myteam');

      print(team.team_no);
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
                  TeamRankWidget(teamNo: team.team_no),
                ],
              ),
              TeamFavoriteWidget(userEmail: user, teamNo: team.team_no)
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
