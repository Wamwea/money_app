class Spending {
  String spendingID;
  double amount;
  SpendingType type;
  String description;
  String? repaymentID;
  DateTime time;

  Spending(
      {required this.spendingID,
      required this.time,
      required this.amount,
      required this.description,
      required this.type,
      this.repaymentID});
}

enum SpendingType { income, expense, loan, repayment }

extension SpendingTypeX on SpendingType {
  String get name {
    switch (this) {
      case SpendingType.income:
        return 'Income';
      case SpendingType.expense:
        return 'Expense';
      case SpendingType.loan:
        return 'Loan';
      case SpendingType.repayment:
        return 'Repayment';
    }
  }
}
