import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ================= MODEL =================
class AttendanceRecord {
  final String id;
  final String subject;
  final String date; // yyyy-MM-dd
  final String status; // present | absent | leave

  AttendanceRecord({
    required this.id,
    required this.subject,
    required this.date,
    required this.status,
  });
}

/// ================= WIDGET =================
class AttendanceTracker extends StatefulWidget {
  final List<String> subjects;

  const AttendanceTracker({
    super.key,
    required this.subjects,
  });

  @override
  State<AttendanceTracker> createState() => _AttendanceTrackerState();
}

class _AttendanceTrackerState extends State<AttendanceTracker> {
  String selectedSubject = "all";
  String? selectedDate;

  final List<AttendanceRecord> _records = [];

  final DateTime today = DateTime.now();

  /// ================= FILTER =================
  List<AttendanceRecord> get filteredRecords {
    if (selectedSubject == "all") return _records;
    return _records.where((r) => r.subject == selectedSubject).toList();
  }

  /// ================= STATS =================
  Map<String, dynamic> getStats() {
    final present =
        filteredRecords.where((r) => r.status == "present").length;
    final absent =
        filteredRecords.where((r) => r.status == "absent").length;
    final leave =
        filteredRecords.where((r) => r.status == "leave").length;
    final total = filteredRecords.length;

    final percentage = total == 0 ? 0 : ((present / total) * 100).round();

    final sorted = [...filteredRecords]
      ..sort((a, b) => b.date.compareTo(a.date));

    int streak = 0;
    for (final r in sorted) {
      if (r.status == "present") {
        streak++;
      } else {
        break;
      }
    }

    return {
      "present": present,
      "absent": absent,
      "leave": leave,
      "total": total,
      "percentage": percentage,
      "streak": streak,
    };
  }

  AttendanceRecord? getAttendanceForDate(String date) {
    try {
      return filteredRecords.firstWhere((r) => r.date == date);
    } catch (_) {
      return null;
    }
  }

  /// ================= CALENDAR =================
  List<int?> getDaysArray() {
    final firstDay = DateTime(today.year, today.month, 1);
    final daysInMonth =
        DateTime(today.year, today.month + 1, 0).day;

    final days = <int?>[];

    for (int i = 0; i < firstDay.weekday % 7; i++) {
      days.add(null);
    }
    for (int i = 1; i <= daysInMonth; i++) {
      days.add(i);
    }

    return days;
  }

  String formatDate(int day) {
    return DateFormat("yyyy-MM-dd")
        .format(DateTime(today.year, today.month, day));
  }

  bool isToday(int day) => day == today.day;

  Color statusColor(String status) {
    switch (status) {
      case "present":
        return Colors.green.shade100;
      case "absent":
        return Colors.red.shade100;
      case "leave":
        return Colors.yellow.shade100;
      default:
        return Colors.white;
    }
  }

  void saveAttendance(String status) {
    if (selectedDate == null) return;

    final subject =
        selectedSubject == "all" ? widget.subjects.first : selectedSubject;

    setState(() {
      _records.removeWhere(
          (r) => r.date == selectedDate && r.subject == subject);

      _records.add(
        AttendanceRecord(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          subject: subject,
          date: selectedDate!,
          status: status,
        ),
      );
    });

    Navigator.pop(context);
    selectedDate = null;
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    final stats = getStats();
    final days = getDaysArray();
    final monthName = DateFormat("MMMM yyyy").format(today);

    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Tracker")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER + FILTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Attendance Tracker",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Track your class attendance",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                DropdownButton<String>(
                  value: selectedSubject,
                  items: [
                    const DropdownMenuItem(
                        value: "all", child: Text("All Subjects")),
                    ...widget.subjects.map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => selectedSubject = v!),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// STATS GRID
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _stat("Present", stats["present"], Icons.check_circle, Colors.green),
                _stat("Absent", stats["absent"], Icons.cancel, Colors.red),
                _stat("Leave", stats["leave"], Icons.schedule, Colors.orange),
                _stat("Streak", "${stats["streak"]} days",
                    Icons.trending_up, Colors.blue),
              ],
            ),

            const SizedBox(height: 20),

            /// PERCENTAGE CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Overall Attendance",
                                style: TextStyle(color: Colors.grey)),
                            Text("${stats["percentage"]}%",
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Total Classes",
                                style: TextStyle(color: Colors.grey)),
                            Text("${stats["total"]}",
                                style: const TextStyle(fontSize: 22)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: stats["percentage"] / 100,
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CALENDAR
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(monthName,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                      ),
                      itemCount: days.length,
                      itemBuilder: (_, i) {
                        final day = days[i];
                        if (day == null) return const SizedBox();

                        final date = formatDate(day);
                        final record = getAttendanceForDate(date);

                        return GestureDetector(
                          onTap: () {
                            selectedDate = date;
                            showDialog(
                              context: context,
                              builder: (_) => _attendanceDialog(),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: record == null
                                  ? Colors.white
                                  : statusColor(record.status),
                              border: Border.all(
                                color: isToday(day)
                                    ? Colors.blue
                                    : Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text("$day"),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Click on any date to mark attendance",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(
      String title, dynamic value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(title),
            Text("$value",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _attendanceDialog() {
    return AlertDialog(
      title: const Text("Mark Attendance"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: () => saveAttendance("present"),
              child: const Text("Present")),
          ElevatedButton(
              onPressed: () => saveAttendance("absent"),
              child: const Text("Absent")),
          ElevatedButton(
              onPressed: () => saveAttendance("leave"),
              child: const Text("Leave")),
        ],
      ),
    );
  }
}
