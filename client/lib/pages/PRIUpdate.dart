import 'dart:io';
import 'package:client/provider/memberImages_provider.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class PRIUpdate extends ConsumerStatefulWidget {
  const PRIUpdate({Key? key}) : super(key: key);

  @override
  _PRIUpdateState createState() => _PRIUpdateState();
}

class _PRIUpdateState extends ConsumerState<PRIUpdate> {
  List<XFile>? _images = [];
  List<Uint8List> _imageBytesList = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles =
        await picker.pickMultiImage(); // For picking multiple images

    if (pickedFiles != null) {
      if (kIsWeb) {
        for (var pickedFile in pickedFiles) {
          final imageBytes = await pickedFile.readAsBytes();
          setState(() {
            _images?.add(pickedFile);
            _imageBytesList.add(imageBytes);
          });
        }
      } else {
        setState(() {
          _images?.addAll(pickedFiles);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final teamNo = ref.read(selectedTeamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _images?.length ?? 0,
                itemBuilder: (context, index) {
                  final image = _images![index];
                  return kIsWeb
                      ? Image.memory(
                          _imageBytesList[index],
                          width: 100,
                          height: 300,
                          fit: BoxFit.contain,
                        )
                      : Image.file(
                          File(image.path),
                          width: 100,
                          height: 300,
                          fit: BoxFit.contain,
                        );
                },
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _pickImages();
                });
              },
              icon: const Icon(Icons.add_outlined),
            ),
            ElevatedButton(
              onPressed: () {
                if (_imageBytesList.isNotEmpty) {
                  ref.read(memberImagesProvider.notifier).updateImages(
                        teamNo,
                        _imageBytesList,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Images uploaded successfully!')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/myhome/home/overViewEdit');
        },
        icon: const Icon(Icons.arrow_forward),
        label: Text('overViewEdit'),
      ),
    );
  }
}
