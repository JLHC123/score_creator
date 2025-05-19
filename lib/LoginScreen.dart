import 'package:flutter/material.dart';
import 'package:score_creator/EndpointHandler.dart';
import 'package:score_creator/GlobalScoreScreen.dart';
import 'UserScoreScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final EndpointHandler _endpointHandler = EndpointHandler();

  void _attemptLogin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    try {
      String message = await _endpointHandler.loginUser(username, password);
      if (message == "Login successful") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserScoreScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login"),),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              ElevatedButton(
                onPressed: _attemptLogin,
                child: const Text("Login"),
              )
            ],
          )
      ),
    );
  }
}