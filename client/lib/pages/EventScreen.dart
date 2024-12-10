import 'package:client/pages/HomeScreen.dart';
import 'package:client/pages/MyHome.dart';
import 'package:client/pages/main_home.dart';
import 'package:client/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
    final user = ref.watch(authProvider).commentUser;

    if (event_images.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    final circle_list = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(event_images.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 8,
          height: 8,
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
        height: 500,
        viewportFraction: 0.8,
        onPageChanged: (index, reason) {
          setState(() {
            selectedIndex = index; // Cập nhật selectedIndex khi thay đổi trang
          });
        },
      ),
      itemCount: event_images.length,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return GestureDetector(
          onTap: () async {
            // Khi nhấn vào hình ảnh, điều hướng đến màn hình hiển thị hình ảnh toàn màn hình
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => FullScreenImage(selectedIndex: index),
            //   ),
            // );
            await ref
                .read(eventProvider.notifier)
                .saveSelectedEventId(event_images[index].id);
            await ref.read(eventProvider.notifier).fetchEvent();
            print("Selected Event ID: ${event_images[index].id}");
            context.push('/myhome/home');
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: const BoxDecoration(color: Colors.transparent),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                event_images[index].images,
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
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            carousel,
            const SizedBox(height: 20),
            circle_list,
            const SizedBox(height: 20),
            IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 30,
                  color: Colors.red,
                ),
                onPressed: () {
                  ref
                      .read(eventProvider.notifier)
                      .deleteEvent(event_images[selectedIndex].id);
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.go('/myhome/home/newEvents');
        },
        child: user == "admin@gmail.com"
            ? IconButton(
                onPressed: () {
                  context.go('/newEvents');
                },
                icon: const Icon(
                  Icons.add,
                ))
            : null,
      ),

      // Container(
      //   padding: EdgeInsets.all(15),
      //   alignment: Alignment.center,
      //   // child: SizedBox(
      //   child: ElevatedButton(
      //       onPressed: () {
      //         // Navigator.pushReplacement(
      //         //   context,
      //         //   MaterialPageRoute(builder: (context) => MainHome()),
      //         // );
      //         context.push('/myhome/home');
      //         // Navigator.push(
      //         //   context,
      //         //   MaterialPageRoute(builder: (context) => Myhome()),
      //         // );
      //       },
      //       style: ElevatedButton.styleFrom(
      //         padding: EdgeInsets.zero, // Xóa khoảng cách padding mặc định
      //         minimumSize: Size(0, 0), // Không đặt kích thước tối thiểu
      //       ),
      //       child: images),
      //   // )
      // ),
    );
  }
}
