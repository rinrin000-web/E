import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/overview_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverviewScreen extends ConsumerStatefulWidget {
  final String? teamNo;

  OverviewScreen({super.key, required this.teamNo});

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends ConsumerState<OverviewScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(overviewProvider.notifier)
          .fetchOverview(widget.teamNo)
          .then((data) {
        ref.read(overviewProvider.notifier).state = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final overviews = ref.watch(overviewProvider);

    // if (overviews.isEmpty) {
    //   return Center(child: CircularProgressIndicator());
    // }
    return SingleChildScrollView(
      child: SizedBox(
        height: 500.h,
        child: ListView.builder(
          itemCount: overviews.length,
          itemBuilder: (c, i) {
            final overview = overviews[i];
            return Column(
              // child: ListTile(
              //   title: Text(overview.slogan ?? "Không có slogan"),
              //   subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'スローガン',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff694702),
                      fontSize: 16),
                ),
                Text(
                  "${overview.slogan}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  '全体企画',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff694702),
                      fontSize: 16),
                ),
                Text(
                  "${overview.overallplanning}",
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  '▼使用技術',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff694702),
                      fontSize: 16),
                ),
                Text(
                  "${overview.techused}",
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  '▼使用ツール・アプリ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff694702),
                      fontSize: 16),
                ),
                Text(
                  "${overview.tools}",
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
              // ),
            );
          },
        ),
      ),
    );
  }
}
