import 'dart:core';
import 'package:flutter/material.dart';
import 'package:myapp/models/employee_model.dart' as employee_model;
import 'package:myapp/models/transaction_model.dart';
import 'package:myapp/screens/transactions/add_transaction_screen.dart';
import 'package:myapp/screens/transactions/transaction_screen.dart';
import '../../widgets/custom_app_bar.dart';
import '../employees/employee_screen.dart';
import '../../constant/app_colors.dart';
import '../settings/settings_screen.dart';
import 'dashboard_screen.dart';
import 'package:myapp/services/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy data  late List<Transaction> transactions;
  List<employee_model.Employee> employees = [];
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    // Fetch employees and transactions from DBHelper

    _loadData();
  }

  // Method to fetch data from DBHelper
  Future<void> _loadData() async {
    final dbHelper = DBHelper.instance;

    // Fetch employees and transactions from the database
    final employeeList = await dbHelper.getEmployees();
    final transactionList = await dbHelper.getTransactions();
    
    print('Employees: $employeeList');
    print('Transactions: $transactionList'); 
    
    setState(() {
      employees = employeeList; // Assign to the employees list
      transactions = transactionList; // Assign to the transactions list
    });
      print('Employees length: ${employees.length}'); // Log the employee list
  print('Transactions length: ${transactions.length}'); // Log the transaction list
  print('employees: $employees');
  print('transactions: $transactions');
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Screens
    final List<Map<String, dynamic>> screens = [
      {
        'title': 'Dashboard',
        'screen':
            DashboardScreen(employees: employees, transactions: transactions),
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
        title: screens[currentIndex]['title'],
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: AppColors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddTransactionScreen()),
              );
            },
          ),
        ],
      ),
      body: screens[currentIndex]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
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
