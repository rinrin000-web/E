// import 'package:client/provider/auth_provider.dart';
// import 'package:client/provider/event_provider.dart';
// import 'package:client/provider/floor_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class Floorguide extends ConsumerStatefulWidget {
//   const Floorguide({super.key});
//   @override
//   _FloorguideState createState() => _FloorguideState();
// }

// class _FloorguideState extends ConsumerState<Floorguide> {
//   late List<int> teamCounts;
//   late List<int> userCounts;
//   Map<String, int> floorUserCounts = {}; // Lưu số người thay đổi cho mỗi tầng
//   String? selectedFloorNo;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
//     print('eventId: $eventId');
//     ref.read(floorProvider.notifier).fetchFloor(eventId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final floor = ref.watch(floorProvider);
//     final user = ref.watch(authProvider).commentUser;
//     userCounts = floor.map((f) => f.userCount).toList();

//     final text1 = Text('参加者');
//     final text2 = Text('チーム');
//     final user_circle = Container(
//       height: 26,
//       width: 26,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//         color: const Color(0xffFF7A66),
//       ),
//     );
//     final team_circle = Container(
//       height: 26,
//       width: 26,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//         color: const Color(0xff068288),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           const SizedBox(
//             height: 10,
//           ),
//           SizedBox(
//             width: MediaQuery.of(context).size.width * 0.5,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [user_circle, text1, team_circle, text2],
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: floor.length,
//               itemBuilder: (c, i) {
//                 final currentFloorNo = floor[i].floor_no;
//                 // Lấy giá trị đã thay đổi cho tầng này từ map floorUserCounts nếu có
//                 int displayedUserCount =
//                     floorUserCounts.containsKey(currentFloorNo)
//                         ? floorUserCounts[currentFloorNo]!
//                         : userCounts[i];

//                 return Container(
//                   margin: const EdgeInsets.all(8.0),
//                   padding: const EdgeInsets.all(8.0),
//                   decoration: const BoxDecoration(
//                     border: Border(bottom: BorderSide()),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             '${floor[i].floor_no}階',
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xff694702),
//                             ),
//                           ),
//                           const SizedBox(
//                             height: 5,
//                           ),
//                           Container(
//                             alignment: Alignment.center,
//                             width: MediaQuery.of(context).size.width * 0.4,
//                             child: Text(
//                               '${floor[i].contents}',
//                               textAlign: TextAlign.center,
//                               maxLines: null,
//                               overflow: TextOverflow.visible,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         height: 40,
//                         width: 40,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: const Color(0xff068288),
//                         ),
//                         child: Text(
//                           '${floor[i].teamcount}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           Text(
//                             user == 'admin@gmail.com' &&
//                                     selectedFloorNo == currentFloorNo
//                                 ? '$displayedUserCount'
//                                 : '$displayedUserCount',
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 150,
//                             child: SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 trackHeight: 20.0,
//                               ),
//                               child: Slider(
//                                 activeColor: const Color(0xffFF7A66),
//                                 inactiveColor:
//                                     const Color.fromARGB(255, 244, 196, 200),
//                                 thumbColor: const Color(0xffFF7A66),
//                                 value: displayedUserCount.toDouble(),
//                                 min: 0,
//                                 max: 30,
//                                 divisions: 100,
//                                 label: displayedUserCount.round().toString(),
//                                 onChanged: (value) {
//                                   if (user == 'admin@gmail.com') {
//                                     setState(() {
//                                       selectedFloorNo = currentFloorNo;
//                                       floorUserCounts[currentFloorNo] = value
//                                           .round(); // Lưu giá trị thay đổi vào map
//                                     });
//                                   }
//                                 },
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:client/provider/auth_provider.dart';
// import 'package:client/provider/event_provider.dart';
// import 'package:client/provider/floor_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class Floorguide extends ConsumerStatefulWidget {
//   const Floorguide({super.key});
//   @override
//   _FloorguideState createState() => _FloorguideState();
// }

// class _FloorguideState extends ConsumerState<Floorguide> {
//   late List<ValueNotifier<int>> fakeUsercountNotifiers;
//   bool isfake = false;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
//     ref.read(floorProvider.notifier).fetchFloor(eventId!);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
//     final floor = ref.watch(floorProvider);
//     final user = ref.watch(authProvider).commentUser;

//     // Khởi tạo ValueNotifier cho từng tầng
//     fakeUsercountNotifiers =
//         floor.map((f) => ValueNotifier<int>(f.fakeusercount)).toList();

//     final text1 = Text('参加者');
//     final text2 = Text('チーム');
//     final user_circle = Container(
//       height: 26,
//       width: 26,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//         color: const Color(0xffFF7A66),
//       ),
//     );
//     final team_circle = Container(
//       height: 26,
//       width: 26,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(100),
//         color: const Color(0xff068288),
//       ),
//     );

//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           const SizedBox(height: 10),
//           SizedBox(
//             width: MediaQuery.of(context).size.width * 0.5,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [user_circle, text1, team_circle, text2],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: ListView.builder(
//               itemCount: floor.length,
//               itemBuilder: (c, i) {
//                 // Giá trị slider ban đầu là usercount[i]
//                 int initialSliderValue = floor[i].userCount;

//                 return Container(
//                   margin: const EdgeInsets.all(8.0),
//                   padding: const EdgeInsets.all(8.0),
//                   decoration: const BoxDecoration(
//                     border: Border(bottom: BorderSide()),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         children: [
//                           Text(
//                             '${floor[i].floor_no}階',
//                             style: const TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xff694702),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Container(
//                             alignment: Alignment.center,
//                             width: MediaQuery.of(context).size.width * 0.4,
//                             child: Text(
//                               '${floor[i].contents}',
//                               textAlign: TextAlign.center,
//                               maxLines: null,
//                               overflow: TextOverflow.visible,
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         height: 40,
//                         width: 40,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(100),
//                           color: const Color(0xff068288),
//                         ),
//                         child: Text(
//                           '${floor[i].teamcount}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           // Hiển thị giá trị text thay đổi theo giá trị slider
//                           ValueListenableBuilder<int>(
//                             valueListenable: fakeUsercountNotifiers[i],
//                             builder: (context, value, child) {
//                               int sliderValue = value + floor[i].userCount;

//                               return Text(
//                                 '$sliderValue', // Hiển thị giá trị của slider
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               );
//                             },
//                           ),
//                           SizedBox(
//                             width: 150,
//                             child: SliderTheme(
//                               data: SliderTheme.of(context).copyWith(
//                                 trackHeight: 20.0,
//                               ),
//                               child: ValueListenableBuilder<int>(
//                                 valueListenable: fakeUsercountNotifiers[i],
//                                 builder: (context, value, child) {
//                                   int sliderValue = value + floor[i].userCount;

//                                   return Slider(
//                                     activeColor: const Color(0xffFF7A66),
//                                     inactiveColor: const Color.fromARGB(
//                                         255, 244, 196, 200),
//                                     thumbColor: const Color(0xffFF7A66),
//                                     value: sliderValue.toDouble(),
//                                     min: 0,
//                                     max: 100,
//                                     divisions: 100,
//                                     label: sliderValue.round().toString(),
//                                     onChanged: (newValue) {
//                                       if (user == 'admin@gmail.com') {
//                                         // Cập nhật fakeUsercount
//                                         fakeUsercountNotifiers[i].value =
//                                             newValue.round();

//                                         // Cập nhật dữ liệu fakeUserCount trên server
//                                         ref
//                                             .read(floorProvider.notifier)
//                                             .updateFakeUserCount(
//                                               floor[i].floor_no,
//                                               eventId!,
//                                               fakeUsercountNotifiers[i].value,
//                                             )
//                                             .then((_) {
//                                           // Sau khi cập nhật thành công, gọi lại fetchFloor để lấy dữ liệu mới
//                                           ref
//                                               .read(floorProvider.notifier)
//                                               .fetchFloor(eventId);
//                                         });

//                                         setState(() {
//                                           isfake = true;
//                                         });
//                                       }
//                                     },
//                                   );
//                                 },
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:client/provider/auth_provider.dart';
import 'package:client/provider/event_provider.dart';
import 'package:client/provider/floor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Floorguide extends ConsumerStatefulWidget {
  const Floorguide({super.key});
  @override
  _FloorguideState createState() => _FloorguideState();
}

class _FloorguideState extends ConsumerState<Floorguide> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
    print('eventId: $eventId');
    ref.read(floorProvider.notifier).fetchFloorcount(eventId);
  }

  @override
  Widget build(BuildContext context) {
    final floor = ref.watch(floorProvider);
    final eventId = ref.read(eventProvider.notifier).getSelectedEventIdSync();
    final user = ref.watch(authProvider).commentUser;
    final isAdmin = user == 'admin@gmail.com';

    final text1 = Text('参加者');
    final text2 = Text('チーム');
    final userCircle = Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color(0xffFF7A66),
      ),
    );
    final teamCircle = Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color(0xff068288),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [userCircle, text1, teamCircle, text2],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: floor.length,
              itemBuilder: (c, i) {
                final currentFloor = floor[i];

                // Giá trị ban đầu của slider là userCount cho cả admin và user
                double initialSliderValue = currentFloor.userCount.toDouble();

                // Nếu admin sửa thì giá trị của slider sẽ là fakeusercount
                if (isAdmin) {
                  initialSliderValue = currentFloor.fakeusercount.toDouble();
                }

                // Nếu số người tham gia (userCount) tăng lên, giá trị của slider sẽ là userCount + fakeusercount
                double sliderValue = currentFloor.userCount +
                    currentFloor.fakeusercount.toDouble();

                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide()),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${currentFloor.floor_no}階',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff694702),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              '${currentFloor.contents}',
                              textAlign: TextAlign.center,
                              maxLines: null,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xff068288),
                        ),
                        child: Text(
                          '${currentFloor.teamcount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${sliderValue.toInt()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 150,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 20.0,
                              ),
                              child: Slider(
                                activeColor: const Color(0xffFF7A66),
                                inactiveColor:
                                    const Color.fromARGB(255, 244, 196, 200),
                                thumbColor: const Color(0xffFF7A66),
                                value: sliderValue,
                                min: 0,
                                max: 200,
                                divisions: 30,
                                label: '${sliderValue.toInt()}',
                                onChanged: (value) {
                                  if (isAdmin) {
                                    // Cập nhật giá trị fakeusercount khi admin thay đổi slider
                                    ref
                                        .read(floorProvider.notifier)
                                        .updateFakeUserCount(
                                          currentFloor.floor_no,
                                          eventId!,
                                          value.toInt(),
                                        );

                                    // Fetch lại dữ liệu sau khi thay đổi giá trị
                                    // setState(() {
                                    //   ref.read(floorProvider.notifier).fetchFloorcount(eventId);
                                    // });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
