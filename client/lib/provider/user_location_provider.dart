import 'package:client/pages/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/pages/TeamList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String? email;
  final String? floor_no;

  User({this.email, this.floor_no});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      floor_no: json['floor_no'].toString(),
    );
  }
}

class UserLocationNotifier extends StateNotifier<List<User>> {
  UserLocationNotifier() : super([]);

  final String baseUrl = '${BaseUrlE.baseUrl}/api/user/location';

  Future<void> fetchUserLocation(String? email) async {
    final response = await http.get(Uri.parse('$baseUrl/$email'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      state = body.map((json) => User.fromJson(json)).toList();
      print(state);
    } else {
      throw Exception('Failed to load floor');
    }
  }

  Future<void> updateUserLocation(String email, String floorNo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$email'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'email': email,
        'floor_no': floorNo,
      }),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var userData = responseData['user'];
      print('User updated: ${userData['floor_no']}');
      print('User updated: ${userData['email']}');
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> clearUserLocation(String? email) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$email'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'floor_no': null, // Xóa tầng bằng cách gán null
      }),
    );

    if (response.statusCode == 200) {
      state = state.map((user) {
        if (user.email == email) {
          return User(email: user.email, floor_no: null);
        }
        return user;
      }).toList();

      print('User location cleared for $email');
    } else {
      throw Exception('Failed to clear user location');
    }
  }
}

final userLocationProvider =
    StateNotifierProvider<UserLocationNotifier, List<User>>((ref) {
  return UserLocationNotifier();
});
