import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

/// Manages the local SQLite database for offline expense persistence.
///
/// Usage:
///   final db = ExpenseDatabase.instance;
///   await db.insertExpense(expense);
class ExpenseDatabase {
  // Singleton — one database connection for the whole app lifetime.
  ExpenseDatabase._init();
  static final ExpenseDatabase instance = ExpenseDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    // getDatabasesPath() returns the platform-appropriate directory.
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Called once when the database file is first created.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id    TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        amount REAL NOT NULL
      )
    ''');
  }

  // ── CRUD Operations ────────────────────────────────────────────────────────

  /// Insert a new expense. Uses REPLACE so re-inserting the same id is safe.
  Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Fetch all expenses ordered by rowid (insertion order).
  Future<List<Expense>> fetchAllExpenses() async {
    final db = await database;
    final rows = await db.query('expenses', orderBy: 'rowid ASC');
    return rows.map(Expense.fromMap).toList();
  }

  /// Update title and amount for an existing expense.
  Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  /// Delete a single expense by id.
  Future<void> deleteExpense(String id) async {
    final db = await database;
    await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  /// Replace all local rows with a fresh list (called after an API sync).
  Future<void> replaceAll(List<Expense> expenses) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('expenses');
      for (final e in expenses) {
        await txn.insert('expenses', e.toMap());
      }
    });
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
