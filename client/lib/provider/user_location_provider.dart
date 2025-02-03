import 'package:client/pages/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/pages/TeamList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String? email;
  final String? floor_no;
  final int? isAdmin;

  User({this.email, this.floor_no, this.isAdmin});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      floor_no: json['floor_no'].toString(),
      isAdmin: json['is_admin'] != null
          ? int.tryParse(json['is_admin'].toString()) ?? 0
          : 0,
    );
  }
}

class UserLocationNotifier extends StateNotifier<List<User>> {
  UserLocationNotifier() : super([]);

  final String baseUrl = '${BaseUrlE.baseUrl}/api/user/location';

  Future<void> fetchUserLocation() async {
    final response = await http.get(Uri.parse('$baseUrl'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      state = body.map((json) => User.fromJson(json)).toList();
      try {
        var data = jsonDecode(response.body);
        if (data['message'] is String) {
          print('Message: ${data['message']}');
        } else {
          print('Unexpected message format');
        }
      } catch (e) {
        print('Error parsing message: $e');
      }
    } else {
      throw Exception('Failed to load floor');
    }
  }

  Future<List<User>> fetchAdmin() async {
    final response = await http.get(Uri.parse('$baseUrl/isAdmin'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['isAdmin'];
      return data.map<User>((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load admins');
    }
  }

  Future<List<User>> fetchUser() async {
    final response = await http.get(Uri.parse('$baseUrl/isUser'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['isUser'];
      return data.map<User>((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
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

  Future<void> updateRole(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}/updateRole'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        // Nếu thành công, trả về thông tin người dùng
        var data = jsonDecode(response.body);
        print(data['message']);
      } else {
        // Xử lý lỗi nếu có
        var data = jsonDecode(response.body);
        print("Error: ${data['message']}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> deleteRole(String email) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}/deleteRole'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        // Nếu thành công, trả về thông tin người dùng
        var data = jsonDecode(response.body);
        print(data['message']);
      } else {
        // Xử lý lỗi nếu có
        var data = jsonDecode(response.body);
        print("Error: ${data['message']}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchSuggestions(String keyword) async {
    if (keyword.isEmpty) {
      state = []; // Xóa danh sách nếu không có từ khóa
      return;
    }

    final url = Uri.parse('${baseUrl}/searchEmails');
    try {
      final response = await http.post(
        url,
        body: json.encode({'keyword': keyword}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Giải mã và kiểm tra cấu trúc dữ liệu trả về
        final List<dynamic> data = json.decode(response.body);

        // Nếu dữ liệu là một danh sách email thuần túy, bạn chỉ cần ánh xạ qua String
        state = data.map((e) => User(email: e)).toList();
      } else {
        state = [];
        print("Error: Không tìm thấy email phù hợp.");
      }
    } catch (e) {
      print("Error khi gọi API: $e");
    }
  }
}

final userLocationProvider =
    StateNotifierProvider<UserLocationNotifier, List<User>>((ref) {
  return UserLocationNotifier();
});
