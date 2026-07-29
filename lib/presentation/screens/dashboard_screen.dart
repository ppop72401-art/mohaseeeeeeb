import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../../logic/providers/analytics_provider.dart';
import '../widgets/smart_kpi_card.dart';
import '../widgets/financial_chart.dart';
import '../widgets/smart_insights_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      body: Row(
        children: [
          // شريط جانبي صغير وذكي
          NavigationRail(
            backgroundColor: Theme.of(context).colorScheme.surface,
            selectedIndex: 0,
            onDestinationSelected: (int index) {},
            destinations: const [
              NavigationRailDestination(icon: Icon(FluentIcons.data_pie_24_regular), label: Text('تحليلات')),
              NavigationRailDestination(icon: Icon(FluentIcons.people_24_regular), label: Text('موردين')),
              NavigationRailDestination(icon: Icon(FluentIcons.settings_24_regular), label: Text('إعدادات')),
            ],
          ),
          Expanded(
            child: Consumer<AnalyticsProvider>(
              builder: (context, analytics, child) {
                if (analytics.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مركز التحليلات المتقدم', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      
                      // 1. مؤشرات الأداء (KPIs)
                      Row(
                        children: [
                          Expanded(child: SmartKpiCard(
                            title: 'إجمالي الديون القائمة',
                            amount: formatCurrency.format(analytics.totalDebt),
                            percentage: analytics.debtGrowthPercentage,
                            icon: FluentIcons.money_24_filled,
                            color: Colors.redAccent,
                          )),
                          const SizedBox(width: 16),
                          Expanded(child: SmartKpiCard(
                            title: 'إجمالي المدفوعات',
                            amount: formatCurrency.format(analytics.totalPayments),
                            percentage: 12.5, // قيمة افتراضية للنمو
                            icon: FluentIcons.wallet_24_filled,
                            color: Colors.greenAccent,
                          )),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // 2. الرسوم البيانية والذكاء الاصطناعي
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // المخطط البياني
                            Expanded(
                              flex: 2,
                              child: FinancialChart(data: analytics.monthlyExpenses),
                            ),
                            const SizedBox(width: 16),
                            // لوحة التحليلات الذكية النصية
                            Expanded(
                              flex: 1,
                              child: SmartInsightsList(insights: analytics.smartInsights),
                            ),
                          ],
                        ),
                      ),
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

