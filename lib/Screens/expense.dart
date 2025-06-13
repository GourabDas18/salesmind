import 'package:flutter/material.dart';

import '../ProjectComponent/sidebar.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(index: 0),
          Container()
        ],
      ),
    );
  }
}
