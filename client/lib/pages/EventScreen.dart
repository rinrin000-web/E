import 'package:client/pages/HomeScreen.dart';
import 'package:client/pages/MyHome.dart';
import 'package:client/pages/main_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:go_router/go_router.dart';

class EventScreen extends ConsumerWidget {
  final images = Image.asset('assets/images/eventImage.png');
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.read(authProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.center,
        // child: SizedBox(
        child: ElevatedButton(
            onPressed: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => MainHome()),
              // );
              context.push('/myhome/home');
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Myhome()),
              // );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero, // Xóa khoảng cách padding mặc định
              minimumSize: Size(0, 0), // Không đặt kích thước tối thiểu
            ),
            child: images),
        // )
      ),
    );
  }
}
