import 'package:client/pages/constants.dart';
import 'package:client/provider/event_provider.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateTeams extends ConsumerStatefulWidget {
  UpdateTeams({Key? key}) : super(key: key);

  @override
  _UpdateTeamsState createState() => _UpdateTeamsState();
}

class _UpdateTeamsState extends ConsumerState<UpdateTeams> {
  final TextEditingController _floorController = TextEditingController();

  // String? _floorNoError;
  // String? _imageError;

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
          // _imageError = null;
        });
      } else {
        setState(() {
          _image = pickedFile;
          // _imageError = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
    final teamNo = ref.read(selectedTeamProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _floorController,
              decoration: InputDecoration(
                labelText: 'Floor Number',
                hintText: '7',
                border: const UnderlineInputBorder(),
                // errorText: _floorNoError, // Hiển thị lỗi
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
                // if (_validateForm()) {
                try {
                  await ref.read(teamListProvider.notifier).updateTeams(
                        eventId!,
                        teamNo,
                        floorNo: _floorController.text.isNotEmpty
                            ? _floorController.text
                            : null,
                        imageBytes:
                            _imageBytes ?? File(_image!.path).readAsBytesSync(),
                      );
                  ShowSnackBarE.showSnackBar(
                      context, 'Team created successfully!');
                } catch (e) {
                  ShowSnackBarE.showSnackBar(context, 'Error :$e');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/myhome/home/profifeIma');
          print('context: $context');
        },
        icon: const Icon(Icons.arrow_forward),
        label: Text('memeberImagesSet'),
      ),
    );
  }
}
