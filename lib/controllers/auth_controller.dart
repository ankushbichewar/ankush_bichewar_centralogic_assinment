// lib/controllers/auth_controller.dart

class AuthController {
  static bool login(String email, String password) {
    // In real apps, use Firebase/Auth APIs. This is mock logic.
    return email.isNotEmpty && password.isNotEmpty;
  }

  static bool register(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty;
  }
}
