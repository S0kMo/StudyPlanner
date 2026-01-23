import 'dart:ui';
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
    return Padding(
      // 1. Padding creates the "Floating" effect
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
      child: ClipRRect(
        // 2. ClipRRect ensures everything stays inside the round pill
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          // 3. The Glassmorphism Blur
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15), // Translucent background
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ).withOpacity(0.2), // Subtle glass edge
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _getTabIndex(activeTab),
              onTap: (index) {
                onTabChanged(_getTabName(index));
              },
              // 4. Critical Styles for the "Detached" look
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: const Color.fromARGB(255, 203, 192, 90),
              unselectedItemColor: Colors.black87,
              iconSize: 24,
              showSelectedLabels: false, // Optional: Hiding labels makes it
              showUnselectedLabels: false, // look much more "futuristic"
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
            ),
          ),
        ),
      ),
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
