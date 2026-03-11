import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expenses_provider.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
          "Expense Tracker",
          style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: Color.fromARGB(225, 247, 245, 245)
        ),
      ),
    elevation: 6,
    shadowColor: Colors.black45,
    backgroundColor: const Color.fromARGB(211, 41, 175, 50),
),

      body: Consumer<ExpensesProvider>( // This looks up widget tree for an instance of "ExpensesProvider."
        builder: (context, provider, child) { // This is a callback function that runs whenever data changes in "ExpensesProvider."
          var expenses = provider.expenses; // This extracts a specific list or propety called expenses from the provider to build the UI.

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              var expense = expenses[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

        leading: CircleAvatar(
          backgroundColor: const Color.fromARGB(211, 41, 175, 50),
          child: const Icon(
          Icons.attach_money,
          color: Colors.white,
        ),
      ),

        title: Text(
          expense.title,
          style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),

        subtitle: Text(
          "₱${expense.amount}",
          style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),

    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddExpenseScreen(
                  expense: expense,
                ),
              ),
            );
          },
        ),

        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            provider.deleteExpense(expense.id);
          },
        ),

      ],
    ),
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