import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/database/database.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<User?>(context);
    final AppDatabase db = Provider.of<AppDatabase>(context);

    if (user == null) {
      return const CircularProgressIndicator();
    }

    final Stream<List<Todo>> todosStream = db.watchUserTodos(user.id);

    return StreamBuilder<List<Todo>>(
      stream: todosStream,
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        List<Todo> todos = snapshot.data ?? [];

        return ImplicitlyAnimatedList<Todo>(
          itemData: todos,
          itemEquality: (a, b) => a.id == b.id,
          physics: const BouncingScrollPhysics(),
          deleteDuration: const Duration(milliseconds: 0),
          itemBuilder: (context, data) => TodoListItem(todo: data),
        );
      },
    );
  }
}

class TodoListItem extends StatelessWidget {
  const TodoListItem({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    final AppDatabase db = Provider.of<AppDatabase>(context);

    return KeyedSubtree(
      key: ValueKey(todo.id),
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          db.deleteTodo(todo);
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.endToStart,
        child: ListTile(
          title: Text(todo.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: todo.completed
                  ? const TextStyle(decoration: TextDecoration.lineThrough)
                  : null),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo.description != null) Text(todo.description!),
              const SizedBox(height: 4),
              Chip(
                label: Text(
                  DateFormat('dd.MM.yyyy HH:mm')
                      .format(DateTime.parse(todo.createdAt)),
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            ],
          ),
          trailing: Checkbox(
            value: todo.completed,
            onChanged: (value) {
              db.updateTodo(todo.copyWith(completed: value));
            },
          ),
        ),
      ),
    );
  }
}
