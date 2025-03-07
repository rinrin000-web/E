import 'package:client/provider/event_provider.dart';
import 'package:client/provider/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/floor_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurrentfloorCheck extends ConsumerStatefulWidget {
  final String? user;
  final int? eventId;
  const CurrentfloorCheck({Key? key, required this.user, required this.eventId})
      : super(key: key);

  @override
  _CurrentfloorCheckState createState() => _CurrentfloorCheckState();
}

class _CurrentfloorCheckState extends ConsumerState<CurrentfloorCheck> {
  String? selectedFloor;

  @override
  void initState() {
    super.initState();
    final eventId = ref.read(eventProvider.notifier).getSelectedEventIdSync();
    ref.read(floorProvider.notifier).fetchFloor(eventId!);
    ref.read(userLocationProvider.notifier).fetchUserLocation();
  }

  void onFloorTap(String floorNo) async {
    setState(() {
      selectedFloor = floorNo;
    });
    await ref
        .read(userLocationProvider.notifier)
        .updateUserLocation(widget.user!, floorNo);
    final eventId = ref.read(eventProvider.notifier).getSelectedEventIdSync();
    await ref.read(floorProvider.notifier).fetchFloor(eventId!);
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
      height: 50.h,
      width: 1.sw,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: floor.length,
        itemBuilder: (c, i) {
          return GestureDetector(
            onTap: () => onFloorTap(floor[i].floor_no),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 3.5.w), // Thêm padding để tạo khoảng cách
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: selectedFloor == floor[i].floor_no
                      ? Color(0xffFD8B51)
                      : Color(0xff068288),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${floor[i].floor_no}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
