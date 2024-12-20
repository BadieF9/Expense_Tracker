import 'package:expense_tracking_app/add_expense_screen.dart';
import 'package:expense_tracking_app/category_management_screen.dart';
import 'package:expense_tracking_app/models/expense.dart';
import 'package:expense_tracking_app/tag_management_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
                    builder: (context) => const CategoryManagementScreen(),
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
                    builder: (context) => const TagManagementScreen(),
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
                  title: Text(
                    '${expense.payee} - \$${expense.amount}',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                  subtitle: Text(
                      'Category: ${provider.getCategoryById(expense.categoryId)?.name} - Date: ${DateFormat('MMM dd, yyyy').format(expense.date)}'),
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
                  title: Text(
                    '${provider.getCategoryById(expense.categoryId)?.name} - Total: \$${expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 20, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.paid,
                            color: theme.colorScheme.primary,
                            size: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${expense.payee} - \$${expense.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  DateFormat('MMM dd, yyyy')
                                      .format(expense.date),
                                  style: TextStyle(
                                      color: theme.colorScheme.secondary,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
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
