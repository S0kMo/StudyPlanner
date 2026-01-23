import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studyplannerapp/Style/apptheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyplannerapp/App/services/database_service.dart';
import 'package:studyplannerapp/App/services/mock_data_service.dart';
//Note: all commented code lines with "Todo: Add mock data" are intentional and should remain commented until mock data is added. jam add code freature pg, puk ah feature ng dak jol folder ui hv
import 'components/welcomescreen.dart';
import 'components/bottomnav.dart';
import 'components/dashboard.dart';
import 'components/studyplanner.dart';
import 'components/attendancetracker.dart';
import 'components/assignmentmanager.dart';
import 'components/progressoverview.dart';
import 'components/profile.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const StudyTrackApp(),
  ),
);

class StudyTrackApp extends StatelessWidget {
  const StudyTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTrack',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const AppRoot(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  bool _isOnboarded = false;
  String _nickname = '';
  String _activeTab = 'home';
  late DatabaseService _databaseService;

  // Mock data for progress tracking
  final int _studyHours = 15;
  final int _attendanceRate = 87;
  final int _pendingTasks = 3;
  final int _completedTasks = 2;
  final int _totalTasks = 5;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _loadSavedData();
  }

  Future<void> _initDatabase() async {
    _databaseService = DatabaseService();
    await _databaseService.init();

    // Seed mock data for testing
    final mockDataService = MockDataService(_databaseService);
    await mockDataService.seedMockData();
  }

  // Load saved data from SharedPreferences (equivalent to localStorage)
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNickname = prefs.getString('studytrack_nickname');
    if (savedNickname != null && savedNickname.isNotEmpty) {
      setState(() {
        // Todo: Add mock data
        _nickname = savedNickname;
        _isOnboarded = true;
      });
    }
  }

  Future<void> _handleOnboardingComplete(String userNickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('studytrack_nickname', userNickname);
    setState(() {
      _nickname = userNickname;
      _isOnboarded = true;
    });
  }

  Future<void> _handleNicknameChange(String newNickname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('studytrack_nickname', newNickname);
    setState(() {
      _nickname = newNickname;
    });
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('studytrack_nickname');
    setState(() {
      _isOnboarded = false;
      _nickname = '';
      _activeTab = 'home';
    });
  }

  Widget _buildActiveTab() {
    switch (_activeTab) {
      case 'home':
        return Dashboard(
          //Todo: Add mock data
          nickname: _nickname,
          studyHours: _studyHours,
          attendanceRate: _attendanceRate.toDouble(),
          pendingTasks: _pendingTasks,
        );
      case 'planner':
        return const StudyPlanner();
      case 'attendance':
        return const AttendanceTracker();
      case 'assignments':
        return const AssignmentManager();
      case 'progress':
        return ProgressOverview(
          studyHours: _studyHours,
          attendanceRate: _attendanceRate.toDouble(),
          completedTasks: _completedTasks,
          totalTasks: _totalTasks,
        );
      case 'profile':
        return Profile(
          nickname: _nickname,
          onNicknameChange: _handleNicknameChange,
          onLogout: _handleLogout,
        );
      default:
        return Dashboard(
          nickname: _nickname,
          studyHours: _studyHours,
          attendanceRate: _attendanceRate.toDouble(),
          pendingTasks: _pendingTasks,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOnboarded) {
      return WelcomeScreen(onOnboardingComplete: _handleOnboardingComplete);
    }

    return Scaffold(
      body: _buildActiveTab(),
      bottomNavigationBar: BottomNav(
        activeTab: _activeTab,
        onTabChanged: (newTab) {
          setState(() {
            _activeTab = newTab;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _databaseService.close();
    super.dispose();
  }
}
