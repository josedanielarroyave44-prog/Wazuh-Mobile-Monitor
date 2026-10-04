import 'package:flutter/material.dart';
import 'package:wazuh_mobile_monitor/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;
  AuthViewModel({required this.authRepository});

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool _allowSelfSigned = false;
  bool get allowSelfSigned => _allowSelfSigned;

  Future<bool> login({
    required String ip,
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await authRepository.authenticate(
        ip: ip,
        username: username,
        password: password,
        allowSelfSigned: _allowSelfSigned,
      );
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } //try-catch block
    finally {
      _isLoading = false;
      notifyListeners();
    }
  } //login

  void toggleSelfSigned(bool value) {
    _allowSelfSigned = value;
    notifyListeners();
  }
} //class
