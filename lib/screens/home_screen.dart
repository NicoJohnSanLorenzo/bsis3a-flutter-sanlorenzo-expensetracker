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
          'Expense Tracker',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Color.fromARGB(225, 247, 245, 245),
          ),
        ),
        elevation: 6,
        shadowColor: Colors.black45,
        backgroundColor: const Color.fromARGB(211, 41, 175, 50),
        actions: [
          // ── Currency picker (shared_preferences demo) ────────────────────
          Consumer<ExpensesProvider>(
            builder: (_, provider, __) => PopupMenuButton<String>(
              icon: const Icon(Icons.currency_exchange, color: Colors.white),
              tooltip: 'Change currency',
              onSelected: provider.setCurrency,
              itemBuilder: (_) => const [
                PopupMenuItem(value: '₱', child: Text('₱ PHP')),
                PopupMenuItem(value: '\$', child: Text('\$ USD')),
                PopupMenuItem(value: '€', child: Text('€ EUR')),
              ],
            ),
          ),
          // ── Manual sync button ───────────────────────────────────────────
          Consumer<ExpensesProvider>(
            builder: (_, provider, __) => IconButton(
              icon: const Icon(Icons.sync, color: Colors.white),
              tooltip: 'Sync from API',
              onPressed: provider.isLoading ? null : provider.syncFromApi,
            ),
          ),
        ],
      ),

      body: Consumer<ExpensesProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // ── Error / offline banner ───────────────────────────────────
              if (provider.errorMessage != null)
                MaterialBanner(
                  content: Text(provider.errorMessage!),
                  backgroundColor: Colors.orange.shade100,
                  actions: [
                    TextButton(
                      onPressed: provider.syncFromApi,
                      child: const Text('Retry'),
                    ),
                  ],
                ),

              // ── Last sync info (shared_preferences) ──────────────────────
              if (provider.lastSync != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    'Last synced: ${provider.lastSync}',
                    style:
                        const TextStyle(fontSize: 11, color: Colors.black45),
                  ),
                ),

              // ── Loading indicator ────────────────────────────────────────
              if (provider.isLoading)
                const LinearProgressIndicator(
                  color: Color.fromARGB(211, 41, 175, 50),
                ),

              // ── Expense list (sqflite-backed) ────────────────────────────
              Expanded(
                child: provider.expenses.isEmpty && !provider.isLoading
                    ? const Center(child: Text('No expenses yet.'))
                    : ListView.builder(
                        itemCount: provider.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = provider.expenses[index];

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              leading: CircleAvatar(
                                backgroundColor:
                                    const Color.fromARGB(211, 41, 175, 50),
                                child: const Icon(Icons.attach_money,
                                    color: Colors.white),
                              ),
                              title: Text(
                                expense.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              // ── Currency symbol from shared_preferences ──
                              subtitle: Text(
                                '${provider.currency}${expense.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddExpenseScreen(
                                            expense: expense),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        provider.deleteExpense(expense.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(211, 41, 175, 50),
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddExpenseScreen()),
        ),
      ),
    );
  }
}
