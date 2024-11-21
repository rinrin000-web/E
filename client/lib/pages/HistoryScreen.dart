import 'package:client/provider/auth_provider.dart';
import 'package:client/provider/comment_provider.dart';
import 'package:client/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    ref.read(commentProvider.notifier).getHistory(widget.user);
    // ref.read(favoriteProvider.notifier).fetchFavorite(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(commentProvider);
    // final fa_histori = ref.watch(favoriteProvider);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView.builder(
          itemCount: history.length,
          itemBuilder: (c, i) {
            return ListTile(
              title: Text('${history[i].team_no}'),
              subtitle: Text('${history[i].comment}'),
              trailing: Text('${history[i].commented_at}'),
            );
          },
        ));
  }
}
