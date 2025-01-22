import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../services/db_helper.dart';
import 'package:myapp/screens/transactions/add_transaction_screen.dart';


class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<List<Transaction>> _transactionsFuture;
  final DBHelper _dbHelper = DBHelper.instance;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    setState(() {
      _transactionsFuture = _dbHelper.getTransactions();
    });
  }

  Future<void> _refreshTransactions() async {
    _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No transactions available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            final transactions = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshTransactions,
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(
                        'Transaction ID: ${transaction.id ?? 'N/A'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Employee ID: ${transaction.employeeid ?? 'N/A'}'),
                          Text('Type: ${transaction.type ?? 'N/A'}'),
                          Text('Amount: \$${transaction.amount.toStringAsFixed(2)}'),
                          Text(
                            'Date: ${transaction.date.toLocal().toString().split(' ')[0]}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          if (transaction.description != null)
                            Text('Description: ${transaction.description!}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to transaction details if needed
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
          );
          if (result == true) {
            _refreshTransactions(); // Reload transactions after adding a new one
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}