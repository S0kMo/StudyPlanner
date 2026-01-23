import 'package:hive/hive.dart';

// part 'progress.g.dart';

@HiveType(typeId: 2)
class Progress extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String subject;

  @HiveField(2)
  late int totalHours;

  @HiveField(3)
  late int completedHours;

  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  late DateTime updatedAt;

  Progress({
    required this.id,
    required this.subject,
    this.totalHours = 0,
    this.completedHours = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  Progress.empty() {
    id = '';
    subject = '';
    totalHours = 0;
    completedHours = 0;
    createdAt = DateTime.now();
    updatedAt = DateTime.now();
  }

  double get completionPercentage {
    if (totalHours == 0) return 0.0;
    return (completedHours / totalHours) * 100.0;
  }

  @override
  String toString() {
    return 'Progress{id: $id, subject: $subject, totalHours: $totalHours, completedHours: $completedHours, completionPercentage: ${completionPercentage.toStringAsFixed(1)}%, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
