import 'package:get/get.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final _isLoading = false.obs;
  final _error = Rxn<String>();

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;

  Future<bool> login(String email, String password) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final response = await _authService.login(email, password);
      _isLoading.value = false;
      return true;
    } catch (e) {
      _error.value = e.toString();
      _isLoading.value = false;
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final response = await _authService.register(email, password);
      _isLoading.value = false;
      return true;
    } catch (e) {
      _error.value = e.toString();
      _isLoading.value = false;
      return false;
    }
  }

  void clearError() {
    _error.value = null;
  }
} 