import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailVisibilityProvider extends StateNotifier<bool> {
  EmailVisibilityProvider() : super(false) {
    _loadVisibility();
  }

  void toggleVisibility() async {
    state = !state;
    await _saveVisibility(state);
  }

  Future<void> _saveVisibility(bool isVisible) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isPublic', isVisible);
  }

  Future<void> _loadVisibility() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isPublic') ?? false;
  }
}

final emailVisibilityProvider =
    StateNotifierProvider<EmailVisibilityProvider, bool>(
  (ref) => EmailVisibilityProvider(),
);
