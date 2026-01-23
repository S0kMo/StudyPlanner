import 'package:flutter/material.dart';
import 'package:studyplannerapp/App/components/ui/dialog.dart'; // Add this to your pubspec.yaml for date formatting

// 1. DATA MODEL
enum AssignmentStatus { pending, completed }

enum AssignmentPriority { high, medium, low }

class Assignment {
  final String id;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String description;
  AssignmentStatus status;
  AssignmentPriority priority;

  Assignment({
    required this.id,
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.description,
    this.status = AssignmentStatus.pending,
    required this.priority,
  });
}

class AssignmentManager extends StatefulWidget {
  const AssignmentManager({super.key});

  @override
  State<AssignmentManager> createState() => _AssignmentManagerState();
}

class _AssignmentManagerState extends State<AssignmentManager> {
  // Initial Mock Data
  final List<Assignment> _assignments = [
    Assignment(
      id: '1',
      title: 'Physics Lab Report',
      subject: 'Physics',
      dueDate: DateTime(2026, 1, 9),
      description: 'Complete experiment analysis and conclusions',
      priority: AssignmentPriority.high,
    ),
    Assignment(
      id: '2',
      title: 'Math Assignment - Chapter 5',
      subject: 'Mathematics',
      dueDate: DateTime(2026, 1, 12),
      description: 'Solve problems 1-20',
      priority: AssignmentPriority.medium,
    ),
    Assignment(
      id: '3',
      title: 'History Essay',
      subject: 'History',
      dueDate: DateTime(2026, 1, 15),
      description: 'Write 1500 words on Renaissance',
      priority: AssignmentPriority.low,
    ),
  ];

  String _filter = 'all';

  // LOGIC METHODS
  void _toggleStatus(String id) {
    setState(() {
      final assignment = _assignments.firstWhere((a) => a.id == id);
      assignment.status = assignment.status == AssignmentStatus.pending
          ? AssignmentStatus.completed
          : AssignmentStatus.pending;
    });
  }

  void _deleteAssignment(String id) {
    setState(() {
      _assignments.removeWhere((a) => a.id == id);
    });
  }

  int _getDaysUntilDue(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return dueDate.difference(today).inDays;
  }

  // Helper method to convert String to AssignmentPriority enum
  AssignmentPriority _getPriorityEnum(String priorityString) {
    switch (priorityString.toLowerCase()) {
      case 'high':
        return AssignmentPriority.high;
      case 'medium':
        return AssignmentPriority.medium;
      case 'low':
        return AssignmentPriority.low;
      default:
        return AssignmentPriority.medium; // Default fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredAssignments = _assignments.where((a) {
      if (_filter == 'all') return true;
      return a.status.name == _filter;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: filteredAssignments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: filteredAssignments.length,
                      itemBuilder: (context, index) =>
                          _buildAssignmentCard(filteredAssignments[index]),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 80,
        ), // Offset for your bottom nav
        child: FloatingActionButton(
          backgroundColor: Colors.indigo,
          onPressed: () => _showAddDialog(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  // UI COMPONENTS
  Widget _buildHeader() {
    final pendingCount = _assignments
        .where((a) => a.status == AssignmentStatus.pending)
        .length;
    final completedCount = _assignments
        .where((a) => a.status == AssignmentStatus.completed)
        .length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Assignments",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatCard(
                "$pendingCount",
                "Pending Tasks",
                Colors.orange[50]!,
                Colors.orange[900]!,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                "$completedCount",
                "Completed",
                Colors.green[50]!,
                Colors.green[900]!,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFilterTabs(),
        ],
      ),
    );
  }

  Widget _buildStatCard(String val, String label, Color bg, Color text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xFFE5E7EB)),
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              val,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: text,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: text.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Row(
      children: ['all', 'pending', 'completed'].map((f) {
        bool isSelected = _filter == f;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _filter = f),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.indigo[50] : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                f[0].toUpperCase() + f.substring(1),
                style: TextStyle(
                  color: isSelected ? Colors.indigo[700] : Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAssignmentCard(Assignment a) {
    final daysUntil = _getDaysUntilDue(a.dueDate);
    final isCompleted = a.status == AssignmentStatus.completed;

    return Opacity(
      opacity: isCompleted ? 0.6 : 1.0,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey[200]!),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _toggleStatus(a.id),
                child: Icon(
                  isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isCompleted ? Colors.green : Colors.grey[300],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          a.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _deleteAssignment(a.id),
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      a.subject,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    if (a.description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        a.description,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildBadge(
                          Icons.calendar_today,
                          daysUntil < 0 ? "Overdue" : "$daysUntil days left",
                          daysUntil < 0 ? Colors.red : Colors.orange,
                        ),
                        const SizedBox(width: 8),
                        _buildBadge(
                          Icons.priority_high,
                          "${a.priority.name} Priority",
                          a.priority == AssignmentPriority.high
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text("No assignments found", style: TextStyle(color: Colors.grey)),
    );
  }

  void _showAddDialog(BuildContext context) {
    // Placeholder for your form
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.7,
        child: AddAssignmentDialog(
          onSave: (Map<String, dynamic> data) {
            setState(() {
              _assignments.add(
                Assignment(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: data['title'],
                  subject: data['subject'],
                  dueDate: data['dueDate'],
                  description: data['description'],
                  priority: _getPriorityEnum(
                    data['priority'],
                  ), // Helper to convert String to Enum
                ),
              );
            });
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
