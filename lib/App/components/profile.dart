import 'dart:ui';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String nickname;
  final Function(String) onNicknameChange;
  final Function() onLogout;

  const Profile({
    super.key,
    required this.nickname,
    required this.onNicknameChange,
    required this.onLogout,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _darkMode = false;
  bool _notifications = true;
  late TextEditingController _nicknameController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.nickname);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String get _initial =>
      widget.nickname.isNotEmpty ? widget.nickname[0].toUpperCase() : '?';

  void _showEditProfileDialog() {
    // Ensure the temp controller is up-to-date when opening
    _nicknameController.text = widget.nickname;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(labelText: 'Nickname'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'your.email@example.com',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: '+885(0)68 168 168',
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nicknameController.text.trim().isNotEmpty) {
                widget.onNicknameChange(_nicknameController.text.trim());
                // Also update local state for non-persisted fields
                setState(() {});
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(
              nickname: widget.nickname,
              initial: _initial,
              onEdit: _showEditProfileDialog,
            ),
            Transform.translate(
              offset: const Offset(0, -48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle("Settings"),
                    _SettingsCard(
                      notifications: _notifications,
                      darkMode: _darkMode,
                      onNotificationChanged: (val) =>
                          setState(() => _notifications = val),
                      onDarkModeChanged: (val) =>
                          setState(() => _darkMode = val),
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle("Contact Information"),
                    _ContactCard(
                      email: _emailController.text,
                      phone: _phoneController.text,
                    ),
                    const SizedBox(height: 24),
                    const _SectionTitle("About"),
                    const _AboutCard(),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: widget.onLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        foregroundColor: Colors.red[600],
                        side: BorderSide(color: Colors.red[200]!),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const _FooterNote(),
                    const SizedBox(height: 24),
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

// --- Header & Profile Card ---
class _Header extends StatelessWidget {
  final String nickname;
  final String initial;
  final VoidCallback onEdit;

  const _Header({
    required this.nickname,
    required this.initial,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 64),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFBBE7EF), Color(0xFF768E98)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  color: Colors.white.withOpacity(0.1),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.indigo[500],
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nickname,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Student',
                                  style: TextStyle(color: Colors.indigo[100]),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                            ),
                            onPressed: onEdit,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Color(0x33FFFFFF)),
                      const SizedBox(height: 8),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(value: '12', label: 'Subjects'),
                          _StatItem(value: '24', label: 'Tasks Done'),
                          _StatItem(value: '87%', label: 'Attendance'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.indigo[100], fontSize: 12)),
      ],
    );
  }
}

// --- Section Cards ---
class _SettingsCard extends StatelessWidget {
  final bool notifications;
  final bool darkMode;
  final ValueChanged<bool> onNotificationChanged;
  final ValueChanged<bool> onDarkModeChanged;

  const _SettingsCard({
    required this.notifications,
    required this.darkMode,
    required this.onNotificationChanged,
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Receive study reminders'),
            secondary: const _IconCircle(
              icon: Icons.notifications_outlined,
              iconColor: Colors.blue,
              bgColor: Colors.blue,
            ),
            value: notifications,
            onChanged: onNotificationChanged,
          ),
          const Divider(height: 1),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle dark theme'),
            secondary: _IconCircle(
              icon: darkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              iconColor: Colors.purple,
              bgColor: Colors.purple,
            ),
            value: darkMode,
            onChanged: onDarkModeChanged,
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String email;
  final String phone;

  const _ContactCard({required this.email, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            leading: const _IconCircle(
              icon: Icons.mail_outline,
              iconColor: Colors.green,
              bgColor: Colors.green,
            ),
            title: const Text('Email'),
            subtitle: Text(email.isNotEmpty ? email : 'Not set'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const _IconCircle(
              icon: Icons.phone_outlined,
              iconColor: Colors.orange,
              bgColor: Colors.orange,
            ),
            title: const Text('Phone'),
            subtitle: Text(phone.isNotEmpty ? phone : 'Not set'),
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.1),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          const ListTile(title: Text('App Version'), trailing: Text('1.0.0')),
          const Divider(height: 1),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 0,
        color: Colors.blue[50],
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue[200]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Your data is stored locally on your device. No account required.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF4B5563)),
          ),
        ),
      ),
    );
  }
}

// --- Common Helper Widgets ---
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111827),
        ),
      ),
    );
  }
}

class _IconCircle extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _IconCircle({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor),
    );
  }
}
