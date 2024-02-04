import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/screens/auth/login.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/services/auth_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final AuthService authService = context.read<AuthService>();
    final user = Provider.of<User?>(context);

    if (!_initialized) {
      initialize(authService);

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (user == null) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }

  void initialize(AuthService authService) async {
    await authService.autoLogin();
    setState(() {
      _initialized = true;
    });
  }
}
