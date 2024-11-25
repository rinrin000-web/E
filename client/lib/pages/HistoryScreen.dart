import 'package:client/provider/auth_provider.dart';
import 'package:client/provider/comment_provider.dart';
import 'package:client/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/team_provider.dart';
import 'package:go_router/go_router.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  final String? user;
  const HistoryScreen({Key? key, required this.user}) : super(key: key);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(favoriteProvider.notifier).fetchFavorite(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(favoriteProvider);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView.builder(
          itemCount: history.length,
          itemBuilder: (c, i) {
            return ListTile(
              title: GestureDetector(
                onTap: () {
                  ref.read(selectedTeamProvider.notifier).state =
                      history[i].team_no;
                  context.go('/myhome/home/myteam');
                },
                child: Text('${history[i].team_no}'),
              ),
              trailing: Text('${history[i].favorited_at}'),
            );
          },
        ));
  }
}
