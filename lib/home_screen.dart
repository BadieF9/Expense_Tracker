import 'package:expense_tracking_app/add_expense_screen.dart';
import 'package:expense_tracking_app/category_management_screen.dart';
import 'package:expense_tracking_app/tag_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        // This is the sidebar
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              // Header of the sidebar
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              // Item in the sidebar
              leading: const Icon(
                Icons.category,
                color: Colors.deepPurple,
              ),
              title: const Text('Manage Categories'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              // Item in the sidebar
              leading: const Icon(Icons.tag, color: Colors.deepPurple),
              title: const Text('Manage Tags'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TagManagementScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.expenses.length,
            itemBuilder: (context, index) {
              final expense = provider.expenses[index];
              return ListTile(
                title: Text('${expense.payee} - \$${expense.amount}'),
                subtitle: Text(
                    'Category: ${expense.categoryId} - Date: ${expense.date.toIso8601String()}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddExpenseScreen(expense: expense),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExpenseScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Expense',
      ),
    );
  }
}
