import 'package:client/pages/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/pages/TeamList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Emanage {
  final int event_id;
  final String floor_no;
  final int fakeUsercount;
  Emanage({
    required this.event_id,
    required this.fakeUsercount,
    required this.floor_no,
  });
  factory Emanage.fromJson(Map<String, dynamic> json) {
    return Emanage(
      event_id: json['event_id'],
      floor_no: json['floor_no'].toString(),
      fakeUsercount: json['fakeUsercount'] ?? 0,
    );
  }
}

class EmanageNotifier extends StateNotifier<List<Emanage>> {
  EmanageNotifier() : super([]);
  final String baseUrl = '${BaseUrlE.baseUrl}/api/floors';
  Future<void> fetchFakeUserCount(int? eventId) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/getfakeUserCount/$eventId'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        state = body.map((json) => Emanage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load fakeUserCount');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load fakeUserCount');
    }
  }

  Future<Emanage> updateFakeUserCount(
      String floorNo, int event_id, int fakeUsercount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updateFakeUserCount/$floorNo/$event_id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          // 'floor_no': floor_no,
          'fakeUsercount': fakeUsercount,
        }),
      );
      if (response.statusCode == 200) {
        // List<dynamic> body = json.decode(response.body);
        // state = body.map((json) => Floor.fromJson(json)).toList();
        return Emanage.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create fakeUserCount');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load fakeUserCount');
    }
  }

  Future<void> resetFakeUserCount(int event_id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/resetFakeUserCount/$event_id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print('Successfully reset fake user counts');
      } else {
        print('Failed to reset fake user counts');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load floor');
    }
  }
}

final emanageProvider =
    StateNotifierProvider<EmanageNotifier, List<Emanage>>((ref) {
  return EmanageNotifier();
});
