import 'package:client/provider/floor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Floorguide extends ConsumerStatefulWidget {
  const Floorguide({super.key});
  @override
  _FloorguideState createState() => _FloorguideState();
}

class _FloorguideState extends ConsumerState<Floorguide> {
  late List<int> teamCounts;
  late List<int> userCounts;

  @override
  void initState() {
    super.initState();
    // Chỉ gọi fetchFloor một lần khi widget khởi tạo
    // Future.microtask(() =>
    ref.read(floorProvider.notifier).fetchFloor();
  }

  @override
  Widget build(BuildContext context) {
    // ref.read(floorProvider.notifier).fetchFloor();
    final floor = ref.watch(floorProvider);

    userCounts = floor.map((f) => f.userCount).toList();

    floor.sort((a, b) => b.floor_no.compareTo(a.floor_no));

    final text1 = Text('参加者');
    final text2 = Text('チーム');
    final user_circle = Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color(0xffFF7A66)),
    );
    final team_circle = Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color(0xff068288)),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            'フロアガイド',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [user_circle, text1, team_circle, text2],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: floor.length,
              itemBuilder: (c, i) {
                return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    // width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      // color: Color(0xff068288),
                      border: Border(bottom: BorderSide()),
                      // borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${floor[i].floor_no}階',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff694702)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                '${floor[i].contents}',
                                textAlign: TextAlign.center,
                                maxLines:
                                    null, // Cho phép xuống dòng không giới hạn
                                overflow: TextOverflow
                                    .visible, // Đảm bảo hiển thị toàn bộ nội dung
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
                            '${floor[i].teamcount}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${userCounts[i].round()}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                                  value: userCounts[i].toDouble(),
                                  min: 0,
                                  max: 30,
                                  divisions: 100,
                                  label: userCounts[i].round().toString(),
                                  onChanged: (value) {
                                    // setState(() {
                                    //   teamCounts[i] = value.toInt();
                                    // });
                                  },
                                ),
                              ),
                            )
                          ],
                        )
                        //   ],
                        // )
                      ],
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
