import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import '../models/giao_dich_model.dart';
import '../utils/app_strings.dart';
import '../utils/app_theme.dart';
import '../utils/currency.dart' as currency;
import '../widgets/side_menu.dart';
import 'add_expense_screen.dart';

/// Màn hình lịch sử giao dịch với chức năng sửa/xóa
class TransactionHistoryScreen extends StatefulWidget {
  final String? categoryFilter;
  final String? typeFilter;
  final int? monthFilter;
  final int? yearFilter;

  const TransactionHistoryScreen({
    super.key,
    this.categoryFilter,
    this.typeFilter,
    this.monthFilter,
    this.yearFilter,
  });

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final db = Localstore.instance;
  List<Transaction> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);

    final raw = await db.collection('transactions').get();
    if (raw != null) {
      _transactions = raw.values.map((e) {
        if (e is Map<String, dynamic>) {
          return Transaction.fromMap(e);
        }
        return e as Transaction;
      }).toList();

      // Apply filters
      _transactions = _transactions.where((tx) {
        if (widget.categoryFilter != null &&
            tx.category != widget.categoryFilter) {
          return false;
        }
        if (widget.typeFilter != null && tx.type != widget.typeFilter) {
          return false;
        }
        if (widget.monthFilter != null && tx.date.month != widget.monthFilter) {
          return false;
        }
        if (widget.yearFilter != null && tx.date.year != widget.yearFilter) {
          return false;
        }
        return true;
      }).toList();

      // Sort by date descending
      _transactions.sort((a, b) => b.date.compareTo(a.date));
    }

    setState(() => _isLoading = false);
  }

  Future<void> _deleteTransaction(Transaction tx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.deleteConfirm),
        content: Text(AppStrings.deleteTransactionConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.expense),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (confirm == true) {
      await db.collection('transactions').doc(tx.id).delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.transactionDeleted),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      _loadTransactions();
    }
  }

  Future<void> _editTransaction(Transaction tx) async {
    final result = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(transactionToEdit: tx),
      ),
    );

    if (!mounted) return;
    if (result != null) {
      await db.collection('transactions').doc(result.id).set(result.toMap());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.transactionUpdated),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppSideMenu(),
      appBar: AppBar(
        title: Text(AppStrings.transactionHistory),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.noTransactions,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTransactions,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final tx = _transactions[index];
                      return _TransactionCard(
                        transaction: tx,
                        onEdit: () => _editTransaction(tx),
                        onDelete: () => _deleteTransaction(tx),
                      );
                    },
                  ),
                ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TransactionCard({
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'expense';
    final color = isExpense ? AppColors.expense : AppColors.income;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onEdit,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                  color: color,
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.note.isNotEmpty
                          ? transaction.note
                          : AppStrings.noNote,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Amount & Actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  currency.vndText(
                    transaction.amount,
                    color: color,
                    fontSize: 16,
                    negative: isExpense,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: onEdit,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.edit,
                            size: 20,
                            color: AppColors.accentBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.delete,
                            size: 20,
                            color: AppColors.expense,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
