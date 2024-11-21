import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider để quản lý trạng thái của BottomNavigationBar
final tabIndexProvider = StateNotifierProvider<TabIndexNotifier, int>((ref) {
  return TabIndexNotifier();
});

// StateNotifier để quản lý tab hiện tại
class TabIndexNotifier extends StateNotifier<int> {
  TabIndexNotifier() : super(0);

  void setTabIndex(int index) {
    state = index;
  }
}
