import 'package:flutter/material.dart';

import '../ProjectComponent/sidebar.dart';

class Purchase extends StatefulWidget {
  const Purchase({super.key});

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
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
