import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesmind/Schema/ledger_group.dart';
import 'package:salesmind/Schema/party_schema.dart';
import 'package:salesmind/Store/getXStore.dart';
import 'package:get/get.dart';
class DB{
  final MainStore mainStore = Get.find();
  late Isar isar;

  Future<void> initIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        PartySchema,
        PartyGroupSchema
      ],
      directory: dir.path,
      inspector: true, // optional: to use Isar Inspector in browser
    );
  }

  Future<Isar> getDB()async{
    if(mainStore.db.value!=null){
      return mainStore.db.value!;
    }
    await initIsar();
    return isar;
  }

}