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
      teamcount: json['teamcount'],
      userCount: json['userCount'],
    );
  }
}

class FloorNotifier extends StateNotifier<List<Floor>> {
  FloorNotifier() : super([]);
  final String baseUrl = 'http://127.0.0.1:8000/api/floors';
  Future<void> fetchFloor() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl'));

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
}

final floorProvider = StateNotifierProvider<FloorNotifier, List<Floor>>((ref) {
  return FloorNotifier();
});
