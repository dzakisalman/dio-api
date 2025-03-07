import 'package:get/get.dart';

import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    update();

    try {
      final response = await _authService.login(email, password);
      _isLoading = false;
      update();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      update();
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading = true;
    _error = null;
    update();

    try {
      final response = await _authService.register(email, password);
      _isLoading = false;
      update();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      update();
      return false;
    }
  }

  void clearError() {
    _error = null;
    update();
  }
}
