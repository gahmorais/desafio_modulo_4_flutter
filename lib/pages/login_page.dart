import 'package:desafio_modulo_4/services/AuthService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final authService = AuthService(auth: FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email), labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  labelText: "Password", prefixIcon: Icon(Icons.password)),
            ),
            ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  authService.login(email, password);
                },
                child: Text("Entrar"))
          ],
        ),
      ),
    );
  }
}
