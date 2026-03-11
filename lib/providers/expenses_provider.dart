import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpensesProvider with ChangeNotifier { // This creates a class that can "broadcast" updates, notifying the UI to rebuild.

  final List<Expense> _expenses = [ //
    Expense(id: "1", title: "Lunch", amount: 120),
    Expense(id: "2", title: "Transport", amount: 50),
  ]; 

  List<Expense> get expenses => _expenses;

  // CREATE
  void addExpense(String title, double amount) {
    _expenses.add(
      Expense(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
      ),
    );
    notifyListeners(); // This triggers the "ChangeNotifier."
  }

  // READ
  List<Expense> getExpenses() {
    return _expenses;
  }

  // UPDATE
  void editExpense(String id, String newTitle, double newAmount) {
    int index = _expenses.indexWhere((expense) => expense.id == id);

    if (index != -1) {
      _expenses[index].title = newTitle;
      _expenses[index].amount = newAmount;
      notifyListeners();
    }
  }

  // DELETE
  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }
}