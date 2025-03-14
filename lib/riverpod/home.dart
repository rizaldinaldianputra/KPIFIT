import 'package:flutter_riverpod/flutter_riverpod.dart';

final homePageProvider = StateNotifierProvider<HomePageNotifier, int>((ref) {
  return HomePageNotifier();
});

class HomePageNotifier extends StateNotifier<int> {
  HomePageNotifier() : super(0);

  void setPage(int index) {
    state = index;
  }

  void nextPage() {
    if (state < 2) {
      state++;
    }
  }

  void previousPage() {
    if (state > 0) {
      state--;
    }
  }

  void jumpToPage(int index) {
    if (index >= 0 && index <= 2) {
      state = index;
    }
  }
}
