import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatelessWidget {
  final String nickname;
  final int studyHours;
  final double attendanceRate;
  final int pendingTasks;

  const Dashboard({
    super.key,
    required this.nickname,
    required this.studyHours,
    required this.attendanceRate,
    required this.pendingTasks,
  });

  @override
  Widget build(BuildContext context) {
    final String currentDate =
        DateFormat('EEEE, MMMM d').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(currentDate: currentDate, nickname: nickname),
            Transform.translate(
              offset: const Offset(0, -16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _QuickStats(
                      studyHours: studyHours,
                      attendanceRate: attendanceRate,
                      pendingTasks: pendingTasks,
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Today's Schedule"),
                    const _ScheduleCard(
                      startTime: '09:00',
                      endTime: '11:00',
                      subject: 'Mathematics',
                      topic: 'Calculus - Chapter 5',
                      color: Colors.blue,
                    ),
                    const _ScheduleCard(
                      startTime: '13:00',
                      endTime: '15:00',
                      subject: 'Physics',
                      topic: 'Lab Experiment',
                      color: Colors.green,
                    ),
                    const _ScheduleCard(
                      startTime: '16:00',
                      endTime: '18:00',
                      subject: 'Computer Science',
                      topic: 'Data Structures',
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Upcoming Deadlines"),
                    const _DeadlineCard(
                      title: 'Physics Lab Report',
                      dueDate: 'Due in 2 days',
                      isUrgent: true,
                    ),
                    const _DeadlineCard(
                      title: 'Math Assignment',
                      dueDate: 'Due in 5 days',
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Weekly Progress"),
                    _WeeklyProgress(
                      studyHours: studyHours,
                      attendanceRate: attendanceRate,
                    ),
                    const SizedBox(height: 20), // Corresponds to pb-20
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.currentDate, required this.nickname});

  final String currentDate;
  final String nickname;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFADD1E9), Color.fromARGB(255, 37, 139, 180)],
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentDate,
                style: TextStyle(color: Colors.indigo[100], fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                'Hello, $nickname! 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Let's make today productive",
                style: TextStyle(color: Colors.indigo[100], fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({
    required this.studyHours,
    required this.attendanceRate,
    required this.pendingTasks,
  });

  final int studyHours;
  final double attendanceRate;
  final int pendingTasks;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickStatCard(
            icon: Icons.watch_later_outlined,
            value: '${studyHours}h',
            label: 'This Week',
            iconColor: Colors.indigo[600]!,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickStatCard(
            icon: Icons.trending_up,
            value: '${attendanceRate.toStringAsFixed(0)}%',
            label: 'Attendance',
            iconColor: Colors.green[600]!,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickStatCard(
            icon: Icons.article_outlined,
            value: '$pendingTasks',
            label: 'Tasks Due',
            iconColor: Colors.orange[600]!,
          ),
        ),
      ],
    );
  }
}

class _QuickStatCard extends StatelessWidget {
  const _QuickStatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827))),
            Text(label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF4B5563))),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827)),
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.topic,
    required this.color,
  });

  final String startTime;
  final String endTime;
  final String subject;
  final String topic;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: Column(
                children: [
                  Text(startTime,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B7280))),
                  Text(endTime,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B7280))),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827))),
                  Text(topic,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF4B5563))),
                ],
              ),
            ),
            Icon(Icons.check_box_outline_blank,
                color: Colors.grey[300], size: 22),
          ],
        ),
      ),
    );
  }
}

class _DeadlineCard extends StatelessWidget {
  const _DeadlineCard({
    required this.title,
    required this.dueDate,
    this.isUrgent = false,
  });

  final String title;
  final String dueDate;
  final bool isUrgent;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        isUrgent ? const Color(0xFFFFF7ED) : Colors.white;
    final Color borderColor =
        isUrgent ? const Color(0xFFFDBA74) : Colors.transparent;
    final IconData icon =
        isUrgent ? Icons.error_outline : Icons.calendar_today_outlined;
    final Color iconColor =
        isUrgent ? const Color(0xFFEA580C) : const Color(0xFF4F46E5);

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: 12),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF111827))),
                  const SizedBox(height: 4),
                  Text(dueDate,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF4B5563))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyProgress extends StatelessWidget {
  const _WeeklyProgress({
    required this.studyHours,
    required this.attendanceRate,
  });

  final int studyHours;
  final double attendanceRate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _ProgressSection(
              title: 'Study Goals',
              valueLabel: '$studyHours/20 hours',
              progress: (studyHours / 20).clamp(0.0, 1.0),
            ),
            const SizedBox(height: 16),
            _ProgressSection(
              title: 'Attendance',
              valueLabel: '${attendanceRate.toStringAsFixed(0)}%',
              progress: (attendanceRate / 100).clamp(0.0, 1.0),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressSection extends StatelessWidget {
  const _ProgressSection({
    required this.title,
    required this.valueLabel,
    required this.progress,
  });

  final String title;
  final String valueLabel;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 14, color: Color(0xFF374151))),
            Text(valueLabel,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111827))),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
          backgroundColor: Colors.grey[200],
        ),
      ],
    );
  }
}