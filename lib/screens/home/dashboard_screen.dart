import 'package:flutter/material.dart';
import '../../models/employee_model.dart';
import '../../models/transaction_model.dart';

class DashboardScreen extends StatefulWidget {
  final List<Employee> employees;
  final List<Transaction> transactions;

  const DashboardScreen({
    required this.employees,
    required this.transactions,
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // Calculate statistics
    final totalEmployees = widget.employees.length;
    final totalTransactions = widget.transactions.length;
    final totalAmountGiven = widget.transactions
        .where((transaction) => transaction.type == 'Given')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
    final totalAmountReceived = widget.transactions
        .where((transaction) => transaction.type == 'Received')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatCard(
            title: 'Total Employees',
            value: '$totalEmployees',
            icon: Icons.people,
            color: Colors.blue,
          ),
          const SizedBox(height: 16.0),
          _buildStatCard(
            title: 'Total Transactions',
            value: '$totalTransactions',
            icon: Icons.receipt_long,
            color: Colors.green,
          ),
          const SizedBox(height: 16.0),
          _buildStatCard(
            title: 'Total Amount Given',
            value: 'Rs${totalAmountGiven.toStringAsFixed(2)}',
            icon: Icons.arrow_upward,
            color: Colors.red,
          ),
          const SizedBox(height: 16.0),
          _buildStatCard(
            title: 'Total Amount Received',
            value: 'Rs${totalAmountReceived.toStringAsFixed(2)}',
            icon: Icons.arrow_downward,
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
