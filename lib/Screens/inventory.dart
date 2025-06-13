import 'package:flutter/material.dart';

import '../ProjectComponent/sidebar.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
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
