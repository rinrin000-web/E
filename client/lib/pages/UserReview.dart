import 'package:client/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/comment_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:client/provider/emailVisibility_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserReview extends ConsumerStatefulWidget {
  String? teamNo;
  // final String? commentUser;

  UserReview({super.key, required this.teamNo});
  @override
  _UserReviewState createState() => _UserReviewState();
}

class _UserReviewState extends ConsumerState<UserReview> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(commentProvider.notifier)
          .fetchComment(widget.teamNo)
          .then((data) {
        ref.read(commentProvider.notifier).state = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userReview = ref.watch(commentProvider);
    final myuser = ref.watch(authProvider).commentUser;
    final isPublic = ref.watch(emailVisibilityProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'ユーザレビュー',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Color(0xff694702)),
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: ListView.builder(
            itemCount: userReview.length,
            itemBuilder: (c, i) {
              return Container(
                height: 250.h,
                padding: const EdgeInsets.all(8.0),
                // child: Card(
                // color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.supervised_user_circle,
                          size: 30,
                          color: Color.fromARGB(255, 1, 1, 1),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                            userReview[i].comment_user == myuser
                                ? (isPublic
                                    ? '${userReview[i].comment_user}'
                                    : 'Euser')
                                : '${userReview[i].comment_user}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold))
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    RatingBar.builder(
                      initialRating: (userReview[i].rank ?? 0).toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 20,
                      ignoreGestures: true,
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, size: 8.w, color: Color(0xffFFCC66)),
                      onRatingUpdate: (rating) {},
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff068288)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Table(
                          border: const TableBorder.symmetric(
                            inside:
                                BorderSide(width: 1, color: Color(0xff068288)),
                          ),
                          columnWidths: const {
                            0: FixedColumnWidth(100),
                            1: FlexColumnWidth(),
                          },
                          children: [
                            const TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      Text('プレゼン', textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      Text('企画', textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      Text('デザイン', textAlign: TextAlign.center),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                      Text('技術', textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${userReview[i].present}',
                                    textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${userReview[i].plan}',
                                    textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${userReview[i].design}',
                                    textAlign: TextAlign.center),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${userReview[i].tech}',
                                    textAlign: TextAlign.center),
                              ),
                            ])
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xff068288)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Table(
                          border: const TableBorder.symmetric(
                            inside:
                                BorderSide(width: 1, color: Color(0xff068288)),
                          ),
                          columnWidths: const {
                            // 0: FixedColumnWidth(),
                            1: FlexColumnWidth(),
                          },
                          children: [
                            const TableRow(children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child:
                                    Text('コメント', textAlign: TextAlign.center),
                              ),
                            ]),
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${userReview[i].comment}'),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                // ),
                // ],
              );
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Image.asset(
          'images/backbutton.png',
          width: 50.w,
          height: 50.h,
        ),
        backgroundColor: Colors.transparent,
        // elevation: 0,
      ),
    );
  }
}
