import 'package:flutter/material.dart';
import 'package:sync_app/repositories/repo.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> login(BuildContext context) async {
    const loginApi = 'http://192.168.15.201:4000/todo/sign_in';

    final credentials = {
      'email': emailController.text,
      'password': passwordController.text,
    };

    _isLoading = true;
    notifyListeners();

    try {
      final response = await Repo.postRequest(credentials, loginApi);
      _isLoading = false;
      notifyListeners();

      if (response.statusCode == 200) {
        print('Login successful: ${response.body}');
        return true;
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error during login: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
