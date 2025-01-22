import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/employee_model.dart';
import 'package:myapp/services/db_helper.dart';
import 'package:myapp/widgets/custom_app_bar.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _transactionType = 'Given';
  String? _selectedEmployee;
  int? _selectedEmployeeId;
  DateTime _selectedDate = DateTime.now();
  // List<Map<String, dynamic>> _employees = []; // Initially empty
  bool _isLoading = true; // To track loading state
  final DBHelper _dbHelper = DBHelper.instance;
  List<Employee> _employees = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployees(); // Fetch employee data on init
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Fetch employees from the database
    Future<void> _fetchEmployees() async {
    final employees = await _dbHelper.getEmployees();
    setState(() {
      _employees = employees;
    });
  }
  // Future<void> _fetchEmployees() async {
  //   try {
  //     // Simulate a database fetch with a delay (replace with actual DB call)
  //     await Future.delayed(const Duration(seconds: 2));
  //     // Assume this is the data fetched from your database
  //     final fetchedEmployees = [
  //       {'id': 1, 'name': 'John Doe'},
  //       {'id': 2, 'name': 'Jane Smith'},
  //       {'id': 3, 'name': 'Alice Johnson'},
  //       {'id': 4, 'name': 'Bob Brown'},
  //     ];

  //     setState(() {
  //       _employees = fetchedEmployees;
  //       _isLoading = false; // Stop loading
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to fetch employees: $e')),
  //     );
  //   }
  // }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate() && _selectedEmployeeId != null) {
      // Save the transaction logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction saved successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all mandatory fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Add Transaction",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator()) // Loading indicator
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Transaction Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _transactionType,
                        items: ['Given', 'Received']
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _transactionType = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Transaction Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Searchable Employee Dropdown using DropdownButton2
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Select Employee',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: _employees
                              .map((employee) => DropdownMenuItem<String>(
                                    value: employee['name'],
                                    child: Text(
                                      employee['name'],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ))
                              .toList(),
                          value: _selectedEmployee,
                          onChanged: (value) {
                            setState(() {
                              _selectedEmployee = value;
                              _selectedEmployeeId = _employees.firstWhere(
                                (e) => e['name'] == value,
                              )['id'];
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: double.infinity,
                          ),
                          dropdownStyleData: const DropdownStyleData(
                            maxHeight: 200,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                          dropdownSearchData: DropdownSearchData(
                            searchController: _searchController,
                            searchInnerWidgetHeight: 50,
                            searchInnerWidget: Container(
                              height: 50,
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  hintText: 'Search for an employee...',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            searchMatchFn: (item, searchValue) {
                              return item.value
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchValue.toLowerCase());
                            },
                          ),
                          onMenuStateChange: (isOpen) {
                            if (!isOpen) {
                              _searchController.clear();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Amount Input Field
                      TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),

                      // Date Picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: const Text('Select Date'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),

                      // Description Input Field
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16.0),

                      // Save Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveTransaction,
                          child: const Text('Save Transaction'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
