import 'package:client/pages/createTeams.dart';
import 'package:client/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:client/pages/TeamList.dart';
import 'package:client/provider/team_provider.dart';
import 'package:client/pages/CurrentfloorCheck.dart';
import 'package:client/provider/auth_provider.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(teamListProvider);
    final user = ref.watch(authProvider).commentUser;
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
      'images/echan.png',
      height: 80,
      fit: BoxFit.contain,
    );
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(10.0),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              list,
              Positioned(
                  bottom: 10,
                  // right: 10,
                  child: Row(
                    children: [
                      echan,
                      const SizedBox(
                        width: 10,
                      ),
                      CurrentfloorCheck(
                        user: user,
                        eventId: eventId,
                      )
                    ],
                  ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: user == 'admin@gmail.com'
              ? IconButton(
                  onPressed: () {
                    context.go('/myhome/home/newTeams');
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 30,
                  ))
              : null,
        ));
  }
}
