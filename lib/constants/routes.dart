import 'package:todo_app/screens/auth/create_user.dart';
import 'package:todo_app/screens/auth/login.dart';
import 'package:todo_app/screens/create_todo.dart';
import 'package:todo_app/screens/home.dart';

var routes = {
  '/home': (context) => const HomeScreen(),
  '/create-todo': (context) => const CreateTodo(),
  '/login': (context) => const LoginScreen(),
  '/create-user': (context) => const CreateUserScreen()
};
