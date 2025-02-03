import 'dart:io';
import 'package:client/pages/constants.dart';
import 'package:client/provider/memberImages_provider.dart';
import 'package:client/provider/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PRIUpdate extends ConsumerStatefulWidget {
  const PRIUpdate({Key? key}) : super(key: key);

  @override
  _PRIUpdateState createState() => _PRIUpdateState();
}

class _PRIUpdateState extends ConsumerState<PRIUpdate> {
  List<XFile>? _newImages = []; // Danh sách ảnh mới được chọn
  List<Uint8List> _newImageBytesList = []; // Danh sách bytes ảnh mới

  @override
  void initState() {
    super.initState();
    // Load ảnh từ API
    final teamNo = ref.read(selectedTeamProvider);
    ref.read(memberImagesProvider.notifier).fetchMemberImages(teamNo);
  }

  @override
  Widget build(BuildContext context) {
    final teamNo = ref.read(selectedTeamProvider);
    final memberImagesList = ref.watch(memberImagesProvider); // Ảnh từ API

    // Kết hợp ảnh từ API và ảnh mới
    // final combinedImages = [
    //   ...memberImagesList.map((img) => img.memberfileimages),
    //   ..._newImages?.map((img) => kIsWeb ? null : img.path) ?? [],
    // ];
    final combinedImages = [
      ...memberImagesList.map((img) => img.memberfileimages), // Ảnh từ API
      ..._newImages?.map((img) => kIsWeb ? null : img.path) ??
          [], // Ảnh mới từ mobile nếu không phải web
      ..._newImageBytesList, // Ảnh mới từ web (dùng bytes)
    ];

    Future<void> _pickImage(int index, bool isApiImage) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (kIsWeb) {
          // Flutter Web: sử dụng readAsBytes()
          final imageBytes = await pickedFile.readAsBytes();
          setState(() {
            if (isApiImage) {
              ref.read(memberImagesProvider.notifier).update(
                memberImagesList[index].id,
                [imageBytes], // Sử dụng bytes trực tiếp thay vì File
              ).then((_) {
                ref
                    .read(memberImagesProvider.notifier)
                    .fetchMemberImages(teamNo);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Images uploaded successfully!')),
              );
            } else if (index >= 0) {
              final localIndex = index - memberImagesList.length;
              if (localIndex >= 0 && localIndex < _newImageBytesList.length) {
                // _newImages![localIndex] = pickedFile;
                _newImageBytesList[localIndex] = imageBytes;
              }
            } else {
              // _newImages?.add(pickedFile);
              _newImageBytesList.add(imageBytes);
            }
          });
        } else {
          // Mobile/Desktop: sử dụng File API
          setState(() {
            if (isApiImage) {
              ref.read(memberImagesProvider.notifier).update(
                memberImagesList[index].id,
                [File(pickedFile.path).readAsBytesSync()],
              );
            } else if (index >= 0) {
              final localIndex = index - memberImagesList.length;
              if (localIndex >= 0 && localIndex < _newImages!.length) {
                _newImages![localIndex] = pickedFile;
              }
            } else {
              _newImages?.add(pickedFile);
            }
          });
        }
      }
    }

    void _removeImage(int index, bool isApiImage) {
      setState(() {
        if (isApiImage) {
          ref
              .read(memberImagesProvider.notifier)
              .deleteImages(memberImagesList[index].id);
        } else {
          final localIndex = index - ref.read(memberImagesProvider).length;
          _newImages?.removeAt(localIndex);
          if (kIsWeb) _newImageBytesList.removeAt(localIndex);
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: combinedImages.length + 1, // +1 cho nút thêm ảnh
                itemBuilder: (context, index) {
                  if (index == combinedImages.length) {
                    // Nút thêm ảnh ở cuối danh sách
                    return IconButton(
                      onPressed: () => _pickImage(-1, false), // Thêm ảnh mới
                      icon: const Icon(Icons.add_outlined),
                      iconSize: 40,
                      color: Colors.blue,
                    );
                  }

                  // Hiển thị ảnh từ API hoặc ảnh mới
                  final imageUrl = combinedImages[index];
                  final isApiImage = index < memberImagesList.length;

                  return Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _pickImage(index, isApiImage),
                            icon: const Icon(Icons.edit, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () => _removeImage(index, isApiImage),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: isApiImage
                            ? Image.network(
                                memberImagesList[index].memberfileimages,
                                width: 1.sw,
                                height: 250.h,
                                fit: BoxFit.contain,
                              )
                            : (kIsWeb && !isApiImage
                                ? Image.memory(
                                    _newImageBytesList.isNotEmpty &&
                                            (index - memberImagesList.length) <
                                                _newImageBytesList.length
                                        ? _newImageBytesList[
                                            index - memberImagesList.length]
                                        : Uint8List(
                                            0), // Tránh lỗi khi không có ảnh
                                    width: 1.sw,
                                    height: 250.h,
                                    fit: BoxFit.contain,
                                  )
                                : (!kIsWeb && !isApiImage)
                                    ? Image.file(
                                        File(
                                          _newImages != null &&
                                                  (index -
                                                          memberImagesList
                                                              .length) <
                                                      _newImages!.length
                                              ? _newImages![index -
                                                      memberImagesList.length]
                                                  .path
                                              : '',
                                        ),
                                        width: 1.sw,
                                        height: 250.h,
                                        fit: BoxFit.contain,
                                      )
                                    : const SizedBox()), // Trường hợp không thỏa điều kiện nào, trả về widget trống
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                try {
                  if (kIsWeb) {
                    ref.read(memberImagesProvider.notifier).updateImages(
                          teamNo,
                          _newImageBytesList,
                        );
                  } else {
                    List<Uint8List> byteImages = _newImages!.map((file) {
                      return File(file.path).readAsBytesSync();
                    }).toList();

                    ref.read(memberImagesProvider.notifier).updateImages(
                          teamNo,
                          byteImages, // Pass the bytes for mobile/desktop
                        );
                  }
                  ShowSnackBarE.showSnackBar(context, '更新しました');
                } catch (e) {
                  ShowSnackBarE.showSnackBar(context, 'Error: $e');
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
        label: const Text('overViewEdit'),
      ),
    );
  }
}
