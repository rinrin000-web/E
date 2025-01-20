import 'package:client/pages/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/pages/TeamList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Overview {
  // final int id;
  final String? team_no;
  final String? slogan;
  final String? overallplanning;
  final String? techused;
  final String? tools;

  Overview({
    // required this.id,
    this.team_no,
    this.slogan,
    this.overallplanning,
    this.techused,
    this.tools,
  });
  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      team_no: json['team_no'],
      slogan: json['slogan'],
      overallplanning: json['overallplanning'],
      techused: json['techused'],
      tools: json['tools'],
    );
  }
}

class OverviewNotifier extends StateNotifier<List<Overview>> {
  OverviewNotifier() : super([]);
  final String baseUrl = '${BaseUrlE.baseUrl}/api/overviews';
  Future<List<Overview>> fetchOverview(String? teamNo) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$teamNo'));

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        print('Response data: $body');
        return body.map((json) => Overview.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load overviews');
      }
    } catch (e) {
      print('Error occurred: $e');
      throw Exception('Failed to load overviews');
    }
  }

  Future<Overview> createOverview(String? team_no, String slogan,
      String overallplanning, String techused, String tools) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$team_no'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        // 'team_no': team_no,
        'slogan': slogan,
        'overallplanning': overallplanning,
        'techused': techused,
        'tools': tools,
      }),
    );

    if (response.statusCode == 201) {
      return Overview.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create overview');
    }
  }

  Future<Overview> updateOverview(String? teamNo, String slogan,
      String overallplanning, String techused, String tools) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$teamNo'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'slogan': slogan,
        'overallplanning': overallplanning,
        'techused': techused,
        'tools': tools,
      }),
    );

    if (response.statusCode == 201) {
      return Overview.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create overview');
    }
  }
}

final overviewProvider =
    StateNotifierProvider<OverviewNotifier, List<Overview>>((ref) {
  return OverviewNotifier();
});
