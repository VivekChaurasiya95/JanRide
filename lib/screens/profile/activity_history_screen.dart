import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../navigation/app_router.dart';
import '../../viewmodels/activity_viewmodel.dart';

class ActivityHistoryScreen extends StatefulWidget {
  const ActivityHistoryScreen({super.key});

  @override
  State<ActivityHistoryScreen> createState() => _ActivityHistoryScreenState();
}

class _ActivityHistoryScreenState extends State<ActivityHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActivityViewModel>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActivityViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
      ),
      body: vm.isHistoryLoading
          ? const Center(child: CircularProgressIndicator())
          : vm.history.isEmpty
              ? Center(
                  child: Text(vm.errorMessage ?? 'No activity history available.'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: vm.history.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = vm.history[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.route, color: Color(0xFF2962FF)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.routeTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text('${item.dateLabel} • ${item.durationLabel}', style: const TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Rs ${item.fare.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2962FF))),
                              const SizedBox(height: 4),
                              Text(item.status.toUpperCase(), style: const TextStyle(fontSize: 11, color: Colors.green)),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, AppRouter.routeResults),
                                child: const Text('View'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}

