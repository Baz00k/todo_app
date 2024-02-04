import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
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
        final List<Todo> todos = snapshot.data ?? [];

        return ImplicitlyAnimatedList<Todo>(
          itemData: todos,
          itemEquality: (a, b) => a.id == b.id,
          itemBuilder: (context, data) => ListTile(
            key: ValueKey(data.id),
            title: Text(data.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: data.completed
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null),
            subtitle: data.description == null ? null : Text(data.description!),
            trailing: Checkbox(
              value: data.completed,
              onChanged: (value) {
                db.updateTodo(data.copyWith(completed: value));
              },
            ),
          ),
        );
      },
    );
  }
}
