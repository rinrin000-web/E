import 'package:client/pages/TeamList.dart';
import 'package:client/pages/search_bar.dart';
import 'package:client/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WebScreen extends ConsumerStatefulWidget {
  const WebScreen({super.key});
  @override
  _WebScreenState createState() => _WebScreenState();
}

class _WebScreenState extends ConsumerState<WebScreen> {
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
    ref.read(teamListProvider.notifier).fetchTeamsbyId(eventId);
  }

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(teamListProvider);
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
    // final user = ref.watch(authProvider).commentUser;

    // Lọc các đội có team_no bắt đầu bằng 'I'
    final filteredTeams =
        teams.where((team) => team.team_no.toString().startsWith('W')).toList();

    final list = ListView.builder(
      itemCount: filteredTeams.length,
      itemBuilder: (c, i) {
        print(filteredTeams[i].team_no);
        return modelToWidget(context, ref, filteredTeams[i]);
      },
    );

    // final echan = Image.asset(
    //   'images/echan.png',
    //   height: 80.h,
    //   fit: BoxFit.contain,
    // );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height,
        // alignment: Alignment.center,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Searchbar(eventId: eventId),
            SizedBox(
              height: 10.h,
            ),
            Text(
              '( ${filteredTeams.length} ) ',
              textAlign: TextAlign.start,
            ),
            Expanded(child: list)
          ],
        ),
      ),
    );
  }
}
