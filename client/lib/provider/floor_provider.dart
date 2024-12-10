import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/pages/TeamList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Floor {
  // final int id;
  final String floor_no;
  final String? contents;
  final int teamcount;
  final int userCount;
  Floor(
      {required this.floor_no,
      this.contents,
      required this.teamcount,
      required this.userCount});
  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      floor_no: json['floor_no'].toString(),
      contents: json['contents'],
      teamcount: json['teamcount'] ?? 0,
      userCount: json['userCount'] ?? 0,
    );
  }
}

class FloorNotifier extends StateNotifier<List<Floor>> {
  FloorNotifier() : super([]);
  final String baseUrl = 'http://127.0.0.1:8000/api/floors';
  Future<void> fetchFloor(int? eventId) async {
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

  Future<Floor> createFloor(String floor_no, String contents) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'floor_no': floor_no,
          'contents': contents,
        }),
      );
      if (response.statusCode == 200) {
        // List<dynamic> body = json.decode(response.body);
        // state = body.map((json) => Floor.fromJson(json)).toList();
        return Floor.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create floor');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load floor');
    }
  }

  Future<Floor> updateFloor(String floor_no, String contents) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$floor_no'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          // 'floor_no': floor_no,
          'contents': contents,
        }),
      );
      if (response.statusCode == 200) {
        // List<dynamic> body = json.decode(response.body);
        // state = body.map((json) => Floor.fromJson(json)).toList();
        return Floor.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create floor');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load floor');
    }
  }

  Future<void> deleteFloors(String floor_no) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$floor_no'));
      if (response.statusCode == 200) {
        state = state.where((floors) => floors.floor_no != floor_no).toList();
        print("floor_no deleted successfully");
      } else {
        throw Exception('Failed to delete floor_no');
      }
    } catch (e) {
      throw Exception('Failed to delete floor_no');
    }
  }
}

final floorProvider = StateNotifierProvider<FloorNotifier, List<Floor>>((ref) {
  return FloorNotifier();
});
