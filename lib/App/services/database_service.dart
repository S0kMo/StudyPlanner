import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:studyplannerapp/App/models/assignment.dart';
import 'package:studyplannerapp/App/models/attendance.dart';
import 'package:studyplannerapp/App/models/progress.dart';

class DatabaseService {
  static const String assignmentBoxName = 'assignments';
  static const String attendanceBoxName = 'attendance';
  static const String progressBoxName = 'progress';

  late Box<Assignment> assignmentBox;
  late Box<Attendance> attendanceBox;
  late Box<Progress> progressBox;

  Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    // Hive.registerAdapter(AssignmentAdapter());
    // Hive.registerAdapter(AttendanceAdapter());
    // Hive.registerAdapter(ProgressAdapter());

    // Open boxes
    assignmentBox = await Hive.openBox<Assignment>(assignmentBoxName);
    attendanceBox = await Hive.openBox<Attendance>(attendanceBoxName);
    progressBox = await Hive.openBox<Progress>(progressBoxName);
  }

  // Assignment operations
  Future<void> saveAssignment(Assignment assignment) async {
    await assignmentBox.put(assignment.id, assignment);
  }

  Future<List<Assignment>> getAllAssignments() async {
    return assignmentBox.values.toList();
  }

  Future<Assignment?> getAssignment(String id) async {
    return assignmentBox.get(id);
  }

  Future<void> deleteAssignment(String id) async {
    await assignmentBox.delete(id);
  }

  // Attendance operations
  Future<void> saveAttendance(Attendance attendance) async {
    await attendanceBox.put(attendance.id, attendance);
  }

  Future<List<Attendance>> getAllAttendance() async {
    return attendanceBox.values.toList();
  }

  Future<Attendance?> getAttendance(String id) async {
    return attendanceBox.get(id);
  }

  Future<void> deleteAttendance(String id) async {
    await attendanceBox.delete(id);
  }

  // Progress operations
  Future<void> saveProgress(Progress progress) async {
    await progressBox.put(progress.id, progress);
  }

  Future<List<Progress>> getAllProgress() async {
    return progressBox.values.toList();
  }

  Future<Progress?> getProgress(String id) async {
    return progressBox.get(id);
  }

  Future<void> deleteProgress(String id) async {
    await progressBox.delete(id);
  }

  // Close database
  Future<void> close() async {
    await assignmentBox.close();
    await attendanceBox.close();
    await progressBox.close();
  }
}
