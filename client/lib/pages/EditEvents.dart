import 'package:client/provider/event_provider.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class EditEvents extends ConsumerStatefulWidget {
  EditEvents({Key? key}) : super(key: key);

  @override
  _EditEventsState createState() => _EditEventsState();
}

class _EditEventsState extends ConsumerState<EditEvents> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();

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

  // bool _validateForm() {
  //   bool isValid = true;
  //   setState(() {
  //     _floorNoError =
  //         _floorController.text.isEmpty ? 'Please enter a floor number' : null;
  //     _imageError = _image == null ? 'Please select an image' : null;

  //     isValid = _floorNoError == null && _imageError == null;
  //   });
  //   return isValid;
  // }

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
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Ename',
                hintText: 'E',
                border: const UnderlineInputBorder(),
                // errorText: _floorNoError, // Hiển thị lỗi
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _eventDateController,
              decoration: InputDecoration(
                labelText: 'date',
                hintText: '2024/12/12',
                border: const UnderlineInputBorder(),
                // errorText: _floorNoError, // Hiển thị lỗi
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Image'),
            ),
            if (_image != null) ...[
              const SizedBox(height: 16),
              kIsWeb
                  ? Image.memory(
                      _imageBytes!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(_image!.path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(eventProvider.notifier).updateEvents(
                      eventId: eventId,
                      event_name: _eventNameController.text.isNotEmpty
                          ? _eventNameController.text
                          : null,
                      event_date: _eventDateController.text.isNotEmpty
                          ? _eventDateController.text
                          : null,
                      imageBytes: _imageBytes,
                    );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Event updated successfully!')),
                );
                context.pop();
              },
              child: Text('Update Event'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/event');
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
