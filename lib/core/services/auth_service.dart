import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.data['success'] == true) {
        final data = response.data['data'];
        await _storage.write(key: 'accessToken', value: data['accessToken']);
        await _storage.write(key: 'refreshToken', value: data['refreshToken']);
        return {'success': true, 'user': data['user']};
      }
      
      var message = response.data['message'] ?? 'Xatolik yuz berdi';
      if (message is List) message = message.join(', ');
      return {'success': false, 'message': message};
    } on DioException catch (e) {
      var message = e.response?.data['message'];
      if (message is List) message = message.join(', ');
      return {
        'success': false, 
        'message': message ?? 'Server bilan ulanishda xatolik'
      };
    }
  }

  // Register
  Future<Map<String, dynamic>> register(String email, String fullName, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'fullName': fullName,
        'password': password,
      });

      if (response.data['success'] == true) {
        return {'success': true, 'message': response.data['message']};
      }
      var message = response.data['message'];
      if (message is List) message = message.join(', ');
      return {'success': false, 'message': message};
    } on DioException catch (e) {
      var message = e.response?.data['message'];
      if (message is List) message = message.join(', ');
      return {
        'success': false, 
        'message': message ?? 'Server bilan ulanishda xatolik'
      };
    }
  }

  // Logout
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // Tokenni olish
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }
}
