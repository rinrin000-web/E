import 'package:client/main.dart';
import 'package:client/pages/constants.dart';
import 'package:client/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/comment_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentScreen extends ConsumerWidget {
  final String? teamNo;
  final String? commentUser;

  CommentScreen({Key? key, required this.teamNo, required this.commentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();

    return SingleChildScrollView(
      child: SizedBox(
        height: 500.h,
        width: 1.sw,
        child: FutureBuilder<List<Comment>>(
          future: ref
              .read(commentProvider.notifier)
              .getCommentsByUser(teamNo, commentUser),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return Center(child: CircularProgressIndicator());
            // }

            final commentList = snapshot.data ??
                [Comment(team_no: teamNo, comment_user: commentUser)];

            return ListView.builder(
              // shrinkWrap: true,
              // physics:  NeverScrollableScrollPhysics(),
              itemCount: commentList.length,
              itemBuilder: (context, index) {
                final comment = commentList[index];

                final rankController =
                    TextEditingController(text: comment.rank?.toString());
                final presentController =
                    TextEditingController(text: comment.present?.toString());
                final planController =
                    TextEditingController(text: comment.plan?.toString());
                final designController =
                    TextEditingController(text: comment.design?.toString());
                final techController =
                    TextEditingController(text: comment.tech?.toString());
                final commentTextController =
                    TextEditingController(text: comment.comment);

                void saveComment() async {
                  try {
                    final presentRating = int.tryParse(presentController.text);
                    final planRating = int.tryParse(planController.text);
                    final designRating = int.tryParse(designController.text);
                    final techRating = int.tryParse(techController.text);

                    if ([presentRating, planRating, designRating, techRating]
                        .any((rating) => rating != null && rating > 5)) {
                      ShowSnackBarE.showSnackBar(
                          context, '評価は1から5の範囲内でなければなりません！');
                      return;
                    }

                    final updatedComment = Comment(
                      team_no: comment.team_no,
                      comment_user: comment.comment_user,
                      rank: int.tryParse(rankController.text),
                      present: int.tryParse(presentController.text),
                      plan: int.tryParse(planController.text),
                      design: int.tryParse(designController.text),
                      tech: int.tryParse(techController.text),
                      comment: commentTextController.text,
                    );

                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      await ref.read(commentProvider.notifier).updateComment(
                          comment.team_no,
                          comment.comment_user,
                          updatedComment);
                      await ref
                          .read(teamListProvider.notifier)
                          .getRank(comment.team_no, eventId);
                    } else {
                      await ref
                          .read(commentProvider.notifier)
                          .createComment(updatedComment);
                      await ref
                          .read(teamListProvider.notifier)
                          .getRank(comment.team_no, eventId);
                    }

                    ShowSnackBarE.showSnackBar(context, TextE.save_text);
                  } catch (e) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('Error: ${e.toString()}')));
                    ShowSnackBarE.showSnackBar(
                        context, 'Error: ${e.toString()}');
                  }
                }

                return SizedBox(
                  // padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                              initialRating: (comment.rank ?? 0).toDouble(),
                              minRating: 1,
                              direction: Axis.horizontal,
                              itemCount: 5,
                              itemSize: 20,
                              unratedColor:
                                  const Color.fromARGB(255, 11, 200, 210),
                              itemBuilder: (context, _) => Icon(Icons.star,
                                  size: 8.w, color: Color(0xffFFCC66)),
                              onRatingUpdate: (rating) {
                                rankController.text = rating.toInt().toString();
                              },
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            IconButton(
                                onPressed: () {
                                  saveComment();
                                },
                                icon: const Icon(Icons.save),
                                color: const Color(0xff068288)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ClipRRect(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff068288)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Table(
                              border: const TableBorder.symmetric(
                                inside: BorderSide(
                                    width: 1, color: Color(0xff068288)),
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
                                      child: Text('プレゼン',
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('企画',
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('デザイン',
                                          textAlign: TextAlign.center),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('技術',
                                          textAlign: TextAlign.center),
                                    ),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: presentController,
                                        onFieldSubmitted: (_) => saveComment(),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '1から5まで'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: planController,
                                        onFieldSubmitted: (_) => saveComment(),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '1から5まで'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: designController,
                                        onFieldSubmitted: (_) => saveComment(),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: '1から5まで'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: techController,
                                        onFieldSubmitted: (_) => saveComment(),
                                        decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.zero,
                                            hintText: '1から5まで'),
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ClipRRect(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xff068288)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Table(
                            border: const TableBorder.symmetric(
                              inside: BorderSide(
                                  width: 1, color: Color(0xff068288)),
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
                                  child: TextFormField(
                                    controller: commentTextController,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    minLines: 3,
                                    maxLines: null,
                                    // decoration: const InputDecoration(
                                    //   labelText: 'コメント',
                                    //   border: OutlineInputBorder(),
                                    // ),
                                    onFieldSubmitted: (_) => saveComment(),
                                  ),
                                ),
                              ])
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
