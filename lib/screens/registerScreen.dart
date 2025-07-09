import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sync_app/screens/loginScreen.dart';
import '../providers/registerProvider.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    final inputDecoration = InputDecoration(
      border: const OutlineInputBorder(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: registerProvider.usernameController,
                    decoration: inputDecoration.copyWith(hintText: 'Username'),
                    validator: (value) =>
                        (value?.isEmpty ?? true) ? 'Enter username' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: registerProvider.emailController,
                    decoration: inputDecoration.copyWith(hintText: 'Email'),
                    validator: (value) =>
                        (value?.isEmpty ?? true) ? 'Enter email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: registerProvider.passwordController,
                    decoration: inputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (value) =>
                        (value?.isEmpty ?? true) ? 'Enter password' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: registerProvider.confirmPasswordController,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Confirm Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Confirm your password';
                      }
                      if (value != registerProvider.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
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
                      onPressed: registerProvider.isLoading
                          ? null
                          : () async {
                              if (formKey2.currentState?.validate() ?? false) {
                                final success = await registerProvider.register(
                                  context,
                                );
                                if (success) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => LoginScreen(),
                                    ),
                                  );
                                }
                              }
                            },
                      child: registerProvider.isLoading
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
                          : const Text('Register'),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => LoginScreen()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
