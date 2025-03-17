import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/transaction_model.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: Hive.box<TransactionModel>('transactions').listenable(),
        builder: (context, Box<TransactionModel> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No transactions yet!', style: TextStyle(fontSize: 16, color: Colors.grey)));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final transaction = box.getAt(index);
              return ListTile(
                title: Text(transaction!.description),
                subtitle: Text(transaction.category),
                trailing: Text(
                  '${transaction.isIncome ? '+' : '-'} \$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(color: transaction.isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
