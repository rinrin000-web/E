import 'package:client/LoginScreen.dart';
import 'package:client/pages/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider/auth_provider.dart';
// import 'package:client/pages/LoginScreen.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginlogo = Image.asset(
      'assets/images/signuplogo.png',
      height: 160,
    );

    final container = new Container(
      width: 0.5,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xff068288),
    );
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          children: [
            Positioned(top: 0, left: 0, child: loginlogo),
            Positioned(top: 0, left: 15, child: container),
            Align(
              alignment: AlignmentDirectional.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // IntrinsicWidth(
                  //   stepWidth: 20.0,
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: emailController,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        labelText: 'email',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: Color(0xff000000),
                        ),
                        hintText: 'Enter your email',
                        // errorText: errorMessage, // Lỗi nếu có
                        // alignLabelWithHint: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff068288), width: 2),
                        ),
                      ),
                    ),
                  ),
                  // ),
                  // IntrinsicWidth(
                  //   stepWidth: 20.0,
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: TextField(
                      controller: passwordController,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        labelText: 'password',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        hintText: 'Enter your password', // Gợi ý
                        // errorText: errorMessage, // Lỗi nếu có
                        // alignLabelWithHint: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff068288), width: 2),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  // ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await ref.read(authProvider.notifier).signup(
                              emailController.text,
                              passwordController.text,
                            );
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Registration successful!')),
                        // );
                        ShowSnackBarE.showSnackBar(
                            context, 'Registration successful!');
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => LoginScreen()),
                        // );
                        context.go('/login');
                      } catch (e) {
                        print('Registration error: $e');
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(content: Text('Registration failed: $e')),
                        // );
                        ShowSnackBarE.showSnackBar(
                            context, 'Registration failed: $e');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), // Hình dạng nút là hình tròn
                      padding: const EdgeInsets.all(24), // Kích thước nút
                      backgroundColor:
                          const Color(0xff068288), // Màu nền của nút
                    ),
                    child: const Text(
                      'Signup',
                      style: TextStyle(color: Color(0xffFFCC66)),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextButton(
                      onPressed: () {
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => LoginScreen()),
                        // );
                        context.go('/login');
                      },
                      child: Text('login'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
