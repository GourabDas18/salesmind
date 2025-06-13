import 'package:isar/isar.dart';
part 'ledger_group.g.dart';
// flutter pub run build_runner build --delete-conflicting-outputs

@collection
class PartyGroup {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String uuid;
  @Index(unique: true)
  late String name;         // e.g. 'Retailers'
  String? description;      // Optional description
  DateTime createdAt = DateTime.now();
  DateTime updateAt = DateTime.now();
}
