import 'package:flutter/material.dart';
import 'package:salesmind/Helper/helper.dart';
import 'package:moon_icons/moon_icons.dart';
import 'package:moon_design/moon_design.dart';
import 'package:salesmind/Schema/party_schema.dart';
import 'package:salesmind/Store/party_store.dart';
import 'package:get/get.dart';
class PartyAttendance extends StatelessWidget {
  PartyAttendance({super.key});
  PartyStore partyStore = Get.find();

  void makeSameShipingAddress(){
    partyStore.shippingPincode.value.text = partyStore.billingPincode.value.text;
    partyStore.shippingCity.value.text = partyStore.billingCity.value.text;
    partyStore.shippingState.value.text = partyStore.billingState.value.text;
    partyStore.shippingPincode.value.text = partyStore.billingPincode.value.text;
    partyStore.shippingStreet.value.text = partyStore.billingStreet.value.text;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> SingleChildScrollView(
        child:  Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(MoonIcons.travel_bill_32_regular),
                    TextHelper(text: "Billing Address",color: Colors.blueGrey.shade800,fontweight: FontWeight.w700,)
                  ],
                ),
                Row(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MoonSwitch(value: partyStore.sameShippingAddress.value,
                      onChanged: (v){
                        partyStore.sameShippingAddress.value = !partyStore.sameShippingAddress.value;
                      },
                      switchSize: MoonSwitchSize.x2s,activeTrackColor: Colors.blue.shade100,thumbColor: Colors.blue.shade900,),
                    TextHelper(text: "Same Shipping Address")
                  ],
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MoonIcons.generic_user_32_regular),
                      TextBoxHelperG(
                        onValueChange: (v){
                          if(partyStore.sameShippingAddress.value){
                            makeSameShipingAddress();
                          }
                        },
                        controller: partyStore.billingStreet.value,
                        width: MediaQuery.sizeOf(context).width*0.5,
                        height: 40,
                        labelText: 'Street',
                        showAlwaysLabel: false,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MoonIcons.travel_hotel_32_regular,weight: 100,),
                      TextBoxHelperG(
                        onValueChange: (v){
                          if(partyStore.sameShippingAddress.value){
                            makeSameShipingAddress();
                          }
                        },
                        controller: partyStore.billingCity.value,
                        width: 260,
                        height: 40,
                        labelText: 'City',
                        showAlwaysLabel: false,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Row(
                        spacing: 6,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MoonIcons.maps_map_32_regular,weight: 100,),
                          TextBoxHelperG(
                            onValueChange: (v){
                              if(partyStore.sameShippingAddress.value){
                                makeSameShipingAddress();
                              }
                            },
                            controller: partyStore.billingState.value,
                            width: 260,
                            height: 40,
                            labelText: 'State',
                            showAlwaysLabel: false,
                          ),
                        ],
                      ),
                      Row(
                        spacing: 6,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MoonIcons.maps_marker_32_regular,weight: 100,),
                          TextBoxHelperG(
                            onValueChange: (v){
                              if(partyStore.sameShippingAddress.value){
                                makeSameShipingAddress();
                              }
                            },
                            controller: partyStore.billingPincode.value,
                            width: 260,
                            keyboard: TextInputType.number,
                            height: 40,
                            labelText: 'Pincode',
                            showAlwaysLabel: false,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 1,),
            Row(
              children: [
                Icon(MoonIcons.maps_location_32_regular,color: Colors.blueGrey.shade800,weight: 700,),
                TextHelper(text: "Shipping Address",color: Colors.blueGrey.shade800,fontweight: FontWeight.w700,),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MoonIcons.generic_user_32_regular),
                      TextBoxHelperG(
                        controller: partyStore.shippingStreet.value,
                        width: MediaQuery.sizeOf(context).width*0.5,
                        height: 40,
                        labelText: 'Street',
                        showAlwaysLabel: false,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(MoonIcons.travel_hotel_32_regular,weight: 100,),
                      TextBoxHelperG(
                        controller: partyStore.shippingCity.value,
                        width: 260,
                        height: 40,
                        labelText: 'City',
                        showAlwaysLabel: false,
                      ),
                    ],
                  ),
                  Row(
                    spacing: 20,
                    children: [
                      Row(
                        spacing: 6,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MoonIcons.maps_map_32_regular,weight: 100,),
                          TextBoxHelperG(
                            controller: partyStore.shippingState.value,
                            width: 260,
                            height: 40,
                            labelText: 'State',
                            showAlwaysLabel: false,
                          ),
                        ],
                      ),
                      Row(
                        spacing: 6,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(MoonIcons.maps_marker_32_regular,weight: 100,),
                          TextBoxHelperG(
                            controller: partyStore.shippingPincode.value,
                            width: 260,
                            height: 40,
                            labelText: 'Pincode',
                            showAlwaysLabel: false,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
