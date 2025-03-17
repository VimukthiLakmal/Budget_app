import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isIncome; // true = income, false = expense

  TransactionModel({
    required this.amount,
    required this.category,
    required this.description,
    required this.isIncome,
  });
}
