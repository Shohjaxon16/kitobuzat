class ApiConstants {
  static const String baseUrl = 'http://localhost:3000/api/v1'; // Mahalliy sinov uchun
  static const String productionUrl = 'https://your-app.up.railway.app/api/v1';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';
  
  // Books
  static const String books = '/books';
  static const String categories = '/books/categories';
  static const String featured = '/books/featured';
}
