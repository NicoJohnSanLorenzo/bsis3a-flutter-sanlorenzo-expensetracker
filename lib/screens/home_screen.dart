import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expenses_provider.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); //

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses"),
      ),

      body: Consumer<ExpensesProvider>(
        builder: (context, provider, child) {

          var expenses = provider.expenses;

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {

              var expense = expenses[index];

              return ListTile(
                title: Text(expense.title),
                subtitle: Text("₱${expense.amount}"),

                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    provider.deleteExpense(expense.id);
                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(),
            ),
          );
        },
      ),
    );
  }
}