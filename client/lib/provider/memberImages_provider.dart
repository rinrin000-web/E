import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/provider/auth_provider.dart';

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
}

final memberImagesProvider =
    StateNotifierProvider<MemberImagesNotifier, List<MemberImages>>((ref) {
  return MemberImagesNotifier();
});
