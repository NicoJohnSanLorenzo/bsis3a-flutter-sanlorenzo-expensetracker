import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

/// Handles all communication with the remote REST API.
///
/// Replace [baseUrl] with your actual backend URL.
/// This example targets JSONPlaceholder's /todos endpoint as a stand-in;
/// swap with your own API that returns expense-shaped JSON.
class ApiService {
  static const String baseUrl = 'https://192.168.100.70:3000';

  // ── Fetch ──────────────────────────────────────────────────────────────────
  /// GET /expenses — returns a list of expenses from the server.
  Future<List<Expense>> fetchExpenses() async {
    final response = await http.get(Uri.parse('$baseUrl/todos?_limit=5'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Map the placeholder API fields to our Expense model.
      return data.map((json) {
        return Expense(
          id: json['id'].toString(),
          title: json['title'] as String,
          amount: (json['id'] as int) * 10.0, // placeholder amount
        );
      }).toList();
    } else {
      throw Exception('Failed to load expenses (${response.statusCode})');
    }
  }

  // ── Create ─────────────────────────────────────────────────────────────────
  /// POST /expenses — sends a new expense to the server.
  Future<Expense> createExpense(Expense expense) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(expense.toJson()),
    );

    if (response.statusCode == 201) {
      return Expense.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create expense (${response.statusCode})');
    }
  }

  // ── Update ─────────────────────────────────────────────────────────────────
  /// PUT /expenses/:id — updates an existing expense on the server.
  Future<Expense> updateExpense(Expense expense) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/${expense.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(expense.toJson()),
    );

    if (response.statusCode == 200) {
      return Expense.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update expense (${response.statusCode})');
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────
  /// DELETE /expenses/:id — removes an expense from the server.
  Future<void> deleteExpense(String id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/todos/$id'));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete expense (${response.statusCode})');
    }
  }
}
