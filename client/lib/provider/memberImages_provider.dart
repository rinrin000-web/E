import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/provider/auth_provider.dart';
import 'package:flutter/foundation.dart';

class MemberImages {
  final int id;
  final String team_no;
  String memberfileimages;
  MemberImages(
      {required this.id,
      required this.team_no,
      required this.memberfileimages});

  factory MemberImages.fromJson(Map<String, dynamic> json) {
    return MemberImages(
      id: json['id'],
      team_no: json['team_no'],
      memberfileimages:
          'http://127.0.0.1:8000/api/memberfileimages/${json['memberfileimages']}',
    );
  }
}

class MemberImagesNotifier extends StateNotifier<List<MemberImages>> {
  MemberImagesNotifier() : super([]);

  Future<void> fetchMemberImages(teamNo) async {
    try {
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/api/memberfileimages/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        state = data
            .map((json) => MemberImages.fromJson(json))
            .where((image) => image.team_no == teamNo)
            .toList();
        print(state);
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load teams');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load teams');
    }
  }

  Future<void> updateImages(
      String? teamNo, List<Uint8List> imageBytesList) async {
    for (var imageBytes in imageBytesList) {
      try {
        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'http://127.0.0.1:8000/api/memberfileimages/update-image/$teamNo'));

        request.files.add(http.MultipartFile.fromBytes(
            'memberfileimages', imageBytes,
            filename: 'member_image.jpg'));

        var response = await request.send();

        if (response.statusCode == 201) {
          var responseData = await response.stream.bytesToString();
          var data = json.decode(responseData);
          print(data);
        } else {
          print('Failed to post data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error posting data: $e');
      }
    }
  }

  Future<void> update(int id, List<Uint8List> imageBytesList) async {
    for (var imageBytes in imageBytesList) {
      try {
        var request = http.MultipartRequest('POST',
            Uri.parse('http://127.0.0.1:8000/api/memberfileimages/$id'));

        request.files.add(http.MultipartFile.fromBytes(
            'memberfileimages', imageBytes,
            filename: 'member_image.jpg'));

        var response = await request.send();

        if (response.statusCode == 201) {
          var responseData = await response.stream.bytesToString();
          var data = json.decode(responseData);
          print(data);
        } else {
          print('Failed to post data: ${response.statusCode}');
        }
      } catch (e) {
        print('Error posting data: $e');
      }
    }
  }

  Future<void> deleteImages(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('http://127.0.0.1:8000/api/memberfileimages/$id'));
      if (response.statusCode == 200) {
        state = state.where((memberImages) => memberImages.id != id).toList();
        print("images deleted successfully");
      } else {
        throw Exception('Failed to delete images');
      }
    } catch (e) {
      throw Exception('Failed to delete images');
    }
  }
}

final memberImagesProvider =
    StateNotifierProvider<MemberImagesNotifier, List<MemberImages>>((ref) {
  return MemberImagesNotifier();
});
