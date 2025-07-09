import 'package:flutter/material.dart';
import 'package:sync_app/repositories/repo.dart';

class RegisterProvider extends ChangeNotifier {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> register(BuildContext context) async {
    const registerApi = 'http://192.168.15.201:4000/todo/sign_up';

    final credentials = {
      'username': usernameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {
      _isLoading = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2)); // Simulate delay

      final response = await Repo.postRequest(credentials, registerApi);

      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: ${response.body}')),
        );
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      print('Error: $e');
      return false;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
