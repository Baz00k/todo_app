import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth_wrapper.dart';
import 'package:todo_app/constants/routes.dart';
import 'package:todo_app/database/database.dart';
import 'package:todo_app/services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, AppDatabase db) => db.close(),
        ),
        Provider<AuthService>(
          create: (context) => AuthService(context),
        ),
      ],
      builder: (context, child) => StreamProvider.value(
        value: context.read<AuthService>().userStream,
        initialData: null,
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: const AuthWrapper(),
          routes: routes,
        ),
      ),
    );
  }
}
