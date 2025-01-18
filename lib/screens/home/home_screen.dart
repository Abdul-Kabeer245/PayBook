import 'dart:core';
import 'package:flutter/material.dart';
import 'package:myapp/models/employee_model.dart';
import 'package:myapp/models/transaction_model.dart';
import 'package:myapp/screens/transactions/transaction_screen.dart';
import '../../widgets/custom_app_bar.dart';
import '../employees/employee_screen.dart';
import '../../constant/app_colors.dart';
import '../transactions/add_transaction_screen.dart';
import '../settings/settings_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy data
  late List<Transaction> transactions;
  late List<Employee> employees;

  @override
  void initState() {
    super.initState();

    // Initialize transactions
    transactions = [
      Transaction(
        id: 1,
        employeeid: 1,
        type: 'Expense',
        amount: 100.0,
        description: 'Office Supplies',
        date: DateTime.now(),
      ),
      Transaction(
        id: 2,
        employeeid: 1,
        type: 'Income',
        amount: 200.0,
        description: 'Project Payment',
        date: DateTime.now(),
      ),
      Transaction(
        id: 3,
        employeeid: 2,
        type: 'Expense',
        amount: 150.0,
        description: 'Travel',
        date: DateTime.now(),
      ),
    ];

    // Initialize employees
    employees = [
      Employee(name: 'John Doe', phone: '1234567890', email: 'johndoe@example.com', id: 1),
      Employee(name: 'Jane Smith', phone: '9876543210', email: 'janesmith@example.com', id: 2),
    ];
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Screens
    final List<Map<String, dynamic>> screens = [
      {
        'title': 'Dashboard',
        'screen': DashboardScreen(employees: employees, transactions: transactions),
      },
      {
        'title': 'Employees',
        'screen': const EmployeesScreen(),
      },
      {
        'title': 'Transactions',
        'screen': const TransactionsScreen(),
      },
      {
        'title': 'Settings',
        'screen': const SettingsScreen(),
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: screens[_currentIndex]['title'],
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
              );
            },
          ),
        ],
      ),
      body: screens[_currentIndex]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Employees',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
