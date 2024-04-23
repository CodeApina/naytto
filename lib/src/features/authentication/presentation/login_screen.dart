import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naytto/src/features/authentication/data/firebase_auth_repository.dart';

class LoginScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Container(
                height: 400.0,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/welcome.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  controller: _emailController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Password'),
                  controller: _passwordController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Login with Email'),
                    onPressed: () async {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      if (email.isEmpty || password.isEmpty) {
                        _showErrorDialog(
                            context, 'Please insert email and password');
                        return;
                      }
                      if (email.isEmpty) {
                        _showErrorDialog(context, 'Please insert email');
                        return;
                      }
                      if (password.isEmpty) {
                        _showErrorDialog(context, 'Please insert password');
                        return;
                      }

                      if (!email.contains('@') || !email.contains('.')) {
                        _showErrorDialog(context, 'Invalid email format.');
                        return;
                      }

                      final authenticationResult = await ref
                          .read(authRepositoryProvider)
                          .signInWithEmailAndPassword(email, password);

                      if (authenticationResult != 'signed in') {
                        _showErrorDialog(context, authenticationResult);
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(64, 8, 64, 8),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                      onPressed: () {
                        String email = "janne.korhonen@gmail.com";
                        String password = "salasana";
                        ref
                            .read(authRepositoryProvider)
                            .signInWithEmailAndPassword(email, password);
                      },
                      icon: const Icon(Icons.developer_board),
                      label: const Text("Login as developer")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Error management
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
