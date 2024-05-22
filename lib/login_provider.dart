import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String? _email;
  String? _password;

  String? get email => _email;
  String? get password => _password;

  bool get isLoggedIn => _email != null && _password != null;

  void login(String email, String password) {
    _email = email;
    _password = password;
    // Any additional logic for login can be added here
    notifyListeners();
  }

  void updateCredentials(String newEmail, String newPassword) {
    _email = newEmail;
    _password = newPassword;
    // Any additional logic for updating credentials can be added here
    notifyListeners();
  }

  void logout() {
    _email = null;
    _password = null;
    notifyListeners();
  }
}
