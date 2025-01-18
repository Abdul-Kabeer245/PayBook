import 'package:flutter/material.dart';
import '../../models/employee_model.dart';
import '../../services/db_helper.dart';
import '../../widgets/employee_card.dart';
import 'add_employee_screen.dart';
import 'employee_details_screen.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final DBHelper _dbHelper = DBHelper.instance;
  List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    final employees = await _dbHelper.getEmployees();
    setState(() {
      _employees = employees;
    });
  }

  void _navigateToAddEmployee() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEmployeeScreen()),
    );

    if (result == true) {
      // Refresh the employee list after adding a new employee
      _fetchEmployees();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _employees.isEmpty
          ? const Center(child: Text('No employees found.'))
          : ListView.builder(
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];
                return EmployeeCard(
                  employee: employee,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmployeeDetailScreen(
                          employeeId: employee.id ?? 0,
                          employeeName: employee.name,
                          employeeEmail: employee.email,
                          employeePhone: employee.phone,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddEmployee,
        child: const Icon(Icons.add),
      ),
    );
  }
}
