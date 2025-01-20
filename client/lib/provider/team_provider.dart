import 'package:client/pages/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeamList {
  final String? team_no;
  final String floor;
  final double rank;
  final String teamfileimages;
  TeamList(
      {this.team_no,
      required this.floor,
      required this.rank,
      required this.teamfileimages});

  factory TeamList.fromJson(Map<String, dynamic> json) {
    return TeamList(
      team_no: json['team_no'],
      floor: json['floor_no'].toString() + 'F', // Chuyển đổi thành floor string
      rank: (json['rank'] is int
              ? (json['rank'] as int).toDouble()
              : json['rank']) ??
          0.0,
      teamfileimages: '${BaseUrlE.baseUrl}/api/teams/${json['teamfileimages']}',
    );
  }

  @override
  String toString() {
    return 'TeamList(team_no: $team_no, floor: $floor, rank: $rank)';
  }
}

final selectedTeamProvider = StateProvider<String?>((ref) => null);

class TeamNotifier extends StateNotifier<List<TeamList>> {
  TeamNotifier(this.ref) : super([]) {
    _initializeState();
  }

  final Ref ref;

  /// Initialize state from SharedPreferences
  Future<void> _initializeState() async {
    await _loadSelectedTeam(); // Load selected team from SharedPreferences
  }

  // Load selected team from SharedPreferences
  Future<void> _loadSelectedTeam() async {
    final prefs = await SharedPreferences.getInstance();
    final selectedTeamNo = prefs.getString('selectedTeamNo');
    if (selectedTeamNo != null) {
      ref.read(selectedTeamProvider.notifier).state =
          selectedTeamNo; // Đồng bộ giá trị
    }
  }

  // Cập nhật selected team khi giá trị thay đổi
  Future<void> _updateSelectedTeam(String teamNo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedTeamNo', teamNo);
  }

  void selectTeam(String teamNo) async {
    await _updateSelectedTeam(teamNo);
    ref.read(selectedTeamProvider.notifier).state =
        teamNo; // Đồng bộ selectedTeamProvider
    state = state.map((team) {
      return team;
    }).toList(); // Rebuild the state
  }

  Future<void> fetchTeamsbyId(int? id) async {
    try {
      final response =
          await http.get(Uri.parse('${BaseUrlE.baseUrl}/api/teams/events/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Kiểm tra xem 'teams' có tồn tại trong dữ liệu không
        if (data.containsKey('teams')) {
          final List<dynamic> teamsData = data['teams'];
          state = teamsData.map((json) => TeamList.fromJson(json)).toList();
          print(state);
        } else {
          print('Không tìm thấy dữ liệu teams trong phản hồi');
          throw Exception('No teams found in the response');
        }
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
        throw Exception('Failed to load teams');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load teams');
    }
  }

  Future<void> createTeams(
      int? eventId, String teamNo, String floorNo, Uint8List imageBytes) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('${BaseUrlE.baseUrl}/api/teams/$eventId'))
        ..fields['team_no'] = teamNo
        ..fields['floor_no'] = floorNo
        ..files.add(http.MultipartFile.fromBytes('teamfileimages', imageBytes,
            filename: 'team_image.jpg'));

      var response = await request.send();

      if (response.statusCode == 200) {
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

  Future<void> updateTeams(String? teamNo,
      {String? floorNo, Uint8List? imageBytes}) async {
    try {
      var request = http.MultipartRequest('POST',
          Uri.parse('${BaseUrlE.baseUrl}/api/teams/update-image/$teamNo'));

      if (floorNo != null && floorNo.isNotEmpty) {
        request.fields['floor_no'] = floorNo;
      }

      if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'teamfileimages',
          imageBytes,
          filename: 'team_image.jpg',
        ));
      }

      var response = await request.send();

      if (response.statusCode == 200) {
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

  Future<void> deleteTeams(String? team_no) async {
    try {
      final response = await http
          .delete(Uri.parse('${BaseUrlE.baseUrl}/api/teams/$team_no'));
      if (response.statusCode == 200) {
        // Remove the deleted event from the state
        state = state.where((teams) => teams.team_no != team_no).toList();
        print("teams deleted successfully");
      } else {
        throw Exception('Failed to delete event');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to delete event');
    }
  }

  // Future<void> searchByTeamNo(String teamNo, int? eventId) async {
  //   try {
  //     if (teamNo.isEmpty) {
  //       await fetchTeamsbyId(eventId);
  //     } else {
  //       state = state.where((team) => team.team_no!.contains(teamNo)).toList();

  //       if (state.isEmpty) {
  //         await fetchTeamsbyId(eventId);
  //         state = state.where((team) => team.team_no == teamNo).toList();
  //       }
  //     }
  //   } catch (e) {
  //     print('Error searching by team_no: $e');
  //   }
  // }
  Future<void> searchByTeamNo(String teamNo, int? eventId) async {
    try {
      if (teamNo.isEmpty) {
        await fetchTeamsbyId(eventId);
      } else {
        final searchResult =
            state.where((team) => team.team_no!.contains(teamNo)).toList();

        if (searchResult.isEmpty) {
          // Nếu không tìm thấy team nào, giữ nguyên trạng thái state
          print(
              'No team found with team_no: $teamNo. Keeping previous display.');
        } else {
          // Nếu tìm thấy team, cập nhật state
          state = searchResult;
        }
      }
    } catch (e) {
      print('Error searching by team_no: $e');
    }
  }

  Future<void> getRank(String? teamNo, int? id) async {
    try {
      // Send the request to the API
      final response = await http
          .get(Uri.parse('${BaseUrlE.baseUrl}/api/teams/getRank/$teamNo/$id'));

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
              teamfileimages: state[teamIndex].teamfileimages,
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
  return TeamNotifier(ref);
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
