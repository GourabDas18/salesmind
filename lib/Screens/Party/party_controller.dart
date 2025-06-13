import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:salesmind/Helper/DB_controller.dart';
import 'package:salesmind/Helper/helper.dart';
import 'package:salesmind/Schema/ledger_group.dart';
import 'package:salesmind/Schema/party_schema.dart';
import 'package:salesmind/Store/getXStore.dart';
import 'package:salesmind/Store/party_store.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

Future<void> saveParty({required bool isNew,required BuildContext context})async{
  try {
    PartyStore partyStore = Get.find();
    MainStore mainStore = Get.find();
    final Isar db = await DB().getDB();
    Address billingAddress = Address()
    ..street = partyStore.billingStreet.value.text
    ..city = partyStore.billingCity.value.text
    ..state = partyStore.billingState.value.text
    ..zipCode = partyStore.billingPincode.value.text;

    Address shippingAddress = Address()
      ..street = partyStore.shippingStreet.value.text
      ..city = partyStore.shippingCity.value.text
      ..state = partyStore.shippingState.value.text
      ..zipCode = partyStore.shippingPincode.value.text;

    if(isNew) {
      Party party = Party()
        ..name = partyStore.name.value.text
        ..uuid = Uuid().v4()
        ..group = 1
        ..mobile1 = partyStore.mobile1.value.text
        ..mobile2 = partyStore.mobile2.value.text
        ..email = partyStore.email.value.text
        ..openingBalance = partyStore.openingBalance.value
        ..billingAddress = billingAddress
        ..shippingAddress = shippingAddress
        ..gstIn = partyStore.gstIn.value
        ..aadhaar = partyStore.aadhar.value
        ..pan = partyStore.pan.value
        ..license = partyStore.license.value
        ..flatDiscount = partyStore.flatDiscount.value;

      await db.writeTxn(() async {
        await db.partys.put(party);
      });
      await getPartyList(context: context);
      partyStore.resetForm();
      if(context.mounted){
      showAlert("Successfull", AlertType.success, context);
      }
    }
  }
  catch(e){
    showAlert("$e", AlertType.error, context);
  }
}

Future<void> getPartyList({required BuildContext context})async{
  try {
    PartyStore partyStore = Get.find();
    final Isar db = await DB().getDB();
    final List<Party> parties = await db.partys.where().findAll();
    partyStore.partyList.value = parties;
  }
  catch(e){
    if(context.mounted){
    showAlert("$e", AlertType.error, context);
    }
  }
}