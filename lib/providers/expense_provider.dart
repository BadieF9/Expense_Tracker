import 'package:expense_tracking_app/models/category.dart';
import 'package:expense_tracking_app/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  final LocalStorage storage;
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;
  List<Category> _categories = [];
  List<Category> get categories => _categories;
  List<Tag> _tags = [];
  List<Tag> get tags => _tags;
  ExpenseProvider({required this.storage}) {
    _loadTagsFromStorage();
    _loadCategoriesFromStorage();
    _loadExpensesFromStorage();
  }

  void _loadExpensesFromStorage() async {
    var storedExpenses = storage.getItem('expenses');
    if (storedExpenses != null) {
      _expenses = List<Expense>.from(
        (storedExpenses as List).map((item) => Expense.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void _saveExpensesToStorage() {
    storage.setItem(
        'expenses', _expenses.map((e) => e.toJson()).toList().toString());
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void addOrUpdateExpense(Expense expense) {
    int index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    } else {
      _expenses.add(expense);
    }
    _saveExpensesToStorage();
    notifyListeners();
  }

  void removeExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    _saveExpensesToStorage();
    notifyListeners();
  }

  void _loadCategoriesFromStorage() async {
    var storedCategories = storage.getItem('categories');
    if (storedCategories != null) {
      _categories = List<Category>.from(
        (storedCategories as List).map((item) => Category.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void _saveCategoriesToStorage() {
    storage.setItem(
        'categories', _categories.map((e) => e.toJson()).toList().toString());
  }

  Category? getCategoryById(String id) {
    return _categories.firstWhere((category) => category.id == id);
  }

  void addCategory(Category category) {
    _categories.add(category);
    _saveCategoriesToStorage();
    notifyListeners();
  }

  void addOrUpdateCategory(Category category) {
    int index = _categories.indexWhere((e) => e.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    } else {
      _categories.add(category);
    }
    _saveCategoriesToStorage();
    notifyListeners();
  }

  void removeCategory(String id) {
    _categories.removeWhere((category) => category.id == id);
    _saveCategoriesToStorage();
    notifyListeners();
  }

  void _loadTagsFromStorage() async {
    var storedTags = storage.getItem('tags');
    if (storedTags != null) {
      _tags = List<Tag>.from(
        (storedTags as List).map((item) => Tag.fromJson(item)),
      );
      notifyListeners();
    }
  }

  void _saveTagsToStorage() {
    storage.setItem('tags', _tags.map((e) => e.toJson()).toList().toString());
  }

  void addTag(Tag tag) {
    _tags.add(tag);
    _saveTagsToStorage();
    notifyListeners();
  }

  void addOrUpdateTag(Tag tag) {
    int index = _tags.indexWhere((e) => e.id == tag.id);
    if (index != -1) {
      _tags[index] = tag;
    } else {
      _tags.add(tag);
    }
    _saveTagsToStorage();
    notifyListeners();
  }

  void removeTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
    _saveTagsToStorage();
    notifyListeners();
  }
}
