import 'package:flutter/material.dart';
import '../transactions/add_income_view.dart';
import '../transactions/add_expense_view.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({super.key});

  void _navigateToAddIncome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddIncomeView()),
    );
  }

  void _navigateToAddExpense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _navigateToAddIncome(context),
          icon: const Icon(Icons.add),
          label: const Text('Add Income'),
        ),
        ElevatedButton.icon(
          onPressed: () => _navigateToAddExpense(context),
          icon: const Icon(Icons.remove),
          label: const Text('Add Expense'),
        ),
      ],
    );
  }
}