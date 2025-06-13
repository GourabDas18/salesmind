import 'package:flutter/material.dart';

import '../ProjectComponent/sidebar.dart';

class Sale extends StatefulWidget {
  const Sale({super.key});

  @override
  State<Sale> createState() => _SaleState();
}

class _SaleState extends State<Sale> {
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
