class Expense {
  String id;
  String title;
  double amount;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
  });

  // ── sqflite ────────────────────────────────────────────────────────────────
  /// Convert an Expense into a Map for inserting/updating in SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
    };
  }

  /// Reconstruct an Expense from a SQLite row.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
    );
  }

  // ── REST API ───────────────────────────────────────────────────────────────
  /// Convert an Expense into JSON for sending to the API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
    };
  }

  /// Reconstruct an Expense from an API JSON response.
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'].toString(),
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
