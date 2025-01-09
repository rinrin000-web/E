// import 'package:client/pages/HomeReset.dart';
// import 'package:client/provider/auth_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class ForgotPassword extends ConsumerWidget {
//   const ForgotPassword({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Controller for email input
//     final emailController = TextEditingController();

//     return Scaffold(
//       appBar: AppBar(title: const Text('Forgot Password')),
//       body: Center(
//         child: Card(
//           elevation: 0,
//           color: Colors.blue[50], // Light blue background for the card
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Email Input Field
//                 TextField(
//                   controller: emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Enter your email',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 // Reset Password Button
//                 ElevatedButton(
//                   onPressed: () async {
//                     String email = emailController.text.trim();
//                     if (email.isEmpty) {
//                       // Show an error message if email is empty
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Please enter your email.')),
//                       );
//                       return;
//                     }

//                     // Call the reset password method
//                     try {
//                       // Using the authProvider to reset the password
//                       await ref
//                           .read(authProvider.notifier)
//                           .forgotPassword(email);

//                       // // Navigate to HomeReset screen
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //     builder: (context) => HomeReset(),
//                       //   ),
//                       // );
//                     } catch (e) {
//                       // Handle errors
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error: $e')),
//                       );
//                     }
//                   },
//                   child: const Text('Reset Password'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
