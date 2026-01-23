import 'package:studyplannerapp/App/models/assignment.dart';
import 'package:studyplannerapp/App/models/attendance.dart';
import 'package:studyplannerapp/App/models/progress.dart';
import 'package:studyplannerapp/App/services/database_service.dart';

class MockDataService {
  final DatabaseService _databaseService;

  MockDataService(this._databaseService);

  Future<void> seedMockData() async {
    // Clear existing data
    await _clearAllData();

    // Create mock assignments
    final assignments = [
      Assignment(
        id: '1',
        title: 'Math Homework',
        description: 'Complete exercises 1-10 from chapter 3',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        subject: 'Mathematics',
        isCompleted: false,
        createdAt: DateTime.now(),
      ),
      Assignment(
        id: '2',
        title: 'Science Project',
        description: 'Research and prepare presentation on renewable energy',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        subject: 'Science',
        isCompleted: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Assignment(
        id: '3',
        title: 'English Essay',
        description: 'Write 1000-word essay on climate change',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        subject: 'English',
        isCompleted: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    // Create mock attendance records
    final attendance = [
      Attendance(
        id: '1',
        subject: 'Mathematics',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isPresent: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Attendance(
        id: '2',
        subject: 'Science',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isPresent: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Attendance(
        id: '3',
        subject: 'English',
        date: DateTime.now().subtract(const Duration(days: 2)),
        isPresent: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Attendance(
        id: '4',
        subject: 'Mathematics',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isPresent: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Attendance(
        id: '5',
        subject: 'Science',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isPresent: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Attendance(
        id: '6',
        subject: 'English',
        date: DateTime.now().subtract(const Duration(days: 1)),
        isPresent: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];

    // Create mock progress tracking
    final progress = [
      Progress(
        id: '1',
        subject: 'Mathematics',
        totalHours: 20,
        completedHours: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now(),
      ),
      Progress(
        id: '2',
        subject: 'Science',
        totalHours: 15,
        completedHours: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now(),
      ),
      Progress(
        id: '3',
        subject: 'English',
        totalHours: 10,
        completedHours: 6,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now(),
      ),
    ];

    // Save all mock data
    for (final assignment in assignments) {
      await _databaseService.saveAssignment(assignment);
    }

    for (final attendanceRecord in attendance) {
      await _databaseService.saveAttendance(attendanceRecord);
    }

    for (final progressRecord in progress) {
      await _databaseService.saveProgress(progressRecord);
    }
  }

  Future<void> _clearAllData() async {
    // Get all assignments and delete them
    final assignments = await _databaseService.getAllAssignments();
    for (final assignment in assignments) {
      await _databaseService.deleteAssignment(assignment.id);
    }

    // Get all attendance records and delete them
    final attendance = await _databaseService.getAllAttendance();
    for (final attendanceRecord in attendance) {
      await _databaseService.deleteAttendance(attendanceRecord.id);
    }

    // Get all progress records and delete them
    final progress = await _databaseService.getAllProgress();
    for (final progressRecord in progress) {
      await _databaseService.deleteProgress(progressRecord.id);
    }
  }

  Future<List<Assignment>> getAllAssignments() async {
    return await _databaseService.getAllAssignments();
  }

  Future<List<Attendance>> getAllAttendance() async {
    return await _databaseService.getAllAttendance();
  }

  Future<List<Progress>> getAllProgress() async {
    return await _databaseService.getAllProgress();
  }

  Future<void> updateAssignment(Assignment assignment) async {
    await _databaseService.saveAssignment(assignment);
  }

  Future<void> updateAttendance(Attendance attendance) async {
    await _databaseService.saveAttendance(attendance);
  }

  Future<void> updateProgress(Progress progress) async {
    await _databaseService.saveProgress(progress);
  }

  Future<void> deleteAssignment(String id) async {
    await _databaseService.deleteAssignment(id);
  }

  Future<void> deleteAttendance(String id) async {
    await _databaseService.deleteAttendance(id);
  }

  Future<void> deleteProgress(String id) async {
    await _databaseService.deleteProgress(id);
  }
}