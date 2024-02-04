import 'package:moor_flutter/moor_flutter.dart';
import 'package:todo_app/database/datetime_converter.dart';

part 'database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 3, max: 64)();
}

class Todos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().customConstraint('REFERENCES users(id)')();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()
      .withDefault(currentDateAndTime)
      .map(const DateTimeConverter())();
}

@UseMoor(tables: [Users, Todos])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite', logStatements: true));

  @override
  int get schemaVersion => 1;

  Future<int> addTodo(TodosCompanion todo) => into(todos).insert(todo);

  Future<int> deleteTodo(Todo todo) => delete(todos).delete(todo);

  Future<int> deleteCompletedTodos(int userId) => (delete(todos)
        ..where((t) => t.userId.equals(userId) & t.completed.equals(true)))
      .go();

  Future<bool> updateTodo(Todo todo) => update(todos).replace(todo);

  Future<int> addUser(UsersCompanion user) => into(users).insert(user);

  Future<User?> getUserByUsername(String username) =>
      (select(users)..where((u) => u.username.equals(username)))
          .getSingleOrNull();

  Future<List<User>> getAllUsers() => select(users).get();

  Stream<List<User>> watchAllUsers() => select(users).watch();

  Stream<List<Todo>> watchUserTodos(int userId) => (select(todos)
        ..where((t) => t.userId.equals(userId))
        ..orderBy([
          (t) => OrderingTerm(expression: t.completed, mode: OrderingMode.asc),
          (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
        ]))
      .watch();
}
