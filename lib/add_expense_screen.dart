// import 'package:expense_tracking_app/widgets/contained_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/expense.dart';
import '/providers/expense_provider.dart';
import 'package:intl/intl.dart'; // Make sure to import intl package

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _payeeController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDate;
  bool isEditForm = false;
  String? _selectedCategoryId;
  String? _selectedTagId;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      isEditForm = true;
      _amountController =
          TextEditingController(text: widget.expense?.amount.toString());
      _selectedCategoryId = widget.expense?.categoryId;
      _payeeController = TextEditingController(text: widget.expense?.payee);
      _noteController = TextEditingController(text: widget.expense?.note);
      _selectedDate = widget.expense!.date;
      _selectedTagId = widget.expense?.tag;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(), // Start with current date
      firstDate: DateTime(1900), // Earliest allowed date
      lastDate: DateTime(2100), // Latest allowed date
      helpText: 'Select expense date', // Customize the help text
      cancelText: 'Not now',
      confirmText: 'Select',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense',
            style: TextStyle(
              color: Colors.black,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _payeeController,
                  decoration: const InputDecoration(
                    labelText: 'Payee',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'Not Selected'}'),
                      IconButton(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_today)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategoryId = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "Category", border: OutlineInputBorder()),
                  icon: const SizedBox.shrink(),
                  items: Provider.of<ExpenseProvider>(context, listen: false)
                      .categories
                      .map((e) =>
                          DropdownMenuItem(value: e.id, child: Text(e.name)))
                      .toList(),
                  value: _selectedCategoryId,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  onChanged: (newValue) {
                    setState(() {
                      _selectedTagId = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: "Tag", border: OutlineInputBorder()),
                  icon: const SizedBox.shrink(),
                  items: Provider.of<ExpenseProvider>(context, listen: false)
                      .tags
                      .map((e) =>
                          DropdownMenuItem(value: e.id, child: Text(e.name)))
                      .toList(),
                  value: _selectedTagId,
                ),
                const SizedBox(height: 20),
              ],
            ),
            ElevatedButton(
              onPressed: () => _saveExpense(context, widget.expense?.id),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense(BuildContext context, String? id) {
    final expense = Expense(
      id: id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      amount: double.parse(_amountController.text),
      categoryId: _selectedCategoryId!,
      payee: _payeeController.text,
      note: _noteController.text,
      date: _selectedDate!,
      tag: _selectedTagId!,
    );

    Provider.of<ExpenseProvider>(context, listen: false)
        .addOrUpdateExpense(expense);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _payeeController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
