import 'package:hive/hive.dart';

// part 'attendance.g.dart';

@HiveType(typeId: 1)
class Attendance extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String subject;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late bool isPresent;

  @HiveField(4)
  late DateTime createdAt;

  Attendance({
    required this.id,
    required this.subject,
    required this.date,
    this.isPresent = true,
    required this.createdAt,
  });

  Attendance.empty() {
    id = '';
    subject = '';
    date = DateTime.now();
    isPresent = true;
    createdAt = DateTime.now();
  }

  @override
  String toString() {
    return 'Attendance{id: $id, subject: $subject, date: $date, isPresent: $isPresent, createdAt: $createdAt}';
  }
}
