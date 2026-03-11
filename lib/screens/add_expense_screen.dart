import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expenses_provider.dart';

class AddExpenseScreen extends StatelessWidget {
  final Expense? expense; // null = add mode, non-null = edit mode

  final TextEditingController titleController;
  final TextEditingController amountController;

  AddExpenseScreen({super.key, this.expense})
      : titleController = TextEditingController(text: expense?.title ?? ''),
        amountController = TextEditingController(
            text: expense?.amount.toString() ?? '');

  @override
  Widget build(BuildContext context) {
    final bool isEditing = expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit Expense" : "Add Expense"),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Expense Title",
              ),
            ),

            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: "Amount",
              ),
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                final provider =
                    Provider.of<ExpensesProvider>(context, listen: false); // This looks up ExpensesProvider and calls function using "listen."

                if (isEditing) {
                  provider.editExpense(
                    expense!.id,
                    titleController.text,
                    double.parse(amountController.text),
                  );
                } else {
                  provider.addExpense(
                    titleController.text,
                    double.parse(amountController.text),
                  );
                }

                Navigator.pop(context);
              },
              child: Text(isEditing ? "Save Changes" : "Save Expense"),
            ),

          ],
        ),
      ),
    );
  }
}