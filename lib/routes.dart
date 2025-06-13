import 'package:get/get.dart';
import 'package:salesmind/Screens/login.dart';
import 'package:salesmind/main.dart';
import 'Screens/dashboard.dart';
import 'Screens/Party/AddNewParty/party_creation_form.dart';
import 'Screens/inventory.dart';
import 'Screens/sale.dart';
import 'Screens/purchase.dart';
import 'Screens/expense.dart';
import 'Screens/reports.dart';

List<GetPage> routes = [
  GetPage(name: '/', page: ()=>MyHomePage()),
  GetPage(name: '/login', page: ()=>Login()),
];