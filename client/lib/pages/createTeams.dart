import 'package:client/pages/constants.dart';
import 'package:client/provider/auth_provider.dart';
import 'package:client/provider/event_provider.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateTeams extends ConsumerStatefulWidget {
  CreateTeams({Key? key}) : super(key: key);

  @override
  _CreateTeamsState createState() => _CreateTeamsState();
}

class _CreateTeamsState extends ConsumerState<CreateTeams> {
  final TextEditingController _teamNoController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  String? _teamNoError;
  String? _floorNoError;
  String? _imageError;

  XFile? _image;
  Uint8List? _imageBytes;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _image = pickedFile;
          _imageBytes = imageBytes;
          _imageError = null;
        });
      } else {
        setState(() {
          _image = pickedFile;
          _imageError = null;
        });
      }
    }
  }

  bool _validateForm() {
    bool isValid = true;
    setState(() {
      _teamNoError =
          _teamNoController.text.isEmpty ? 'Please enter a team number' : null;
      _floorNoError =
          _floorController.text.isEmpty ? 'Please enter a floor number' : null;
      _imageError = _image == null ? 'Please select an image' : null;

      isValid =
          _teamNoError == null && _floorNoError == null && _imageError == null;
    });
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _teamNoController,
              decoration: InputDecoration(
                labelText: 'Team Number',
                hintText: 'I24-001',
                border: const UnderlineInputBorder(),
                errorText: _teamNoError, // Hiển thị lỗi
              ),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _floorController,
              decoration: InputDecoration(
                labelText: 'Floor Number',
                hintText: '7',
                border: const UnderlineInputBorder(),
                errorText: _floorNoError, // Hiển thị lỗi
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            if (_image != null) ...[
              SizedBox(height: 16.h),
              kIsWeb
                  ? Image.memory(
                      _imageBytes!,
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(_image!.path),
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                    ),
            ],
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () async {
                if (_validateForm()) {
                  try {
                    await ref.read(teamListProvider.notifier).createTeams(
                          eventId,
                          _teamNoController.text,
                          _floorController.text,
                          _imageBytes ?? File(_image!.path).readAsBytesSync(),
                        );
                    ref
                        .read(teamListProvider.notifier)
                        .selectTeam(_teamNoController.text);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(
                    //       content: Text('Team created successfully!')),
                    // );
                    ShowSnackBarE.showSnackBar(context, 'チームの作成に成功しました');
                    context.go('/myhome/home/profifeIma');
                  } catch (e) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(content: Text('Failed to create team: $e')),
                    // );
                    ShowSnackBarE.showSnackBar(context, 'エーラ:$e');
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     // if (_validateForm()) {
      //     //   ref.read(teamListProvider.notifier).createTeams(
      //     //         eventId,
      //     //         _teamNoController.text,
      //     //         _floorController.text,
      //     //         _imageBytes!,
      //     //       );
      //     context.go('/myhome/home/profifeIma');
      //     // final user = ref.read(authProvider).commentUser;
      //     // print('user:$user');
      //     // ref.read(selectedTeamProvider.notifier).state =
      //     //     _teamNoController.text;
      //     // ref
      //     //     .read(teamListProvider.notifier)
      //     //     .selectTeam(_teamNoController.text);
      //     // ScaffoldMessenger.of(context).showSnackBar(
      //     //   const SnackBar(content: Text('Team created successfully!')),
      //     // );
      //     // }
      //   },
      //   icon: const Icon(Icons.arrow_forward),
      //   label: Text('memeberImagesSet'),
      // ),
    );
  }
}
