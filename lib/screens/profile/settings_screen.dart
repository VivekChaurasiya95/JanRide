import 'package:flutter/material.dart';

import '../../navigation/app_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(
		title: const Text('Settings'),
		leading: IconButton(
		  icon: const Icon(Icons.arrow_back),
		  onPressed: () {
			if (Navigator.canPop(context)) {
			  Navigator.pop(context);
			} else {
			  Navigator.pushReplacementNamed(context, AppRouter.profile);
			}
		  },
		),
	  ),
	  body: ListView(
		padding: const EdgeInsets.all(20),
		children: const [
		  _SettingsTile(icon: Icons.person_outline, title: 'Account', subtitle: 'Manage profile and phone details'),
		  SizedBox(height: 12),
		  _SettingsTile(icon: Icons.notifications_none, title: 'Notifications', subtitle: 'Control alert preferences'),
		  SizedBox(height: 12),
		  _SettingsTile(icon: Icons.lock_outline, title: 'Privacy', subtitle: 'Control app privacy options'),
		  SizedBox(height: 12),
		  _SettingsTile(icon: Icons.language, title: 'Language', subtitle: 'Choose app display language'),
		],
	  ),
	);
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
	required this.icon,
	required this.title,
	required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
	return ListTile(
	  tileColor: Colors.white,
	  shape: RoundedRectangleBorder(
		borderRadius: BorderRadius.circular(16),
		side: BorderSide(color: Colors.grey.shade200),
	  ),
	  leading: Icon(icon, color: const Color(0xFF2962FF)),
	  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
	  subtitle: Text(subtitle),
	  trailing: const Icon(Icons.chevron_right),
	  onTap: () {},
	);
  }
}

