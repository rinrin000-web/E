import 'package:client/pages/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/pages/TeamList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Floor {
  // final int id;
  final String floor_no;
  final String? contents;
  final int fakeusercount;
  final int teamcount;
  final int userCount;
  Floor(
      {required this.floor_no,
      this.contents,
      required this.fakeusercount,
      required this.teamcount,
      required this.userCount});
  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      floor_no: json['floor_no'].toString(),
      contents: json['contents'],
      fakeusercount: json['fakeusercount'] ?? 0,
      teamcount: json['teamcount'] ?? 0,
      userCount: json['userCount'] ?? 0,
    );
  }
}

class FloorNotifier extends StateNotifier<List<Floor>> {
  FloorNotifier() : super([]);
  final String baseUrl = '${BaseUrlE.baseUrl}/api/floors';
  Future<void> fetchFloor(int? eventId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$eventId'));
      print('eventid cus floors: $eventId');
      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        state = body.map((json) => Floor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load floor');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load floor');
    }
  }

  Future<void> fetchFloorcount(int? eventId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/getFloorTeamCount/$eventId'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        state = body.map((json) => Floor.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load floor');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load floor');
    }
  }

  Future<void> createFloor(int eventId, String floorNo, String contents) async {
    final url = Uri.parse('${baseUrl}/$eventId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'floor_no': floorNo,
        'contents': contents,
      }),
    );

    if (response.statusCode == 200) {
      // Floor created successfully
      final data = jsonDecode(response.body);
      if (data is Map) {
        print('Floor created: ${data['floor']}');
      } else {
        print('Error: Response is not a valid Map');
      }
    } else {
      print('Error: ${response.body}');
    }
  }

  Future<void> updateFloor(String floorNo, int eventId, String contents) async {
    final url = Uri.parse('${baseUrl}/$floorNo/$eventId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': contents,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // Đảm bảo dữ liệu trả về là Map
      if (data is Map) {
        print('Floor updated: ${data['floor']}');
      } else {
        print('Error: Response is not a valid Map');
      }
    } else {
      print('Error: ${response.body}');
    }
  }

  // Future<Floor> updateFloor(String floor_no, String contents) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/$floor_no'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         // 'floor_no': floor_no,
  //         'contents': contents,
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       // List<dynamic> body = json.decode(response.body);
  //       // state = body.map((json) => Floor.fromJson(json)).toList();
  //       return Floor.fromJson(json.decode(response.body));
  //     } else {
  //       throw Exception('Failed to create floor');
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e');
  //     throw Exception('Failed to load floor');
  //   }
  // }

  // Future<void> deleteFloors(String floorNo) async {
  //   try {
  //     final response = await http
  //         .delete(Uri.parse('http://127.0.0.1:8000/api/floors/$floorNo'));
  //     if (response.statusCode == 200) {
  //       // Xóa thành công
  //       print('Floor deleted successfully');
  //     } else {
  //       // Lỗi chi tiết từ server
  //       print('Failed to delete floor: ${response.body}');
  //       throw Exception('Failed to delete floor');
  //     }
  //   } catch (e) {
  //     print('Error deleting floor: $e');
  //     rethrow;
  //   }
  // }

  Future<void> deleteFloor(String floorNo, int eventId) async {
    final url = Uri.parse('${baseUrl}/$floorNo/$eventId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      // Floor deleted successfully
      final data = jsonDecode(response.body);
      print('Floor deleted: ${data['message']}');
    } else {
      print('Error: ${response.body}');
    }
  }

  Future<void> resetFakeUserCount(int eventId) async {
    final url = Uri.parse('${baseUrl}/reset/reset/$eventId');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      // Fake user count reset successfully
      final data = jsonDecode(response.body);
      print('Message: ${data['message']}');
    } else {
      print('Error: ${response.body}');
    }
  }

  Future<void> updateFakeUserCount(
      String floorNo, int eventId, int fakeuserCount) async {
    final url = Uri.parse('${baseUrl}/updateUserCount/$floorNo/$eventId');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fakeusercount': fakeuserCount,
      }),
    );

    if (response.statusCode == 200) {
      // Update floor's fake user count successfully
      final data = jsonDecode(response.body);
      print('Fake user count updated: ${data['floor']}');

      // Update the state to reflect the change in fakeusercount
      _updateFakeUserCountInState(floorNo, fakeuserCount);
    } else {
      print('Error: ${response.body}');
    }
  }

  // Update fake user count in the local state
  void _updateFakeUserCountInState(String floorNo, int fakeuserCount) {
    state = [
      for (var floor in state)
        if (floor.floor_no == floorNo)
          Floor(
            floor_no: floor.floor_no,
            contents: floor.contents,
            fakeusercount: fakeuserCount,
            teamcount: floor.teamcount,
            userCount: floor.userCount,
          )
        else
          floor
    ];
  }
}

final floorProvider = StateNotifierProvider<FloorNotifier, List<Floor>>((ref) {
  return FloorNotifier();
});
