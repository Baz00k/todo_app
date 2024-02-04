import 'package:moor_flutter/moor_flutter.dart';

class DateTimeConverter extends TypeConverter<String, DateTime> {
  const DateTimeConverter();

  @override
  DateTime? mapToSql(String? value) {
    if (value == null) {
      return null;
    }
    return DateTime.parse(value);
  }

  @override
  String? mapToDart(DateTime? fromDb) {
    if (fromDb == null) {
      return null;
    }
    return fromDb.toIso8601String();
  }
}
