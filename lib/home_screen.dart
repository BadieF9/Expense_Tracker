import 'package:expense_tracking_app/add_expense_screen.dart';
import 'package:expense_tracking_app/category_management_screen.dart';
import 'package:expense_tracking_app/models/expense.dart';
import 'package:expense_tracking_app/tag_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> _tabs = [
    const Tab(text: 'By Date'),
    const Tab(text: 'By Category')
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
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
          List<Expense> expensesByCategory = List.from(provider.expenses);
          expensesByCategory.sort((a, b) => provider
              .getCategoryById(a.categoryId)!
              .name
              .compareTo(provider.getCategoryById(b.categoryId)!.name));

          List<Expense> expenseByDate = List.from(provider.expenses);
          expenseByDate.sort((a, b) => a.date.compareTo(b.date));

          return TabBarView(controller: _tabController, children: [
            ListView.builder(
              itemCount: expenseByDate.length,
              itemBuilder: (context, index) {
                final expense = expenseByDate[index];
                return ListTile(
                  title: Text('${expense.payee} - \$${expense.amount}'),
                  subtitle: Text(
                      'Category: ${provider.getCategoryById(expense.categoryId)?.name} - Date: ${expense.date.toIso8601String()}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddExpenseScreen(expense: expense),
                      ),
                    );
                  },
                );
              },
            ),
            ListView.builder(
              itemCount: expensesByCategory.length,
              itemBuilder: (context, index) {
                final expense = expensesByCategory[index];
                return ListTile(
                  title: Text('${expense.payee} - \$${expense.amount}'),
                  subtitle: Text(
                      'Category: ${provider.getCategoryById(expense.categoryId)?.name} - Date: ${expense.date.toIso8601String()}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddExpenseScreen(expense: expense),
                      ),
                    );
                  },
                );
              },
            )
          ]);
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
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}
