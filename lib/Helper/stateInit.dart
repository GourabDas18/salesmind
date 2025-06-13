import 'package:get/get.dart';
import 'package:salesmind/Store/party_store.dart';
import '../Store/getXStore.dart';
import 'DB_controller.dart';

initStore() async {
 final MainStore mainStore = Get.put(MainStore());
 mainStore.db.value = await DB().getDB();
 Get.lazyPut<PartyStore>(()=>PartyStore(),fenix: true);
}
