import 'package:client/provider/event_provider.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditEvents extends ConsumerStatefulWidget {
  EditEvents({Key? key}) : super(key: key);

  @override
  _EditEventsState createState() => _EditEventsState();
}

class _EditEventsState extends ConsumerState<EditEvents> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();

  XFile? _image;
  Uint8List? _imageBytes;
  String? _imageError;

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null && pickedDate != initialDate) {
      setState(() {
        _eventDateController.text =
            "${pickedDate.toLocal()}".split(' ')[0]; // Format: yyyy-MM-dd
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ref.read(eventProvider.notifier).fetchEvent();
  }

  @override
  Widget build(BuildContext context) {
    final eventId = ref.watch(eventProvider.notifier).getSelectedEventIdSync();
    print("eventupdate :$eventId");

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Event Name',
                hintText: 'Event Name',
                border: const UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: _eventDateController,
              decoration: InputDecoration(
                labelText: 'Event Date',
                hintText: 'YYYY-MM-DD',
                border: const UnderlineInputBorder(),
              ),
              keyboardType: TextInputType.datetime,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectDate(context);
              },
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
              onPressed: () {
                // Call the updateEvents method based on image type (Web or Mobile)
                ref.read(eventProvider.notifier).updateEvents(
                      eventId: eventId,
                      event_name: _eventNameController.text.isNotEmpty
                          ? _eventNameController.text
                          : null,
                      event_date: _eventDateController.text.isNotEmpty
                          ? _eventDateController.text
                          : null,
                      imageBytes: kIsWeb ? _imageBytes : null,
                      imageFile:
                          !kIsWeb && _image != null ? File(_image!.path) : null,
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
// 