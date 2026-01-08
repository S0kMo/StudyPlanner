import 'package:flutter/material.dart';
import 'dart:math';

class ProgressOverview extends StatelessWidget {
  final int studyHours;
  final double attendanceRate;
  final int completedTasks;
  final int totalTasks;

  const ProgressOverview({
    super.key,
    required this.studyHours,
    required this.attendanceRate,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            Transform.translate(
              offset: const Offset(0, -32),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _KeyMetrics(
                      studyHours: studyHours,
                      attendanceRate: attendanceRate,
                      completedTasks: completedTasks,
                      totalTasks: totalTasks,
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Weekly Study Hours"),
                    const _WeeklyStudyChart(),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "Subject-wise Performance"),
                    const _SubjectPerformanceList(),
                    const SizedBox(height: 24),
                    const _SectionTitle(title: "This Week's Goals"),
                    _Goals(
                      studyHours: studyHours,
                      attendanceRate: attendanceRate,
                      completedTasks: completedTasks,
                      totalTasks: totalTasks,
                    ),
                    const SizedBox(height: 20),
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
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 50, 24, 48),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF4338CA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Overview',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your academic journey',
            style: TextStyle(color: Colors.indigo[100], fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _KeyMetrics extends StatelessWidget {
  final int studyHours;
  final double attendanceRate;
  final int completedTasks;
  final int totalTasks;

  const _KeyMetrics({
    required this.studyHours,
    required this.attendanceRate,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    const weeklyGoal = 20;
    final studyProgress = (studyHours / weeklyGoal) * 100;
    final taskCompletionRate =
        totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: _MetricCard(
              icon: Icons.watch_later_outlined,
              iconColor: Colors.blue[600]!,
              iconBgColor: Colors.blue[100]!,
              title: 'Study Hours',
              value: '${studyHours}h',
              progress: studyProgress / 100,
              progressColor: Colors.blue,
              footer: 'Goal: ${weeklyGoal}h/week',
            )),
            const SizedBox(width: 12),
            Expanded(
                child: _MetricCard(
              icon: Icons.trending_up,
              iconColor: Colors.green[600]!,
              iconBgColor: Colors.green[100]!,
              title: 'Attendance',
              value: '${attendanceRate.toStringAsFixed(0)}%',
              progress: attendanceRate / 100,
              progressColor: Colors.green,
              footer:
                  attendanceRate >= 75 ? 'Excellent!' : 'Needs improvement',
            )),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shadowColor: Colors.black.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _MetricIcon(
                        icon: Icons.check_box_outlined,
                        iconColor: Colors.orange[600]!,
                        bgColor: Colors.orange[100]!),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Task Completion',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF111827))),
                          Text(
                              '$completedTasks of $totalTasks tasks completed',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF4B5563))),
                        ],
                      ),
                    ),
                    Text('${taskCompletionRate.round()}%',
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827))),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: taskCompletionRate / 100,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation(Colors.orange),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBgColor, progressColor;
  final String title, value, footer;
  final double progress;

  const _MetricCard(
      {required this.icon,
      required this.iconColor,
      required this.iconBgColor,
      required this.progressColor,
      required this.title,
      required this.value,
      required this.footer,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MetricIcon(icon: icon, iconColor: iconColor, bgColor: iconBgColor),
            const SizedBox(height: 12),
            Text(value,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827))),
            const SizedBox(height: 4),
            Text(title,
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF4B5563))),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
            const SizedBox(height: 4),
            Text(footer,
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          ],
        ),
      ),
    );
  }
}

class _WeeklyStudyChart extends StatelessWidget {
  const _WeeklyStudyChart();

  @override
  Widget build(BuildContext context) {
    final weekData = [
      {'day': 'Mon', 'hours': 3.0},
      {'day': 'Tue', 'hours': 4.0},
      {'day': 'Wed', 'hours': 2.0},
      {'day': 'Thu', 'hours': 5.0},
      {'day': 'Fri', 'hours': 1.0},
      {'day': 'Sat', 'hours': 0.0},
      {'day': 'Sun', 'hours': 0.0},
    ];
    final maxHours = weekData.map((d) => d['hours'] as double).reduce(max);

    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 160,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekData.map((dayData) {
              final day = dayData['day'] as String;
              final hours = dayData['hours'] as double;
              final barHeight = maxHours > 0 ? (hours / maxHours) : 0.0;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FractionallySizedBox(
                          heightFactor: barHeight,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.indigo[500],
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(day,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF4B5563))),
                      Text('${hours.toStringAsFixed(0)}h',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF111827))),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _SubjectPerformanceList extends StatelessWidget {
  const _SubjectPerformanceList();

  @override
  Widget build(BuildContext context) {
    final subjectStats = [
      {
        'subject': 'Mathematics',
        'hours': 4.0,
        'attendance': 95.0,
      },
      {
        'subject': 'Physics',
        'hours': 3.5,
        'attendance': 90.0,
      },
      {
        'subject': 'Chemistry',
        'hours': 3.0,
        'attendance': 85.0,
      },
      {
        'subject': 'Computer Science',
        'hours': 4.5,
        'attendance': 100.0,
      },
      {
        'subject': 'English',
        'hours': 2.0,
        'attendance': 88.0,
      },
    ];

    return Column(
      children: subjectStats.map((data) {
        final hours = data['hours'] as double;
        final attendance = data['attendance'] as double;

        Color attendanceColor;
        if (attendance >= 90) {
          attendanceColor = Colors.green;
        } else if (attendance >= 75) {
          attendanceColor = Colors.orange;
        } else {
          attendanceColor = Colors.red;
        }

        return Card(
          elevation: 1,
          shadowColor: Colors.black.withOpacity(0.1),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data['subject'] as String,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF111827))),
                    Row(
                      children: [
                        Text('${hours.toStringAsFixed(1)}h',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF4B5563))),
                        const SizedBox(width: 16),
                        Text('${attendance.toStringAsFixed(0)}%',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF4B5563))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _TitledProgress(
                  title: 'Study Hours',
                  valueLabel: '${hours.toStringAsFixed(1)}/5h',
                  progress: hours / 5,
                ),
                const SizedBox(height: 8),
                _TitledProgress(
                  title: 'Attendance',
                  valueLabel: '${attendance.toStringAsFixed(0)}%',
                  progress: attendance / 100,
                  progressColor: attendanceColor,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _Goals extends StatelessWidget {
  final int studyHours;
  final double attendanceRate;
  final int completedTasks;
  final int totalTasks;

  const _Goals(
      {required this.studyHours,
      required this.attendanceRate,
      required this.completedTasks,
      required this.totalTasks});

  @override
  Widget build(BuildContext context) {
    const weeklyGoal = 20;
    final studyProgress = (studyHours / weeklyGoal);
    final taskCompletionRate =
        totalTasks > 0 ? (completedTasks / totalTasks) : 0.0;

    return Column(
      children: [
        _GoalCard(
          icon: Icons.track_changes,
          iconColor: Colors.green[600]!,
          iconBgColor: Colors.green[100]!,
          title: 'Study 20 hours',
          progress: studyProgress,
          progressColor: Colors.green,
          footer: '$studyHours/20 hours completed',
        ),
        const SizedBox(height: 12),
        _GoalCard(
          icon: Icons.check_box_outlined,
          iconColor: Colors.blue[600]!,
          iconBgColor: Colors.blue[100]!,
          title: 'Complete all assignments',
          progress: taskCompletionRate,
          progressColor: Colors.blue,
          footer: '$completedTasks/$totalTasks tasks completed',
        ),
        const SizedBox(height: 12),
        _GoalCard(
          icon: Icons.calendar_today,
          iconColor: Colors.purple[600]!,
          iconBgColor: Colors.purple[100]!,
          title: 'Maintain 90% attendance',
          progress: attendanceRate / 100,
          progressColor: Colors.purple,
          footer: 'Current: ${attendanceRate.toStringAsFixed(0)}%',
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor, iconBgColor, progressColor;
  final String title, footer;
  final double progress;

  const _GoalCard(
      {required this.icon,
      required this.iconColor,
      required this.iconBgColor,
      required this.progressColor,
      required this.title,
      required this.footer,
      required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MetricIcon(icon: icon, iconColor: iconColor, bgColor: iconBgColor, size: 32),
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
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(progressColor),
                  ),
                  const SizedBox(height: 4),
                  Text(footer,
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

// Common Helper Widgets
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

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

class _MetricIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final double size;

  const _MetricIcon(
      {required this.icon,
      required this.iconColor,
      required this.bgColor,
      this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: size * 0.5),
    );
  }
}

class _TitledProgress extends StatelessWidget {
  final String title;
  final String valueLabel;
  final double progress;
  final Color? progressColor;

  const _TitledProgress(
      {required this.title,
      required this.valueLabel,
      required this.progress,
      this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF4B5563))),
            Text(valueLabel,
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF4B5563))),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation(progressColor ?? Colors.blue),
        ),
      ],
    );
  }
}