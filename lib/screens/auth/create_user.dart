import 'package:flutter/material.dart';
import 'package:todo_app/services/auth_service.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  CreateUserScreenState createState() => CreateUserScreenState();
}

class CreateUserScreenState extends State<CreateUserScreen> {
  late AuthService _authService;
  String _username = '';
  String? _errorText;

  @override
  void initState() {
    _authService = AuthService(context);
    super.initState();
  }

  void _onUsernameChanged(String value) {
    setState(() {
      _username = value;
    });

    _validateUsername();
  }

  void _validateUsername() {
    if (_username.isEmpty) {
      _errorText = 'Username cannot be empty';
      return;
    }

    if (_username.length < 3) {
      _errorText = 'Username must be at least 3 characters long';
      return;
    }

    if (_username.length > 64) {
      _errorText = 'Username must be less than 64 characters long';
      return;
    }

    _errorText = null;
  }

  void _onLoginPressed() async {
    final user = await _authService.getUserByUsername(_username);
    if (!mounted) return;

    if (user != null) {
      setState(() {
        _errorText = 'User with that username already exists';
      });

      return;
    }

    await _authService.createUser(_username);
    await _authService.login(_username);
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create User'),
        centerTitle: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                onChanged: _onUsernameChanged,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter your username',
                  errorText: _errorText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ElevatedButton(
                  onPressed: _errorText == null && _username.isNotEmpty
                      ? _onLoginPressed
                      : null,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
