import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expenses_provider.dart';

class AddExpenseScreen extends StatelessWidget {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  AddExpenseScreen({super.key}); //

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
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

                Provider.of<ExpensesProvider>(context, listen: false)
                    .addExpense(
                  titleController.text,
                  double.parse(amountController.text),
                );

                Navigator.pop(context);
              },
              child: Text("Save Expense"),
            )
          ],
        ),
      ),
    );
  }
}