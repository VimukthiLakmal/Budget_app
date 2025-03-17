import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/backup_service.dart'; // Ensure the BackupService is correctly imported
import '../../models/transaction_model.dart'; // Import your transaction model

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Calculate the balance from Hive transactions
    double balance = 0.0;

    // Open the Hive box to get the transactions
    var transactionsBox = Hive.box<TransactionModel>('transactions');

    // Calculate the balance by iterating through the transactions
    for (var transaction in transactionsBox.values) {
      if (transaction.type == 'income') {
        balance += transaction.amount;
      } else if (transaction.type == 'expenditure') {
        balance -= transaction.amount;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Budget App"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Balance Display
            Text(
              'Current Balance: \$${balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32), // Space between balance and buttons

            // Backup Button
            ElevatedButton(
              onPressed: () async {
                await BackupService.backupToGoogleDrive();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Backup Completed Successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Green color for backup
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("Backup to Google Drive"),
            ),
            SizedBox(height: 16), // Space between buttons

            // Restore Button
            ElevatedButton(
              onPressed: () async {
                bool success = await BackupService.restoreFromGoogleDrive();
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Restore Completed Successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No Backup Found')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Blue color for restore
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("Restore from Google Drive"),
            ),
            SizedBox(height: 32), // Space between buttons and additional button

            // Additional Backup Button at the bottom
            ElevatedButton(
              onPressed: () async {
                await BackupService.backupToGoogleDrive();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Backup Completed Successfully')),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Different color for additional backup
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              child: Text("Additional Backup"),
            ),
          ],
        ),
      ),
    );
  }
}
