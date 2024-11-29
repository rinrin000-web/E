import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider để quản lý trạng thái của BottomNavigationBar
final tabIndexProvider = StateNotifierProvider<TabIndexNotifier, int>((ref) {
  return TabIndexNotifier();
});

// StateNotifier để quản lý tab hiện tại
class TabIndexNotifier extends StateNotifier<int> {
  TabIndexNotifier() : super(0) {
    loadTabIndex();
  }

  void setTabIndex(int index) {
    state = index;
    // Lưu trạng thái vào SharedPreferences (hoặc bạn có thể sử dụng Riverpod để lưu)
    _saveTabIndex(index);
  }

  // Hàm lưu trạng thái tab vào SharedPreferences
  Future<void> _saveTabIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('selectedTab', index);
  }

  // Hàm tải lại trạng thái tab từ SharedPreferences
  Future<void> loadTabIndex() async {
    final prefs = await SharedPreferences.getInstance();
    state =
        prefs.getInt('selectedTab') ?? 0; // Mặc định là 0 nếu không tìm thấy
  }
}
