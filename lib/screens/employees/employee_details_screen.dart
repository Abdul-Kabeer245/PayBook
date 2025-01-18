import 'package:flutter/material.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final String employeeName;
  final int? employeeId;
  final String? employeePhone;
  final String? employeeEmail;
  final List<Map<String, dynamic>>? transactions; // Example transactions

  const EmployeeDetailScreen({
    super.key,
    required this.employeeName,
    this.employeeId,
    this.employeePhone,
    this.employeeEmail,
    this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              employeeName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (employeePhone != null) ...[
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16.0),
                  const SizedBox(width: 8.0),
                  Text(employeePhone!),
                ],
              ),
            ],
            if (employeeEmail != null && employeeEmail!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Icon(Icons.email, size: 16.0),
                  const SizedBox(width: 8.0),
                  Text(employeeEmail!),
                ],
              ),
            ],
            const Divider(height: 32.0, thickness: 1.0),
            Text(
              'Transactions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              child: transactions == null || transactions!.isEmpty
                  ? const Center(
                      child: Text('No transactions available.'),
                    )
                  : ListView.builder(
                      itemCount: transactions?.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions![index];
                        return Card(
                          elevation: 2.0,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: Icon(
                              transaction['type'] == 'credit'
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: transaction['type'] == 'credit'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: Text(transaction['description']),
                            subtitle: Text(transaction['date']),
                            trailing: Text(
                              'Rs{transaction["amount"]}',
                              style: TextStyle(
                                color: transaction['type'] == 'credit'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
