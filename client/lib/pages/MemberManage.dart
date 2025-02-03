import 'package:client/pages/constants.dart';
import 'package:client/provider/user_location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MemberManage extends ConsumerStatefulWidget {
  const MemberManage({Key? key}) : super(key: key);

  @override
  _MemberManageState createState() => _MemberManageState();
}

class _MemberManageState extends ConsumerState<MemberManage> {
  @override
  void initState() {
    super.initState();
    ref.read(userLocationProvider.notifier).fetchUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final userE = ref.watch(userLocationProvider); // Lấy danh sách người dùng
    final admins = userE.where((user) => user.isAdmin == 1).toList();
    final users = userE.where((user) => user.isAdmin == 0).toList();
    print("userE: ${userE.length}");
    print("admin: $admins");
    final rowCount =
        (admins.length > users.length) ? admins.length : users.length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Center(
              child: const Text(
                'メンバー権管理',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorE.headerColorE),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ClipRRect(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: ColorE.headerColorE),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Table(
                  border:
                      TableBorder.all(color: const Color(0xff068288), width: 1),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    // Hàng tiêu đề
                    TableRow(children: [
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                '管理者',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      context.go('/myhome/home/add_admin');
                                    },
                                    icon: Icon(Icons.add_outlined),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context.go('/myhome/home/delete_admin');
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              )
                            ],
                          )),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 50.0),
                        child: Text(
                          'ユーザ',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                    // Duyệt qua từng hàng và thêm dữ liệu
                    for (int i = 0; i < rowCount; i++)
                      TableRow(children: [
                        // Cột Admin
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            i < admins.length && admins[i].email != null
                                ? '${admins[i].email}'
                                : 'N/A',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Cột User
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            i < users.length && users[i].email != null
                                ? '${users[i].email}'
                                : 'N/A',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
