import 'package:client/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class NewEventSetting extends StatefulWidget {
  const NewEventSetting({Key? key}) : super(key: key);

  @override
  _NewEventSettingState createState() => _NewEventSettingState();
}

class _NewEventSettingState extends State<NewEventSetting> {
  DateTime _date = DateTime.now();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  XFile? _image;
  Uint8List? _imageBytes; // Lưu trữ ảnh dưới dạng bytes cho web

  // Biến trạng thái cho lỗi
  String? _enameError;
  String? _dateError;
  String? _imageError;

  Future<void> _pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDate != null) {
      setState(() {
        _date = newDate;
        _dateError = null; // Xóa lỗi nếu chọn ngày thành công
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _image = pickedFile;
          _imageBytes = imageBytes;
          _imageError = null; // Xóa lỗi nếu chọn ảnh thành công
        });
      } else {
        setState(() {
          _image = pickedFile;
          _imageError = null; // Xóa lỗi nếu chọn ảnh thành công
        });
      }
    }
  }

  Future<void> _submitEvent() async {
    setState(() {
      // Kiểm tra và cập nhật lỗi
      _enameError = _eventNameController.text.isEmpty
          ? 'Please enter an event name'
          : null;
      _dateError = _date == null ? 'Please select a date' : null;
      _imageError = _image == null ? 'Please pick an image' : null;
    });

    // Nếu có lỗi, không gửi yêu cầu
    if (_enameError != null || _dateError != null || _imageError != null) {
      return;
    }

    final uri = Uri.parse('http://127.0.0.1:8000/api/events');

    var request = http.MultipartRequest('POST', uri)
      ..fields['event_name'] = _eventNameController.text
      ..fields['event_date'] = '${_date.year}-${_date.month}-${_date.day}'
      ..fields['event_description'] = _eventDescriptionController.text;

    if (_image != null && !kIsWeb) {
      var imageFile = await http.MultipartFile.fromPath('images', _image!.path);
      request.files.add(imageFile);
    } else if (_imageBytes != null && kIsWeb) {
      request.files.add(http.MultipartFile.fromBytes(
        'images',
        _imageBytes!,
        filename: 'image.jpg',
      ));
    }

    final response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully!')),
      );
      context.go('/event');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to create event: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Ename',
                hintText: 'E展名前を記入してください。',
                border: const UnderlineInputBorder(),
                errorText: _enameError, // Hiển thị lỗi
              ),
            ),
            TextFormField(
              controller: _eventDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Event Description',
                hintText: 'Enter event description...',
                border: UnderlineInputBorder(),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: '${_date.year}-${_date.month}-${_date.day}',
                border: const UnderlineInputBorder(),
                errorText: _dateError, // Hiển thị lỗi
              ),
              onTap: () => _pickDate(context),
              readOnly: true,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.blue,
                child: Text(
                  _image == null ? "Pick Image" : "Image Selected",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            if (_imageError != null)
              Text(
                _imageError!,
                style: const TextStyle(color: Colors.red),
              ),
            if (_image != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: kIsWeb
                    ? Image.memory(_imageBytes!, height: 200)
                    : Image.file(File(_image!.path), height: 200),
              ),
            ElevatedButton(
              onPressed: () {
                _submitEvent();
                // context.go('/event');
              },
              child: const Text('Submit Event'),
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
