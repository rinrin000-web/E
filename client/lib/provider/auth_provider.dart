import 'package:client/provider/user_location_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/pages/constants.dart';

// Trạng thái xác thực
class AuthState {
  final bool isAuthenticated;
  final bool? isLogin;
  final bool? isSignup;
  final bool? isAdmin;
  final String? errorMessage;
  final String? commentUser;

  AuthState(
      {this.isAuthenticated = false,
      this.isLogin = false,
      this.isSignup = false,
      this.isAdmin,
      this.errorMessage,
      this.commentUser});
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
    final isAdmin = prefs.getBool('isAdmin');
    if (token != null) {
      state = AuthState(
          isAuthenticated: true, commentUser: commentUser, isAdmin: isAdmin);
    } else {
      state = AuthState(isAuthenticated: false); // Đảm bảo trạng thái xác thực
    }
  }

  // Hàm đăng nhập
  Future<void> login(String email, String password) async {
    // state = AuthState(isLogin: true, isSignup: false);
    try {
      if (email.isEmpty) {
        state = AuthState(
            isAuthenticated: false,
            isLogin: true,
            isSignup: false,
            errorMessage: ErrorMessages.emailRequired);
        throw Exception(ErrorMessages.emailRequired);
      }

      if (password.isEmpty) {
        state = AuthState(
            isAuthenticated: false,
            isLogin: true,
            isSignup: false,
            errorMessage: ErrorMessages.passwordRequired);
        throw Exception(ErrorMessages.passwordRequired);
      }
      final response = await http.post(
        Uri.parse('${BaseUrlE.baseUrl}/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final token = responseBody['token'];
        final commentUser = responseBody['email'];
        final isAdmin = responseBody['is_admin'] == 1 ? true : false;

        print('response: $responseBody');
        print('admin la : $isAdmin');
        if (token == null) {
          throw Exception('Login failed: ${responseBody}');
        } else {
          // Lưu token vào SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('commentUser', commentUser);
          await prefs.setBool('isAdmin', isAdmin);

          state = AuthState(
            isAuthenticated: true,
            isLogin: true,
            isSignup: false,
            errorMessage: null,
            commentUser: commentUser,
            isAdmin: isAdmin,
          );
          print("Người đăng nhập: $commentUser");
        }
      } else {
        state = AuthState(
          isAuthenticated: false,
          isLogin: true,
          isSignup: false,
          errorMessage: 'メールアドレスまたはパスワードを確認してください',
        );
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Hàm đăng ký
  Future<void> signup(String email, String password) async {
    // state = AuthState(isLogin: false, isSignup: true);
    if (email.isEmpty) {
      state = AuthState(
          isAuthenticated: false,
          isLogin: false,
          isSignup: true,
          errorMessage: 'メールアドレスを入力してください');
      throw Exception('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      state = AuthState(
          isAuthenticated: false,
          isLogin: false,
          isSignup: true,
          errorMessage: 'パスワードを入力してください');
      throw Exception('パスワードを入力してください');
    }

    final response = await http.post(
      Uri.parse('${BaseUrlE.baseUrl}/api/signup'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      final token = responseBody['token'];

      if (token == null) {
        throw Exception('登録トークンが見つかりません');
      } else {
        // Lưu token vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // Cập nhật trạng thái sau khi đăng ký thành công
        state = AuthState(
            isAuthenticated: false,
            isLogin: true,
            isSignup: false,
            errorMessage: null);
      }
    } else {
      state = AuthState(
        isAuthenticated: false,
        isLogin: false,
        isSignup: true,
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('commentUser');
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('${BaseUrlE.baseUrl}/api/password/reset');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final message = jsonDecode(response.body)['message'];
        print(message);
      } else {
        final error = jsonDecode(response.body)['error'];
        print(error);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> resetPassword(
      String email, String password, String token) async {
    final url = Uri.parse('${BaseUrlE.baseUrl}/api/password/update');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'password_confirmation': password,
          'token': token
        }),
      );

      if (response.statusCode == 200) {
        final message = jsonDecode(response.body)['message'];
        print(message); // In thông báo thành công khi đổi mật khẩu
      } else {
        final error = jsonDecode(response.body)['message'];
        print(error); // In thông báo lỗi nếu không thành công
      }
    } catch (e) {
      print('Error: $e'); // Xử lý lỗi khi không thể kết nối tới API
    }
  }
}
