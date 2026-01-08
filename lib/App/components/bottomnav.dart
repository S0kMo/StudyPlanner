import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final String activeTab;
  final Function(String) onTabChanged;

  const BottomNav({
    super.key,
    required this.activeTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _getTabIndex(activeTab),
      onTap: (index) {
        onTabChanged(_getTabName(index));
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Planner',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_outlined),
          activeIcon: Icon(Icons.assignment),
          label: 'Attendance',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.task_outlined),
          activeIcon: Icon(Icons.task),
          label: 'Task',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_outlined),
          activeIcon: Icon(Icons.trending_up),
          label: 'Progress',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  int _getTabIndex(String tabName) {
    switch (tabName) {
      case 'home':
        return 0;
      case 'planner':
        return 1;
      case 'attendance':
        return 2;
      case 'assignments':
        return 3;
      case 'progress':
        return 4;
      case 'profile':
        return 5;
      default:
        return 0;
    }
  }

  String _getTabName(int index) {
    switch (index) {
      case 0:
        return 'home';
      case 1:
        return 'planner';
      case 2:
        return 'attendance';
      case 3:
        return 'assignments';
      case 4:
        return 'progress';
      case 5:
        return 'profile';
      default:
        return 'home';
    }
  }
}
