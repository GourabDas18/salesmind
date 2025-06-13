import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:salesmind/Helper/DB_controller.dart';
import 'package:salesmind/Helper/utility.dart';
import 'package:salesmind/Screens/Party/AddNewParty/party_creation_form.dart';
import 'package:salesmind/Screens/Party/party.dart';
import 'package:salesmind/Screens/login.dart';
import 'package:salesmind/routes.dart';
import 'package:get/get.dart';
import 'Helper/stateInit.dart';
import 'ProjectComponent/sidebar.dart';
import 'Screens/dashboard.dart';
import 'Screens/expense.dart';
import 'Screens/inventory.dart';
import 'Screens/purchase.dart';
import 'Screens/reports.dart';
import 'Screens/sale.dart';
import 'Store/getXStore.dart';

bool isLoggedIn=false;

  void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initStore();
  Authenticator authenticator = Authenticator();
  isLoggedIn = await authenticator.isLoggedIn(makeLogin: false);
  runApp(const MyApp());
}
void goBack(BuildContext context){
  Navigator.canPop(context) ? Navigator.pop(context) : false;
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Workmind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        fontFamily: 'Barlow',
        textTheme: TextTheme(
            displayLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
            displayMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            displaySmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            headlineLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            headlineMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            headlineSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
            titleLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            titleMedium: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
            titleSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(fontSize: 13.0),
            bodyMedium: TextStyle(fontSize: 12.0),
            bodySmall: TextStyle(fontSize: 11.0),
            labelLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
            labelMedium: TextStyle(fontSize: 11.0),
            labelSmall: TextStyle(fontSize: 10.0),
        )
      ),
        getPages: routes,
        initialRoute: isLoggedIn ? '/': '/login',
        home: isLoggedIn? const MyHomePage() : Login()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MainStore mainStore = Get.find();
  Widget getChildRoute(String path){
    debugPrint(path);
    switch(path){
      case '/':
        return  Dashboard();
      case "/party":
        return Party();
      case "/inventory":
        return Inventory();
      case "/sale":
        return  Sale();
      case "/purchase":
        return Purchase();
      case "/expense":
        return Expense();
      case "/reports":
        return Reports();
      default:
        return Dashboard();
    }

  }

  int getChildIndex(String path){
    switch(path){
      case '/':
        return 0;
      case "/party":
        return 1;
        case "/inventory":
        return 2;
      case "/sale":
        return 3;
      case "/purchase":
        return 4;
      case "/expense":
        return 5;
      case "/reports":
        return 6;
      default:
        return 0;
    }
  }

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Scaffold(
        body: Row(
          children: [
            Sidebar(index: getChildIndex(mainStore.path.value)),
            Expanded(child: getChildRoute(mainStore.path.value))
          ],
        ),
      ),
    );
  }
}
