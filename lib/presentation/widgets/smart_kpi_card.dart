import 'package:flutter/material.dart';

class SmartKpiCard extends StatelessWidget {
  final String title;
  final String amount;
  final double percentage;
  final IconData icon;
  final Color color;

  const SmartKpiCard({Key? key, required this.title, required this.amount, required this.percentage, required this.icon, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPositive = percentage >= 0;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
              Icon(icon, color: color),
            ],
          ),
          const SizedBox(height: 16),
          Text(amount, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, color: isPositive ? Colors.redAccent : Colors.greenAccent, size: 16),
              const SizedBox(width: 4),
              Text('${percentage.abs().toStringAsFixed(1)}% مقارنة بالشهر السابق', style: TextStyle(color: isPositive ? Colors.redAccent : Colors.greenAccent, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

