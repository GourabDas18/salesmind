import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_icons/moon_icons.dart';
import 'package:salesmind/Helper/helper.dart';
import 'package:salesmind/Store/party_store.dart';


class PartyAdditional extends StatefulWidget {
  const   PartyAdditional({super.key});

  @override
  State<PartyAdditional> createState() => _PartyAdditionalState();
}

class _PartyAdditionalState extends State<PartyAdditional> {
  PartyStore partyStore = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=> SingleChildScrollView(
          child:  Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(),
            Row(
              spacing: 8,
              children: [
                Icon(MoonIcons.files_text_32_regular),
                TextBoxHelperG(
                  onValueChange: (v){
                    partyStore.gstIn.value = v;
                  },
                  controller: TextEditingController(text: partyStore.gstIn.value),
                  leading: TextHelper(text: 'GSTIN',color: Colors.blueGrey.shade800,fontweight: FontWeight.w700,width: 110,),
                  width: MediaQuery.sizeOf(context).width*0.45,
                )
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Icon(MoonIcons.files_text_32_regular),
                TextBoxHelperG(
                  onValueChange: (v){
                    partyStore.aadhar.value = v;
                  },
                  controller: TextEditingController(text: partyStore.aadhar.value),
                  leading: TextHelper(text: 'Aadhar number',color: Colors.blueGrey.shade800,fontweight: FontWeight.w700,width: 110,),
                  width: MediaQuery.sizeOf(context).width*0.45,
                )
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Icon(MoonIcons.files_text_32_regular),
                TextBoxHelperG(
                  onValueChange: (v){
                    partyStore.pan.value = v;
                  },
                  controller: TextEditingController(text: partyStore.pan.value),
                  leading: TextHelper(text: 'PAN',color: Colors.blueGrey.shade800,fontweight: FontWeight.w700,width: 110,),
                  width: MediaQuery.sizeOf(context).width*0.45,
                )
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Icon(MoonIcons.files_text_32_regular),
                TextBoxHelperG(
                  controller: TextEditingController(text: partyStore.license.value),
                  onValueChange: (v){
                    partyStore.license.value = v;
                  },
                  leading: TextHelper(text: 'License number',color: Colors.blueGrey.shade800,fontweight: FontWeight.w700,width: 110,),
                  width: MediaQuery.sizeOf(context).width*0.45,
                )
              ],
            )
            ]
        )
      ),
    );
  }
}
