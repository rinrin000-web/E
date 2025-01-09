// import 'package:client/LoginScreen.dart';
// import 'package:client/provider/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class HomeReset extends ConsumerWidget {
//   final TextEditingController _emailController = TextEditingController();

//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     void _resetPassword() {
//       String password = _passwordController.text;
//       String confirmPassword = _confirmPasswordController.text;

//       if (password != confirmPassword) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Passwords do not match')),
//         );
//         return;
//       }
//       ref.read(authProvider.notifier).resetPassword(
//           _emailController.text, _passwordController.text, token);
//     }

//     return Scaffold(
//       appBar: AppBar(title: Text('Reset Password')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'New Password',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _confirmPasswordController,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Confirm Password',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _resetPassword,
//               child: Text('Reset Password'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
