import 'package:flutter/material.dart';

class SmartInsightsList extends StatelessWidget {
  final List<Map<String, dynamic>> insights;

  const SmartInsightsList({Key? key, required this.insights}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('نظام التحليل الذكي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: insights.length,
              itemBuilder: (context, index) {
                final insight = insights[index];
                final isDanger = insight['type'] == 'danger';
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDanger ? Colors.redAccent.withOpacity(0.1) : Colors.orangeAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDanger ? Colors.redAccent.withOpacity(0.5) : Colors.orangeAccent.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(isDanger ? Icons.warning_rounded : Icons.info_outline, color: isDanger ? Colors.redAccent : Colors.orangeAccent, size: 20),
                          const SizedBox(width: 8),
                          Text(insight['title'], style: TextStyle(fontWeight: FontWeight.bold, color: isDanger ? Colors.redAccent : Colors.orangeAccent)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(insight['desc'], style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

