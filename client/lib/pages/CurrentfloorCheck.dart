import 'package:client/provider/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/floor_provider.dart';

class CurrentfloorCheck extends ConsumerStatefulWidget {
  final String? user;
  const CurrentfloorCheck({Key? key, required this.user}) : super(key: key);

  @override
  _CurrentfloorCheckState createState() => _CurrentfloorCheckState();
}

class _CurrentfloorCheckState extends ConsumerState<CurrentfloorCheck> {
  String? selectedFloor;

  @override
  void initState() {
    super.initState();
    ref.read(floorProvider.notifier).fetchFloor();
    ref.read(userLocationProvider.notifier).fetchUserLocation(widget.user);
  }

  void onFloorTap(String floorNo) async {
    setState(() {
      selectedFloor = floorNo;
    });
    await ref
        .read(userLocationProvider.notifier)
        .updateUserLocation(widget.user!, floorNo);
    await ref.read(floorProvider.notifier).fetchFloor();
  }

  @override
  Widget build(BuildContext context) {
    final floor = ref.watch(floorProvider);
    final myFloor = ref.watch(userLocationProvider);

    if (myFloor.isNotEmpty && selectedFloor == null) {
      selectedFloor = myFloor.first.floor_no;
    }
    return SizedBox(
      // color: Color,
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: floor.length,
        itemBuilder: (c, i) {
          return GestureDetector(
            onTap: () => onFloorTap(floor[i].floor_no),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 3.5), // Thêm padding để tạo khoảng cách
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: selectedFloor == floor[i].floor_no
                      ? Colors.orange
                      : Colors.blue,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${floor[i].floor_no}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
