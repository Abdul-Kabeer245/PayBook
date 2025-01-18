import 'package:myapp/models/transaction_model.dart' as trans; // Import alias for Transaction model
import 'package:myapp/models/employee_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const String _databaseName = 'paybook.db';
  static const int _databaseVersion = 1;

  static String tableEmployees = 'employees';
  static String tableTransactions = 'transactions';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableEmployees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT,
        email TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTransactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employeeid INTEGER NOT NULL,
        type  TEXT,
        amount REAL NOT NULL,
        description TEXT,
        date TEXT NOT NULL,
        FOREIGN KEY (employeeid) REFERENCES $tableEmployees (id)
      )
    ''');
  }
  
  // Insert an employee
    Future<int> insertEmployee(Employee employee) async{
      final db = await database;
      return await db.insert(tableEmployees, employee.toMap());
    }
     // Fetch all employees
  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final result = await db.query(tableEmployees);
    return result.map((e) => Employee.fromMap(e)).toList();
  }

  // Insert a transaction
  // Future<int> insertTransaction(trans.Transaction transaction) async {
  //   final db = await database;
  //   return await db.insert(tableTransactions, transaction.toMap());
  // }
  Future<int> insertTransaction(trans.Transaction transaction) async {
  final db = await database; // Ensure database is properly initialized
  return await db.insert(
    'transactions',
    transaction.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}


  // Fetch all transactions
  // Future<List<trans.Transaction>> getTransactions() async {  // Return type is List<trans.Transaction>
  //   final db = await database;
  //   final result = await db.query(tableTransactions);
  //   return result.map((t) => Transaction.fromMap(t)).toList(); // Use the alias trans.Transaction
  // }

  Future<List<trans.Transaction>> getTransactions() async {
  final db = await database;
  final result = await db.query(tableTransactions);
  return result.map((t) => trans.Transaction.fromMap(t)).toList(); // Correct alias
}
  // Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

