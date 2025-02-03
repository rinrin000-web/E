import 'package:client/pages/HomeScreen.dart';
import 'package:client/pages/MyHome.dart';
import 'package:client/provider/event_provider.dart';
import 'package:client/provider/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventScreen extends ConsumerStatefulWidget {
  const EventScreen({super.key});
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventScreen> {
  final images = Image.asset('assets/images/eventImage.png');
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    ref.read(eventProvider.notifier).fetchEvent();
  }

  @override
  Widget build(BuildContext context) {
    final event_images = ref.watch(eventProvider);
    if (event_images.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    final currentUser = ref.watch(authProvider).commentUser;
    final isAdmin = ref.watch(authProvider).isAdmin;
    final currentDate = DateTime.now();
    print("Current Date: $currentDate");
    print("event_date :${event_images[selectedIndex].event_date}");
    final validEvents = isAdmin!
        ? event_images
        : event_images.where((event) {
            try {
              final eventDate = DateTime.parse(event.event_date);
              print("Event Date for ${event.event_name}: $eventDate");

              bool isValid = eventDate.isBefore(currentDate) ||
                  eventDate.isAtSameMomentAs(currentDate);
              print("Is valid: $isValid");
              return isValid;
            } catch (e) {
              print("Error parsing date for event: ${event.event_date}");
              return false;
            }
          }).toList();

    print("Filtered Events: $validEvents");

    final circle_list = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(validEvents.length, (index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          width: 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                selectedIndex == index ? const Color(0xff068288) : Colors.grey,
          ),
        );
      }),
    );

    final carousel = CarouselSlider.builder(
      options: CarouselOptions(
        height: 500.h,
        viewportFraction: 0.8,
        onPageChanged: (index, reason) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      itemCount: validEvents.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return GestureDetector(
          onTap: () async {
            await ref
                .read(eventProvider.notifier)
                .saveSelectedEventId(validEvents[index].id);
            await ref.read(eventProvider.notifier).fetchEvent();
            context.push('/myhome/home');
          },
          child: Container(
            width: 1.sw,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                validEvents[index].images,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
            ),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: 1.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (validEvents[selectedIndex].event_date.isNotEmpty) carousel,
            SizedBox(height: 20.h),
            circle_list,
            SizedBox(height: 20.h),
            Text(
              validEvents[selectedIndex].event_date,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            if (isAdmin!)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      size: 30,
                    ),
                    onPressed: () {
                      ref
                          .read(eventProvider.notifier)
                          .saveSelectedEventId(validEvents[selectedIndex].id);
                      context.go('/editEvents');
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      size: 30,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      ref
                          .read(eventProvider.notifier)
                          .deleteEvent(validEvents[selectedIndex].id);
                    },
                  ),
                ],
              )
          ],
        ),
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                context.go('/newEvents');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
