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
          child: Container(
            margin: const EdgeInsets.fromLTRB(96, 300, 96, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  controller: _emailController,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'Password'),
                  controller: _passwordController,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Login with Email'),
                    onPressed: () {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      if (email.isEmpty || password.isEmpty) return;

                      ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
                          email: email, password: password);
                    },
                  ),
                ),
                //Developer Login
                TextButton.icon(
                    onPressed: () {
                      String email = "janne.korhonen@gmail.com";
                      String password = "salasana";
                      ref.read(firebaseAuthProvider).signInWithEmailAndPassword(
                          email: email, password: password);
                    },
                    icon: const Icon(Icons.developer_board),
                    label: Text("Login as developer"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
