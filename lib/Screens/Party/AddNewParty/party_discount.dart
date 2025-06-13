import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_icons/moon_icons.dart';
import 'package:salesmind/Store/party_store.dart';

import '../../../Helper/helper.dart';

class PartyDiscount extends StatefulWidget {
  const PartyDiscount({super.key});

  @override
  State<PartyDiscount> createState() => _PartyDiscountState();
}

class _PartyDiscountState extends State<PartyDiscount> {
  PartyStore partyStore = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> SingleChildScrollView(
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(),
            Row(
              spacing: 8,
              children: [
                Icon(MoonIcons.files_text_32_regular),
                TextBoxHelperG(
                  onValueChange: (v) {
                    partyStore.flatDiscount.value = parseDouble(data: v, defaultValue: 0.0);
                  },
                  controller: TextEditingController(text: partyStore.flatDiscount.toString()),
                  keyboard: TextInputType.number,
                  leading: TextHelper(
                    text: 'Flat Discount',
                    color: Colors.blueGrey.shade800,
                    fontweight: FontWeight.w700,
                    width: 110,
                  ),
                  trailing: TextHelper(text: "%",color: Colors.blueGrey.shade800,
                    fontweight: FontWeight.w700,),
                  width: 300,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
