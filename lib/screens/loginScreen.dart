import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sync_app/screens/registerScreen.dart';
import 'package:sync_app/screens/taskApp.dart';
import '../providers/loginProvider.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    final inputDecoration = InputDecoration(
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: loginProvider.emailController,
                  decoration: inputDecoration.copyWith(hintText: 'Username'),
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Enter username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: loginProvider.passwordController,
                  decoration: inputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      (value?.isEmpty ?? true) ? 'Enter password' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: loginProvider.isLoading
                        ? null
                        : () async {
                            if (formKey1.currentState?.validate() ?? false) {
                              final isSuccess = await loginProvider.login(
                                context,
                              );
                              if (isSuccess) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TaskApp(),
                                  ),
                                );
                              }
                            }
                          },
                    child: loginProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 25),
                GestureDetector(
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
