import 'package:isar/isar.dart';
// part 'party.g.dart';
part 'party_schema.g.dart';

@embedded
class Address {
  String? street;
  String? city;
  String? state;
  String? zipCode;
  String? country;
}

@collection
class Party {
Id id = Isar.autoIncrement;
@Index(unique: true)
late String uuid;
@Index()
late String name;
@Index()
late int group;
@Index()
String? mobile1;
String? mobile2;
@Index()
String? email;
String? gstIn;
String? aadhaar;
String? pan;
String? license;
late Address billingAddress;
late Address shippingAddress;
double flatDiscount = 0.0;  // Optional description
double openingBalance = 0.0;
double outstanding = 0.0;
DateTime createdAt = DateTime.now();
DateTime updateAt = DateTime.now();
}
