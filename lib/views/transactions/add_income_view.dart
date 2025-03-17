import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../models/transaction_model.dart';

class AddIncomeView extends StatefulWidget {
  const AddIncomeView({super.key});

  @override
  State<AddIncomeView> createState() => _AddIncomeViewState();
}

class _AddIncomeViewState extends State<AddIncomeView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Salary';

  final List<String> _categories = ['Salary', 'Business', 'Investment', 'Other'];

  void _saveIncome() async {
    if (_amountController.text.isEmpty) return;

    final transactionBox = Hive.box<TransactionModel>('transactions');
    transactionBox.add(TransactionModel(
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      description: _descriptionController.text,
      isIncome: true, // true for income
    ));

    _amountController.clear();
    _descriptionController.clear();
    setState(() => _selectedCategory = 'Salary');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Income')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount')),
            const SizedBox(height: 10),
            DropdownButtonFormField(value: _selectedCategory, items: _categories.map((category) => DropdownMenuItem(value: category, child: Text(category))).toList(), onChanged: (value) => setState(() => _selectedCategory = value!)),
            const SizedBox(height: 10),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _saveIncome, child: const Text('Save Income'))),
          ],
        ),
      ),
    );
  }
}
