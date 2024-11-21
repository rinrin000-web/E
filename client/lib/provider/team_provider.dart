import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class TeamList {
  final String? team_no;
  final String floor;
  final double rank;
  String image;
  TeamList(
      {this.team_no,
      required this.floor,
      required this.rank,
      required this.image});

  factory TeamList.fromJson(Map<String, dynamic> json) {
    return TeamList(
      team_no: json['team_no'],
      floor: json['floor_no'].toString() + 'F', // Chuyển đổi thành floor string
      rank: json['rank'] ?? 0.0,
      image: 'http://127.0.0.1:8000/api/teams/image/${json['teamfileimages']}',
    );
  }
}

// Provider lưu trữ team_no của đội được chọn
final selectedTeamProvider = StateProvider<String?>((ref) => null);

class TeamNotifier extends StateNotifier<List<TeamList>> {
  TeamNotifier() : super([]);

  Future<void> fetchTeams() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/teams'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        state = data.map((json) => TeamList.fromJson(json)).toList();
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

  void searchByTeamNo(String teamNo) {
    if (teamNo.isEmpty) {
      fetchTeams();
    } else {
      state = state
          .where((team) => team.team_no?.contains(teamNo) ?? false)
          .toList();
    }
  }

  Future<void> getRank(String? teamNo) async {
    try {
      // Send the request to the API
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/api/teams/getRank/$teamNo'));

      // Log the response body for debugging
      print('API Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final teamIndex = state.indexWhere((team) => team.team_no == teamNo);
        if (teamIndex != -1) {
          // Kiểm tra xem rank có thực sự thay đổi hay không
          final newRank = data['rank'] ?? 0.0;
          if (state[teamIndex].rank != newRank) {
            print('State before update: ${state[teamIndex]}');

            // Cập nhật team với rank mới
            state[teamIndex] = TeamList(
              team_no: state[teamIndex].team_no,
              floor: state[teamIndex].floor,
              rank: newRank, // Cập nhật rank
              image: state[teamIndex].image,
            );

            // Đặt lại state để cập nhật UI
            state = List.from(state);

            print('State after update: ${state[teamIndex]}');
          } else {
            print('Rank không thay đổi, không cần cập nhật state');
          }
        } else {
          print('Không tìm thấy team trong state');
        }
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load rank');
    }
  }
}

// Đăng ký provider với Riverpod
final teamListProvider =
    StateNotifierProvider<TeamNotifier, List<TeamList>>((ref) {
  return TeamNotifier();
});

// final rankStreamProvider =
//     StreamProvider.family<TeamList?, String?>((ref, teamNo) {
//   return Stream.periodic(const Duration(seconds: 10), (_) async {
//     final response = await http
//         .get(Uri.parse('http://127.0.0.1:8000/api/teams/getRank/$teamNo'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return TeamList.fromJson(data);
//     } else {
//       throw Exception('Failed to load team rank');
//     }
//   }).asyncMap((event) => event); // Chuyển đổi sang stream
// });
