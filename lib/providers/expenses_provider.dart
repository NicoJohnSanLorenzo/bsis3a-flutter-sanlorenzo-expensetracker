import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../db/expense_database.dart';
import '../services/api_service.dart';

/// Coordinates three data layers:
///
///  1. **SQLite**   (`ExpenseDatabase`) – primary local storage (always active).
///  2. **SharedPreferences**            – lightweight user settings (currency).
///  3. **REST API** (`ApiService`)      – syncs only when you have a real backend.
///                                        Call syncFromApi() manually once your
///                                        backend URL is set in api_service.dart.
class ExpensesProvider with ChangeNotifier {
  final ApiService _api = ApiService();
  final ExpenseDatabase _db = ExpenseDatabase.instance;

  List<Expense> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ── SharedPreferences keys ─────────────────────────────────────────────────
  static const _keyCurrency = 'currency';
  static const _keyLastSync = 'last_sync';

  String _currency = '₱';
  String? _lastSync;

  // ── Public getters ─────────────────────────────────────────────────────────
  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currency => _currency;
  String? get lastSync => _lastSync;

  // ── Initialisation ─────────────────────────────────────────────────────────
  ExpensesProvider() {
    _init();
  }

  /// Boot sequence:
  ///  1. Load saved preferences (currency, etc.).
  ///  2. Load SQLite data — UI is ready instantly, no network needed.
  Future<void> _init() async {
    await _loadPreferences();
    await _loadFromLocal();
  }

  // ── SharedPreferences ──────────────────────────────────────────────────────

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _currency = prefs.getString(_keyCurrency) ?? '₱';
    _lastSync = prefs.getString(_keyLastSync);
    notifyListeners();
  }

  Future<void> setCurrency(String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrency, symbol);
    _currency = symbol;
    notifyListeners();
  }

  Future<void> _saveLastSync() async {
    final prefs = await SharedPreferences.getInstance();
    _lastSync = DateTime.now().toLocal().toString();
    await prefs.setString(_keyLastSync, _lastSync!);
    notifyListeners();
  }

  // ── SQLite (primary storage) ───────────────────────────────────────────────

  Future<void> _loadFromLocal() async {
    _expenses = await _db.fetchAllExpenses();
    notifyListeners();
  }

  // ── CRUD — SQLite only (API calls added back once backend is ready) ─────────

  Future<void> addExpense(String title, double amount) async {
    final expense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      amount: amount,
    );
    _expenses.add(expense);
    await _db.insertExpense(expense);
    notifyListeners();
  }

  Future<void> editExpense(String id, String newTitle, double newAmount) async {
    final index = _expenses.indexWhere((e) => e.id == id);
    if (index == -1) return;

    _expenses[index].title = newTitle;
    _expenses[index].amount = newAmount;
    await _db.updateExpense(_expenses[index]);
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await _db.deleteExpense(id);
    notifyListeners();
  }

  // ── REST API sync (call this once your backend is ready) ───────────────────

  /// Pulls expenses from your backend and replaces the local SQLite cache.
  ///
  /// To activate:
  ///  1. Set [ApiService.baseUrl] to your backend URL (e.g. http://10.0.2.2:3000).
  ///  2. Call this method from a "Sync" button or on app start.
  Future<void> syncFromApi() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final remote = await _api.fetchExpenses();
      await _db.replaceAll(remote);
      _expenses = remote;
      await _saveLastSync();
    } catch (e) {
      _errorMessage = 'Sync failed: check your backend URL in api_service.dart.';
    } finally {
      _setLoading(false);
    }
  }

  // ── Utility ────────────────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
