import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://your-app.up.railway.app/api/v1',
  );

  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token != null) headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // AUTH
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _headers(auth: false),
      body: jsonEncode({
        'email': email,
        'password': password,
        'fullName': fullName,
      }),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _headers(auth: false),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    if (data['success'] == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['data']['accessToken']);
      await prefs.setString('refreshToken', data['data']['refreshToken']);
      await prefs.setString('userId', data['data']['user']['id']);
      await prefs.setString('userEmail', data['data']['user']['email']);
      await prefs.setString('userFullName', data['data']['user']['fullName']);
    }
    return data;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: await _headers(),
      );
    }
    await prefs.clear();
  }

  static Future<Map<String, dynamic>> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');
    final res = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: await _headers(auth: false),
      body: jsonEncode({'refreshToken': refreshToken}),
    );
    final data = jsonDecode(res.body);
    if (data['success'] == true) {
      await prefs.setString('accessToken', data['data']['accessToken']);
      await prefs.setString('refreshToken', data['data']['refreshToken']);
    }
    return data;
  }

  // BOOKS
  static Future<Map<String, dynamic>> getBooks({
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
    String sortBy = 'newest',
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      'sortBy': sortBy,
      if (category != null) 'category': category,
      if (search != null) 'search': search,
    };
    final uri = Uri.parse('$baseUrl/books')
        .replace(queryParameters: queryParams);
    final res = await http.get(uri, headers: await _headers());
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getFeaturedBook() async {
    final res = await http.get(
      Uri.parse('$baseUrl/books/featured'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getBookById(String id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/books/$id'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getCategories() async {
    final res = await http.get(
      Uri.parse('$baseUrl/books/categories'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  // LIBRARY
  static Future<Map<String, dynamic>> getMyLibrary() async {
    final res = await http.get(
      Uri.parse('$baseUrl/library/my'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> updateReadingProgress(
      String bookId, int currentPage) async {
    final res = await http.patch(
      Uri.parse('$baseUrl/library/$bookId/progress'),
      headers: await _headers(),
      body: jsonEncode({'currentPage': currentPage}),
    );
    return jsonDecode(res.body);
  }

  // ORDERS
  static Future<Map<String, dynamic>> createOrder({
    required String bookId,
    required String orderType,
    required String paymentMethod,
    int? rentDays,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: await _headers(),
      body: jsonEncode({
        'bookId': bookId,
        'orderType': orderType,
        'paymentMethod': paymentMethod,
        if (rentDays != null) 'rentDays': rentDays,
      }),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getMyOrders() async {
    final res = await http.get(
      Uri.parse('$baseUrl/orders/my'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  // USER PROFILE
  static Future<Map<String, dynamic>> getMyProfile() async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: await _headers(),
    );
    return jsonDecode(res.body);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') != null;
  }
}
