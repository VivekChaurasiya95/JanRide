import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/app_router.dart';
import '../../viewmodels/activity_viewmodel.dart';

class FavoriteRoutesScreen extends StatelessWidget {
  const FavoriteRoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivityViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Routes')),
      body: vm.favoriteRoutes.isEmpty
          ? const Center(child: Text('No favorite routes found.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: vm.favoriteRoutes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final route = vm.favoriteRoutes[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  title: Text(route.title),
                  subtitle: Text(route.description),
                  trailing: TextButton(
                    onPressed: () => Navigator.pushNamed(context, AppRouter.search),
                    child: const Text('Plan'),
                  ),
                );
              },
            ),
    );
  }
}

