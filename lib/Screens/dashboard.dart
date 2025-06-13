import 'package:flutter/material.dart';
import 'package:salesmind/Screens/expense.dart';
import 'package:salesmind/Screens/purchase.dart';
import 'package:salesmind/Screens/reports.dart';
import 'package:salesmind/Screens/sale.dart';
import 'package:salesmind/Store/getXStore.dart';
import '../ProjectComponent/sidebar.dart';
import 'package:get/get.dart';

import 'inventory.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container()
    );
  }
}
