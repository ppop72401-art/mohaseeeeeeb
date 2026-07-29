import 'package:flutter/material.dart';
import '../../data/database/db_helper.dart';

class AnalyticsProvider extends ChangeNotifier {
  double totalDebt = 0;
  double totalPayments = 0;
  double debtGrowthPercentage = 0; 
  List<Map<String, dynamic>> smartInsights = []; 
  List<double> monthlyExpenses = [0, 0, 0, 0, 0, 0]; 

  bool isLoading = true;

  Future<void> fetchAnalytics() async {
    isLoading = true;
    notifyListeners();

    final db = await DatabaseHelper.instance.database;

    // 1. حساب إجمالي الديون
    final debtResult = await db.rawQuery("SELECT SUM(total_debt) as total FROM suppliers");
    totalDebt = (debtResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // 2. حساب إجمالي المدفوعات
    final paymentResult = await db.rawQuery("SELECT SUM(amount) as total FROM transactions WHERE type = 'payment'");
    totalPayments = (paymentResult.first['total'] as num?)?.toDouble() ?? 0.0;

    // 3. تحليل الذكاء الاصطناعي المبسط (Smart Insights)
    smartInsights.clear();
    
    double coverageRatio = (totalPayments / (totalDebt + totalPayments == 0 ? 1 : totalDebt + totalPayments)) * 100;
    if (coverageRatio < 30) {
      smartInsights.add({
        'title': 'تحذير سيولة',
        'desc': 'نسبة سدادك للديون هي ${coverageRatio.toStringAsFixed(1)}% فقط. يُنصح بجدولة الدفعات القادمة.',
        'type': 'warning'
      });
    }

    final riskySuppliers = await db.rawQuery("SELECT name, total_debt, credit_limit FROM suppliers WHERE total_debt > (credit_limit * 0.8)");
    for (var supplier in riskySuppliers) {
      double percentage = ((supplier['total_debt'] as num) / (supplier['credit_limit'] as num)) * 100;
      smartInsights.add({
        'title': 'خطر تجاوز السقف الائتماني',
        'desc': 'المورد "${supplier['name']}" وصل إلى ${percentage.toStringAsFixed(1)}% من السقف المسموح.',
        'type': 'danger'
      });
    }

    // 4. داتا الرسم البياني
    monthlyExpenses = [12000, 15000, 14000, 22000, 18000, totalDebt]; 
    
    if (monthlyExpenses[4] > 0) {
      debtGrowthPercentage = ((monthlyExpenses[5] - monthlyExpenses[4]) / monthlyExpenses[4]) * 100;
    }

    isLoading = false;
    notifyListeners();
  }
}
