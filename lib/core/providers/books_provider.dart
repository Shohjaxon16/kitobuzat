import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BooksProvider extends ChangeNotifier {
  List<dynamic> _books = [];
  List<dynamic> _categories = [];
  Map<String, dynamic>? _featuredBook;
  bool _isLoading = false;
  String? _error;
  int _selectedCategory = 0;

  List<dynamic> get books => _books;
  List<dynamic> get categories => _categories;
  Map<String, dynamic>? get featuredBook => _featuredBook;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get selectedCategory => _selectedCategory;

  Future<void> loadHomeData() async {
    _isLoading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        ApiService.getBooks(),
        ApiService.getCategories(),
        ApiService.getFeaturedBook(),
      ]);
      _books = results[0]['data'] ?? [];
      _categories = results[1]['data'] ?? [];
      _featuredBook = results[2]['data'];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Ma\'lumotlarni yuklashda xatolik';
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCategory(int index) {
    _selectedCategory = index;
    notifyListeners();
  }

  Future<void> searchBooks(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await ApiService.getBooks(search: query);
      _books = res['data'] ?? [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Qidirishda xatolik';
      _isLoading = false;
      notifyListeners();
    }
  }
}
