import 'package:client/pages/constants.dart';
import 'package:client/provider/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DeleteAdmin extends ConsumerStatefulWidget {
  const DeleteAdmin({Key? key}) : super(key: key);

  @override
  _DeleteAdminState createState() => _DeleteAdminState();
}

class _DeleteAdminState extends ConsumerState<DeleteAdmin> {
  final TextEditingController _emailController = TextEditingController();
  String _message = '';

  void _searchEmail(String keyword) {
    ref.read(userLocationProvider.notifier).fetchSuggestions(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final emailSuggestions = ref.watch(userLocationProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'ユーザーの管理者権限を削除する',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ColorE.headerColorE),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _emailController,
              onChanged: _searchEmail, // Gọi hàm tìm kiếm khi người dùng nhập
              decoration: InputDecoration(
                labelText: 'メールアドレス入力してください',
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: emailSuggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        '${emailSuggestions[index].email}'), // Hiển thị email
                    onTap: () {
                      _emailController.text =
                          '${emailSuggestions[index].email}';
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          // Nút thứ nhất
          Positioned(
            bottom: 0,
            right: 5,
            child: FloatingActionButton(
              onPressed: () {
                try {
                  ref
                      .read(userLocationProvider.notifier)
                      .deleteRole(_emailController.text);
                  ShowSnackBarE.showSnackBar(context, 'ユーザーの管理者権限を削除する');
                } catch (e) {
                  ShowSnackBarE.showSnackBar(context, '失敗しました');
                }
              },
              child: Icon(Icons.check),
            ),
          ),
          // Nút thứ hai
          Positioned(
            bottom: 0,
            left: 30,
            child: FloatingActionButton(
              onPressed: () {
                context.go('/myhome/home/member_manage');
              },
              child: Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
