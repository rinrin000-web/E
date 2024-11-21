import 'package:client/pages/EventScreen.dart';
import 'package:client/pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:client/provider/auth_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/BackgroundPageI.png'), // Đặt ảnh nền
              fit: BoxFit.fill, // Ảnh nền phủ toàn bộ màn hình
            ),
          ),
          child: child!, // Hiển thị các widget con bên trong
        ),
        breakpoints: [
          // ← 追加
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      // initialRoute: "/",
      home: WellcomeScreen(),
    );
  }
}

class WellcomeScreen extends ConsumerWidget {
  WellcomeScreen({super.key});

  final boxcontainer = Container(
    width: 1,
    height: 83,
    color: Colors.black12,
  );

  final logoImage = Image.asset(
    'assets/images/Logo.png',
    height: 160,
  );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy trạng thái xác thực từ authProvider
    final authState = ref.watch(authProvider);

    // Nếu người dùng đã đăng nhập thì chuyển thẳng tới EventScreen
    if (authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EventScreen()),
        );
      });
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.center,
                  child: logoImage,
                ),
                Positioned(
                  top: 0,
                  right: 1,
                  child: Column(
                    children: [
                      boxcontainer,
                      SizedBox(
                        width: 40,
                        height: 43,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => LoginScreen()),
                            // );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen()), // Thay thế WellcomeScreen
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero, // Xóa padding mặc định
                            minimumSize: const Size(
                                40, 43), // Kích thước tối thiểu cho nút
                          ),
                          child: Image.asset(
                            'assets/images/loginI.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
