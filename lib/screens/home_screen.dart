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

              return ListTile(
                title: Text(expense.title),
                subtitle: Text("₱${expense.amount}"),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Edit button (Pencil Icon)
                    IconButton(
                      icon: Icon(Icons.edit),
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

                    // Delete button (Trashbin Icon)
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteExpense(expense.id);
                      },
                    ),

                  ],
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