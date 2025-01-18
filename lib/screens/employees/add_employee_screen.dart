import 'package:flutter/material.dart';
import '../../models/employee_model.dart';
import '../../services/db_helper.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final DBHelper _dbHelper = DBHelper.instance;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text.trim();
      final String phone = _phoneController.text.trim();
      final String email = _emailController.text.trim();

      final newEmployee = Employee(name: name, phone: phone, email: email);

      // Insert the new employee into the database
      await _dbHelper.insertEmployee(newEmployee);

      // Print confirmation and navigate back to the EmployeesScreen
      print('Employee added: $name, $phone, $email');
      Navigator.pop(context, true); // Send true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the employee\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                // validator: (value) {
                //   if (value == null || value.trim().isEmpty) {
                //     return 'Please enter the employee\'s phone number';
                //   }
                //   if (!RegExp(r'^\d+$').hasMatch(value)) {
                //     return 'Please enter a valid phone number';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                // validator: (value) {
                //   if (value == null || value.trim().isEmpty) {
                //     return 'Please enter the employee\'s email';
                //   }
                //   if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                //       .hasMatch(value)) {
                //     return 'Please enter a valid email address';
                //   }
                //   return null;
                // },
              ),
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEmployee,
                  child: const Text('Save Employee'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
