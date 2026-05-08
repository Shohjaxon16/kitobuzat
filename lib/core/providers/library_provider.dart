import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LibraryProvider extends ChangeNotifier {
  List<dynamic> _library = [];
  bool _isLoading = false;

  List<dynamic> get library => _library;
  bool get isLoading => _isLoading;

  List<dynamic> get reading =>
      _library.where((b) => b['type'] != null && (b['currentPage'] ?? 0) > 0 && (b['currentPage'] ?? 0) < (b['book']?['totalPages'] ?? 999)).toList();

  List<dynamic> get completed =>
      _library.where((b) => (b['currentPage'] ?? 0) >= (b['book']?['totalPages'] ?? 999)).toList();

  List<dynamic> get rented =>
      _library.where((b) => b['type'] == 'rented').toList();

  Future<void> loadLibrary() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await ApiService.getMyLibrary();
      _library = res['data'] ?? [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProgress(String bookId, int page) async {
    await ApiService.updateReadingProgress(bookId, page);
    await loadLibrary();
  }
}
