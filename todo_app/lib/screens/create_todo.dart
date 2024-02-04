import 'package:flutter/material.dart';
import 'package:moor_flutter/moor_flutter.dart' as moor;
import 'package:provider/provider.dart';
import 'package:todo_app/database/database.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final TextEditingController _todoTitleController = TextEditingController();
  final TextEditingController _todoDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AppDatabase db = Provider.of<AppDatabase>(context);
    final User? user = Provider.of<User?>(context);

    if (user == null) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _todoTitleController,
                decoration: const InputDecoration(
                  labelText: 'Todo',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a todo title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _todoDescriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    db.addTodo(
                      TodosCompanion(
                        userId: moor.Value(user.id),
                        title: moor.Value(_todoTitleController.text),
                        description:
                            moor.Value(_todoDescriptionController.text),
                      ),
                    );
                    Navigator.pop(context, _todoTitleController.text);
                  }
                },
                child: const Text('Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
