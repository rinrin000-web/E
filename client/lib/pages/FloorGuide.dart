import 'package:client/provider/auth_provider.dart';
import 'package:client/provider/event_provider.dart';
import 'package:client/provider/floor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    final text1 = Text(
      '参加者',
      // style: TextStyle(fontSize: 16.sp),
    );
    final text2 = Text(
      'チーム',
      // style: TextStyle(fontSize: 16.sp),
    );
    final userCircle = Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xffFF7A66),
      ),
    );
    final teamCircle = Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff068288),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 10.h,
          ),
          SizedBox(
            width: 0.5.sw,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [userCircle, text1, teamCircle, text2],
            ),
          ),
          SizedBox(
            height: 20.h,
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff694702),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 0.4.sw,
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
                          shape: BoxShape.circle,
                          color: const Color(0xff068288),
                        ),
                        child: Text(
                          '${currentFloor.teamcount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                            width: 150.w,
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
