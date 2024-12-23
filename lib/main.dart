import 'package:expense_tracking_app/screens/home_screen.dart';
import 'package:expense_tracking_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider<ExpenseProvider>(
      create: (_) => ExpenseProvider(storage: localStorage),
      child: MaterialApp(
        title: 'Student Management App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.0, color: Colors.white),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
          useMaterial3: true,
        ),
        home:
            const HomeScreen(), // Assuming HomeScreen leads to EditStudentScreen
      ),
    );
  }
}
