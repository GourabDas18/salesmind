import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:salesmind/Schema/party_schema.dart';
class PartyStore extends GetxController{

  RxBool addingNewParty = false.obs;
  RxList<String> hoveredParty = <String>[].obs;
  // Register
  RxList<Party> partyList = <Party>[].obs;



  // FORM
  RxString uuid=''.obs;
  Rx<TextEditingController> name=TextEditingController().obs;
  RxMap<String,dynamic> partyGroup= <String,dynamic>{}.obs;
  Rx<TextEditingController> mobile1 =TextEditingController().obs;
  Rx<TextEditingController> mobile2 =TextEditingController().obs;
  Rx<TextEditingController> email =TextEditingController().obs;
  RxDouble openingBalance=(0.0).obs;
  Rx<TextEditingController> billingStreet = TextEditingController().obs;
  Rx<TextEditingController> billingCity = TextEditingController().obs;
  Rx<TextEditingController> billingState = TextEditingController().obs;
  Rx<TextEditingController> billingPincode = TextEditingController().obs;
  Rx<TextEditingController> shippingStreet = TextEditingController().obs;
  Rx<TextEditingController> shippingCity = TextEditingController().obs;
  Rx<TextEditingController> shippingState = TextEditingController().obs;
  Rx<TextEditingController> shippingPincode = TextEditingController().obs;
  RxString gstIn=''.obs;
  RxString aadhar=''.obs;
  RxString pan=''.obs;
  RxString license=''.obs;
  RxDouble flatDiscount = (0.0).obs;
  RxBool sameShippingAddress = true.obs;
  void setForm(Party party){
    name.value.text = party.name;
    uuid.value = party.uuid;
    // partyGroup.value = party.group;
    mobile1.value.text = party.mobile1.toString();
    mobile2.value.text = party.mobile1.toString();
    email.value.text = party.email ?? '';
    openingBalance.value = party.outstanding;
    billingStreet.value.text = party.billingAddress.street??'';
    billingCity.value.text = party.billingAddress.city??'';
    billingState.value.text = party.billingAddress.state??'';
    billingPincode.value.text =  party.billingAddress.zipCode??'';
    shippingStreet.value.text = party.shippingAddress.street??'';
    shippingCity.value.text = party.shippingAddress.city??'';
    shippingState.value.text = party.shippingAddress.state??'';
    shippingPincode.value.text = party.shippingAddress.zipCode??'';
    gstIn.value= party.gstIn??'';
    aadhar.value=party.aadhaar??'';
    pan.value=party.pan??'';
    license.value=party.license??'';
    flatDiscount.value = party.flatDiscount;
    sameShippingAddress = false.obs;
  }
  void resetForm(){
     uuid.value='';
     name.value.text='';
     partyGroup.value = {};
     mobile1.value.text ='';
     mobile2.value.text ='';
     email.value.text ='';
     openingBalance.value=0.0;
     billingStreet.value.text = '';
     billingCity.value.text = '';
     billingState.value.text = '';
     billingPincode.value.text = '';
     shippingStreet.value.text = '';
     shippingCity.value.text = '';
     shippingState.value.text = '';
     shippingPincode.value.text = '';
     gstIn.value='';
     aadhar.value='';
     pan.value='';
     license.value='';
     flatDiscount.value = 0.0;
     sameShippingAddress.value = false;
  }
}