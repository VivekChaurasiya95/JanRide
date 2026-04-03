import 'package:flutter/material.dart';

import '../../navigation/app_router.dart';
import '../../widgets/bottom_nav_bar.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(
		title: const Text('Help & Support'),
		leading: IconButton(
		  icon: const Icon(Icons.arrow_back),
		  onPressed: () {
			if (Navigator.canPop(context)) {
			  Navigator.pop(context);
			} else {
			  Navigator.pushReplacementNamed(context, AppRouter.home);
			}
		  },
		),
	  ),
	  body: ListView(
		padding: const EdgeInsets.all(20),
		children: const [
		  _SupportTile(
			icon: Icons.call_outlined,
			title: 'Call Support',
			subtitle: 'Talk to our support team directly',
		  ),
		  SizedBox(height: 12),
		  _SupportTile(
			icon: Icons.chat_bubble_outline,
			title: 'Live Chat',
			subtitle: 'Start a quick chat with an agent',
		  ),
		  SizedBox(height: 12),
		  _SupportTile(
			icon: Icons.help_outline,
			title: 'FAQs',
			subtitle: 'Find common answers instantly',
		  ),
		  SizedBox(height: 12),
		  _SupportTile(
			icon: Icons.mail_outline,
			title: 'Email Support',
			subtitle: 'Write to us and get a response soon',
		  ),
		],
	  ),
	  bottomNavigationBar: const AppBottomNavBar(currentRoute: AppRouter.support),
	);
  }
}

class _SupportTile extends StatelessWidget {
  const _SupportTile({
	required this.icon,
	required this.title,
	required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
	return Container(
	  padding: const EdgeInsets.all(16),
	  decoration: BoxDecoration(
		color: Colors.white,
		borderRadius: BorderRadius.circular(16),
		border: Border.all(color: Colors.grey.shade200),
	  ),
	  child: Row(
		children: [
		  Container(
			padding: const EdgeInsets.all(10),
			decoration: BoxDecoration(
			  color: const Color(0xFFF1F5FF),
			  borderRadius: BorderRadius.circular(12),
			),
			child: Icon(icon, color: const Color(0xFF2962FF)),
		  ),
		  const SizedBox(width: 12),
		  Expanded(
			child: Column(
			  crossAxisAlignment: CrossAxisAlignment.start,
			  children: [
				Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
				Text(subtitle, style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
			  ],
			),
		  ),
		  const Icon(Icons.chevron_right, color: Colors.grey),
		],
	  ),
	);
  }
}

