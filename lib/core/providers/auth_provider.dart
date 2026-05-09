import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;
  bool _isLoading = false;
  String? _error;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> checkAuthStatus() async {
    _isLoggedIn = await ApiService.isLoggedIn();
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await ApiService.login(email: email, password: password);
      if (res['success'] == true) {
        _isLoggedIn = true;
        _user = res['data']['user'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = res['error']?['message'] ?? 'Xatolik yuz berdi';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Server bilan ulanishda xatolik yuz berdi';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String fullName) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await ApiService.register(
        email: email, password: password, fullName: fullName);
      if (res['success'] == true) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = res['error']?['message'] ?? 'Xatolik yuz berdi';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Internet bilan muammo bor';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.logout();
    _isLoggedIn = false;
    _user = null;
    notifyListeners();
  }
}
