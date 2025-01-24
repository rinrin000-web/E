// constants.dart
import 'package:flutter/material.dart';

class ErrorMessages {
  static const String emailRequired = 'メールアドレスを入力してください';
  static const String passwordRequired = 'パスワードを入力してください';
  static const String loginFailed = 'ログイン失敗';
  static const String signupFailed = '登録に失敗しました';
  static const String invalidCredentials = 'メールアドレスまたはパスワードを確認してください';
}

class ColorE {
  static const Color backgroundColorE = Color(0xFFF2E5BF);
  static const Color headerColorE = Color(0xFF257180);
  static const Color floorColorE = Color(0xFFFD8B51);
  static const Color rankColorE = Color(0xFFCB6040);
  static const Color searchColorE = Color(0xFF62B9BE);
  static const AssetImage backgroundImage =
      AssetImage('assets/images/BackgroundPageI.png');
}

class Efont {
  static const String efont = 'Efont';
  static const String efont2 = 'Zen_Old_Mincho';
}

class BaseUrlE {
  // static const String baseUrl = 'http://127.0.0.1:8000';
  static const String baseUrl = 'http://192.168.56.1:8000';
}

// php artisan serve --host=0.0.0.0 --port=8000
// show create table users;
class ShowSnackBarE {
  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Image.asset(
              'images/echan.png',
              width: 50,
              height: 50,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: null, // Không giới hạn số dòng
                softWrap: true, // Cho phép tự động xuống dòng
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF62B9BE),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class TextE {
  static const save_text = "保存しました!";
  static const range = "評価は1から5の範囲内でなければなりません！";
}
