import 'package:hive/hive.dart';

// part 'assignment.g.dart';

enum AssignmentStatus { pending, completed }

enum AssignmentPriority { high, medium, low }

@HiveType(typeId: 0)
class Assignment extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String description;

  @HiveField(3)
  late DateTime dueDate;

  @HiveField(4)
  late String subject;

  @HiveField(5)
  late bool isCompleted;

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  late AssignmentStatus status;

  @HiveField(8)
  late AssignmentPriority priority;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.subject,
    this.isCompleted = false,
    required this.createdAt,
    this.status = AssignmentStatus.pending,
    this.priority = AssignmentPriority.medium,
  });

  Assignment.empty() {
    id = '';
    title = '';
    description = '';
    dueDate = DateTime.now();
    subject = '';
    isCompleted = false;
    createdAt = DateTime.now();
    status = AssignmentStatus.pending;
    priority = AssignmentPriority.medium;
  }

  @override
  String toString() {
    return 'Assignment{id: $id, title: $title, description: $description, dueDate: $dueDate, subject: $subject, isCompleted: $isCompleted, createdAt: $createdAt, status: $status, priority: $priority}';
  }
}
