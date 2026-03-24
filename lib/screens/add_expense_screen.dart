import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expenses_provider.dart';

class AddExpenseScreen extends StatelessWidget {
  final Expense? expense; // null = add mode, non-null = edit mode

  final TextEditingController titleController;
  final TextEditingController amountController;

  AddExpenseScreen({super.key, this.expense})
      : titleController =
            TextEditingController(text: expense?.title ?? ''),
        amountController = TextEditingController(
            text: expense != null ? expense.amount.toString() : '');

  @override
  Widget build(BuildContext context) {
    final bool isEditing = expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Expense' : 'Add Expense',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Color.fromARGB(225, 247, 245, 245),
          ),
        ),
        elevation: 6,
        shadowColor: Colors.black45,
        backgroundColor: const Color.fromARGB(211, 41, 175, 50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Expense Title',
                prefixIcon: const Icon(Icons.receipt_long),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(211, 41, 175, 50),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.payments),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(211, 41, 175, 50),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(211, 41, 175, 50),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final title = titleController.text.trim();
                final amountText = amountController.text.trim();

                if (title.isEmpty || amountText.isEmpty) return;

                final amount = double.tryParse(amountText);
                if (amount == null) return;

                final provider =
                    Provider.of<ExpensesProvider>(context, listen: false);

                if (isEditing) {
                  provider.editExpense(expense!.id, title, amount);
                } else {
                  provider.addExpense(title, amount);
                }

                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Save Changes' : 'Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
