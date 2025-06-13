import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';
import 'package:salesmind/Helper/helper.dart';
import 'package:salesmind/Helper/utility.dart';
import 'package:salesmind/Schema/party_schema.dart';
import 'package:salesmind/Screens/Party/AddNewParty/party_additional.dart';
import 'package:salesmind/Screens/Party/AddNewParty/party_attendance.dart';
import 'package:salesmind/Screens/Party/party_controller.dart';
import 'package:salesmind/Screens/Party/AddNewParty/party_discount.dart';
import 'package:salesmind/Store/party_store.dart';
import 'package:get/get.dart';
class PartyCreation extends StatefulWidget{
  const PartyCreation({super.key});
  @override
  State<PartyCreation> createState() => _PartyState();
}

class _PartyState extends State<PartyCreation> with SingleTickerProviderStateMixin{

  late TabController tabController;
  PartyStore partyStore = Get.find();
  AppLoaderController appLoaderController = AppLoaderController();

  void addPartyData(String uuid){
    try{
      Party party = partyStore.partyList.firstWhere((t)=>t.uuid==uuid);
      partyStore.setForm(party);
    }catch(e){
      showAlert("Error in party!", AlertType.error, context);
    }
  }


  @override
  void initState() {
   setState(() {
     tabController = TabController(length: 3, vsync: this);
   });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLoader(
      controller: appLoaderController,
      child: Obx(
          ()=> Scaffold(
          body: Row(
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.sizeOf(context).height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: partyStore.uuid.value==''? Color(0xFFE9E9EA) : Color(
                              0xff989898)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextHelper(text: partyStore.uuid.value==''?  "Add New Party" :  "Update Party ( ${partyStore.name.value.text} )",width: 550,
                              fontsize: 16,
                              fontweight: FontWeight.w600,
                              color: partyStore.uuid.value!=''? Color(
                                  0xff1d1d26) : Colors.black,
                            ),
                            // Row(
                            //   spacing: 20,
                            //   mainAxisSize: MainAxisSize.min,
                            //   children: [
                            //   ButtonG(
                            //     label: TextHelper(text: "New Sale",color: Colors.white,fontsize: 12),
                            //     leading: Icon(MoonIcons.controls_chevron_right_small_24_light,size: 16,),
                            //     width: 130,
                            //     height: 37,
                            //     backgroundColor: Color(0xFF222334),
                            //   ),
                            //     ButtonG(
                            //       label: TextHelper(text: "New Item",color: Colors.white,fontsize: 12),
                            //       leading: Icon(MoonIcons.controls_chevron_right_small_24_light,size: 16,),
                            //       width: 130,
                            //       height: 37,
                            //       backgroundColor: Color(0xFF9F411F),
                            //     ),
                            //     ButtonG(
                            //       label: TextHelper(text: "New Expense",color: Colors.white,fontsize: 12),
                            //       leading: Icon(MoonIcons.controls_chevron_right_small_24_light,size: 16,),
                            //       height: 37,
                            //       width: 130,
                            //       backgroundColor: Color(0xFF8C7C14),
                            //     )
                            // ],)
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        height: MediaQuery.sizeOf(context).height*0.94,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 20,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 30,
                              runSpacing: 20,
                              children: [
                                Row(
                                  spacing: 6,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(MoonIcons.generic_user_32_regular),
                                    TextBoxHelperG(
                                      controller: partyStore.name.value,
                                      width: 360,
                                      labelText: 'Name',
                                      showAlwaysLabel: false,
                                    )
                                  ],
                                ),
                                Row(
                                  spacing: 6,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(MoonIcons.generic_users_32_regular),
                                    DropDownHelperG(
                                      uniqueKey: "PartyGroupSelect",
                                      isSearchEnable: true,
                                      items:[
                                        {'id':1,'name':'Sundry Debitors'},
                                        {'id':2,'name':'Sundry Creditors'},
                                      ],
                                      leading: Container(),
                                      height: 35,
                                      width: 360,
                                    )
                                  ],
                                )
                              ],
                            ),
                            Wrap(
                              spacing: 30,
                              runSpacing: 20,
                              children: [
                                Row(
                                  spacing: 6,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(MoonIcons.devices_phone_32_regular),
                                    TextBoxHelperG(
                                      controller: partyStore.mobile1.value,
                                      width: 150,
                                      keyboard: TextInputType.number,
                                      labelText: 'Phone 1',
                                      showAlwaysLabel: false,
                                    )
                                  ],
                                ),
                                Row(
                                  spacing: 6,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(MoonIcons.devices_phone_32_regular),
                                    TextBoxHelperG(
                                      controller: partyStore.mobile2.value,
                                      width: 150,
                                      keyboard: TextInputType.number,
                                      labelText: 'Phone 2',
                                      showAlwaysLabel: false,
                                    )
                                  ],
                                ),
                                Row(
                                  spacing: 6,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(MoonIcons.mail_email_stats_32_regular),
                                    TextBoxHelperG(
                                      controller: partyStore.email.value,
                                      width:360,
                                      labelText: 'Email Id',
                                      showAlwaysLabel: false,
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 30,
                              children: [
                                Row(
                                  spacing: 6,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(MoonIcons.shop_wallet_alternative_32_regular),
                                    TextBoxHelperG(
                                      onValueChange: (v){
                                        partyStore.openingBalance.value=parseDouble(data: v, defaultValue: 0.0);
                                      },
                                      controller: TextEditingController(text: partyStore.openingBalance.toString()),
                                      width: 360,
                                      keyboard: TextInputType.number,
                                      selectTextOnFocus: true,
                                      labelText: 'Opening Balance',
                                      showAlwaysLabel: false,
                                    )
                                  ],
                                ),

                              ],
                            ),
                            MoonTabBar(
                              tabController: tabController,
                              tabs: [
                                MoonTab(label: TextHelper(text: "Address")),
                                MoonTab(label: TextHelper(text: "Additional")),
                                MoonTab(label: TextHelper(text: "Discounts %  ")),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    PartyAttendance(),
                                    PartyAdditional(),
                                    PartyDiscount(),
                                  ]
                              ),
                            ),
                            Row(
                              spacing: 20,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ButtonG(label: TextHelper(text:"Save"),
                                    leading: Icon(MoonIcons.files_save_32_regular,color: Colors.black),
                                    width: 150,
                                    onTap: ()async{
                                      try{
                                        appLoaderController.loading.value=true;
                                        saveParty(isNew: true, context: context).whenComplete((){
                                          appLoaderController.loading.value=false;
                                        });
                                      }catch(e){
                                        appLoaderController.loading.value=false;
                                      }
                                    },
                                    backgroundColor: Colors.blue.shade300),
                                ButtonG(
                                  onTap: (){
                                    partyStore.resetForm();
                                  },
                                  label: TextHelper(text:"Reset"),leading: Icon(MoonIcons.arrows_refresh_32_regular,color: Colors.black,),width: 150,backgroundColor: Colors.grey.shade300,),
                                ButtonG(
                                  onTap: (){
                                    partyStore.addingNewParty.value=false;
                                  },
                                  label: TextHelper(text:"Close"),leading: Icon(MoonIcons.controls_close_32_regular,color: Colors.black,size: 16,),width: 150,backgroundColor: Colors.blueGrey.shade200,),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height,
                width: 300,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50
                ),
                child: Column(
                  children: [
                    !partyStore.addingNewParty.value ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextHelper(text: "Update the party from below",
                              isWrap: true,fontsize: 15,
                              fontweight: FontWeight.w600,

                            ),
                          ],
                        ) :
                    ButtonG(
                      label: TextHelper(text: "+ Add Party",fontweight: FontWeight.w600,fontsize: 12,),
                      width: 200,
                      height: 35,
                      backgroundColor: Colors.yellow.shade700,
                    ),
                    Divider(),
                    TextBoxHelperG(onValueChange: (v){},
                    leading: Icon(MoonIcons.generic_search_32_regular),
                      placeholder: 'Search..',
                    ),
                    Expanded(child: ListView.builder(
                        itemCount: partyStore.partyList.value.length,
                        itemBuilder: (BuildContext con, int index)=>
                    GestureDetector(
                      onTap: (){
                        addPartyData(partyStore.partyList.value[index].uuid);
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onEnter: (v){
                          partyStore.hoveredParty.add(partyStore.partyList.value[index].uuid);
                          partyStore.hoveredParty.refresh();
                        },
                        onExit: (v){
                          partyStore.hoveredParty.remove(partyStore.partyList.value[index].uuid);
                          partyStore.hoveredParty.refresh();
                        },
                        child: StreamBuilder(
                          stream: partyStore.hoveredParty.stream,
                          builder: (context, snapshot) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeIn,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical:10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blueGrey.shade100
                                ),
                                color: partyStore.hoveredParty.any((t)=>t==partyStore.partyList[index].uuid)? Colors.amber.shade100 : Colors.blueGrey.shade100,
                                borderRadius: BorderRadius.circular(8)
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    spacing: 5,
                                    children: [
                                      Icon(MoonIcons.generic_user_24_regular,size: 20,),
                                      TextHelper(text: partyStore.partyList.value[index].name,fontweight: FontWeight.w500,
                                      fontsize: 14,
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.blueGrey,),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        Icon(MoonIcons.devices_phone_32_regular,size: 16,),
                                        TextHelper(text: parseString(data: partyStore.partyList.value[index].mobile1, defaultValue: '--'),fontweight: FontWeight.w500,
                                          fontsize: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      spacing: 5,
                                      children: [
                                        Icon(MoonIcons.travel_hotel_32_regular,size: 16,),
                                        Expanded(
                                          child: TextHelper(text:
                                          "${parseString(data: partyStore.partyList.value[index].billingAddress.street, defaultValue: '--')} "
                                              "${parseString(data: partyStore.partyList.value[index].billingAddress.city, defaultValue: '--')}"
                                              " ${parseString(data: partyStore.partyList.value[index].billingAddress.zipCode, defaultValue: '--')}"
                                            ,fontweight: FontWeight.w500,
                                            fontsize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                      ),
                    )
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}