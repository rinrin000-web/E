import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Trạng thái xác thực
class AuthState {
  final bool isAuthenticated;
  final String? errorMessage;
  final String? commentUser;

  AuthState(
      {this.isAuthenticated = false, this.errorMessage, this.commentUser});
}

// Provider quản lý trạng thái xác thực
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

// Class AuthNotifier quản lý logic xác thực
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _loadToken(); // Tải token khi khởi tạo
  }

  // Hàm kiểm tra token trong SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final commentUser = prefs.getString('commentUser');
    if (token != null) {
      state = AuthState(isAuthenticated: true, commentUser: commentUser);
    } else {
      state = AuthState(
          isAuthenticated:
              false); // Thêm dòng này để đảm bảo trạng thái xác thực
    }
  }

  // Hàm đăng nhập
  Future<void> login(String email, String password) async {
    if (email.isEmpty) {
      state =
          AuthState(isAuthenticated: false, errorMessage: 'メールアドレスを入力してください');
      throw Exception('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      state = AuthState(isAuthenticated: false, errorMessage: 'パスワードを入力してください');
      throw Exception('パスワードを入力してください');
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final token = responseBody['token'];
      final commentUser = responseBody['email'];

      if (token == null) {
        throw Exception('Login failed: ${responseBody}');
      } else {
        // Lưu token vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('commentUser', commentUser);
        // Cập nhật trạng thái sau khi đăng nhập thành công
        state = AuthState(
            isAuthenticated: true,
            errorMessage: null,
            commentUser: commentUser);
        print("Người đăng nhập: $commentUser");
      }
    } else {
      state = AuthState(
        isAuthenticated: false,
        errorMessage: 'メールアドレスまたはパスワードを確認してください',
      );
      throw Exception('Failed to login: ${response.body}');
    }
  }

  // Hàm đăng ký
  Future<void> signup(String email, String password) async {
    if (email.isEmpty) {
      state =
          AuthState(isAuthenticated: false, errorMessage: 'メールアドレスを入力してください');
      throw Exception('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      state = AuthState(isAuthenticated: false, errorMessage: 'パスワードを入力してください');
      throw Exception('パスワードを入力してください');
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final token = responseBody['token'];

      if (token == null) {
        throw Exception('Registration failed: ${responseBody}');
      } else {
        // Lưu token vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Cập nhật trạng thái sau khi đăng ký thành công
        state = AuthState(isAuthenticated: true, errorMessage: null);
      }
    } else {
      state = AuthState(
        isAuthenticated: false,
        errorMessage: 'メールアドレスまたはパスワードを確認してください',
      );
      throw Exception('Failed to signup: ${response.body}');
    }
  }

  // Hàm reset lỗi
  void resetError() {
    state =
        AuthState(isAuthenticated: state.isAuthenticated, errorMessage: null);
  }

  // Hàm đăng xuất (xóa token khỏi SharedPreferences)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Xóa token
    await prefs.remove('commentUser');
    state = AuthState(isAuthenticated: false);
  }
}
