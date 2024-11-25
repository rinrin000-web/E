import 'package:client/pages/TeamList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/team_provider.dart';
// import 'package:client/provider/auth_provider.dart';

class Itscreen extends ConsumerStatefulWidget {
  const Itscreen({super.key});
  @override
  _ItscreenState createState() => _ItscreenState();
}

class _ItscreenState extends ConsumerState<Itscreen> {
  @override
  void initState() {
    super.initState();
    // Gọi API khi widget khởi tạo
    ref.read(teamListProvider.notifier).fetchTeams();
  }

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(teamListProvider);
    // final user = ref.watch(authProvider).commentUser;

    // Lọc các đội có team_no bắt đầu bằng 'I'
    final filteredTeams =
        teams.where((team) => team.team_no.toString().startsWith('I')).toList();

    final list = ListView.builder(
      itemCount: filteredTeams.length,
      itemBuilder: (c, i) {
        print(filteredTeams[i].team_no);
        return modelToWidget(context, ref, filteredTeams[i]);
      },
    );

    final echan = Image.asset(
      'images/echan.png',
      height: 80,
      fit: BoxFit.contain,
    );
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text(
                  'IT系',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 29,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  '( ${filteredTeams.length} ) ',
                ),
              ],
            ),
            Expanded(child: list)
          ],
        ),
      ),
    );
  }
}
