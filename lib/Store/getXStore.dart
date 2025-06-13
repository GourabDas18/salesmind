
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';


class MainStore extends GetxController{
  Rxn<Isar> db = Rxn<Isar>();
  var username = ''.obs;
  var country = 0.obs;
  RxMap<String,dynamic> authData = <String,dynamic>{}.obs;
  RxString path ='/'.obs;
  RxBool isDarkMode = false.obs;
  RxBool isCollapsed = false.obs;
 Rx<DateRange> dashboardDateRange = DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now()).obs;
  RxBool updateTheApp = false.obs;
}

