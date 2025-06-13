import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_icons/moon_icons.dart';
import 'package:moon_design/moon_design.dart';
import 'package:salesmind/Components/Datagrid2.dart';
import 'package:salesmind/Helper/helper.dart';
import 'package:salesmind/Screens/Party/AddNewParty/party_creation_form.dart';
import 'package:salesmind/Screens/Party/party_controller.dart';
import 'package:salesmind/Store/party_store.dart';
import 'package:salesmind/Schema/party_schema.dart' as schema;

class Party extends StatefulWidget {
  const Party({super.key});

  @override
  State<Party> createState() => _PartyState();
}

class _PartyState extends State<Party> {
  PartyStore partyStore = Get.find();
  void fetchPartyList()async{
    await getPartyList(context: context);
  }
  Map<String,dynamic> getPartyInMap(schema.Party party ){
    return {
      'name':party.name,
      'outstanding':party.outstanding,
      'mobile':party.mobile1,
      'address':"${party.billingAddress.street} ${party.billingAddress.city}"
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPartyList();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=> Scaffold(
        body:
        partyStore.addingNewParty.value ?
            PartyCreation()
         : SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 60,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.blueGrey.shade50)),
                    color: Colors.grey.shade200
                  ),
                  child: Row(
                    children: [
                      Expanded(child: TextHelper(text: "Party List",fontsize: 15,fontweight: FontWeight.w600,)),
                      Row(
                        spacing: 10,
                        children: [
                          ButtonG(
                            onTap: (){
                              partyStore.addingNewParty.value=true;
                            },
                            label: TextHelper(text: "Add New Party",fontsize: 13,fontweight: FontWeight.w600,),
                            height: 35,
                            width: 150,
                          ),
                          ButtonG(
                            label: TextHelper(text: "Update Party",fontsize: 13,fontweight: FontWeight.w600),
                            height: 35,
                            width: 150,
                          )
                        ],
                      )
                    ],
                  )),
              const SizedBox(height: 10,),
              Wrap(
                spacing: 50,
                alignment: WrapAlignment.spaceEvenly,
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.start,
                children: [
                  Container(
                    width: 200,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade200,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.shade900.withAlpha(100),
                          offset: Offset(0, 1),
                          blurRadius: 2,
                        )
                      ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 5,
                      children: [
                        TextHelper(text: "Total Party",),
                        TextHelper(
                          text: parseString(data: partyStore.partyList.length.toString(), defaultValue: '0'),
                          textalign: TextAlign.right,
                          fontsize: 34,
                          padding: EdgeInsets.only(right: 10),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.amber.shade200,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.shade900.withAlpha(100),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 5,
                      children: [
                        TextHelper(text: "Total Group",),
                        TextHelper(
                          text: parseString(data: partyStore.partyList.length.toString(), defaultValue: '0'),
                          textalign: TextAlign.right,
                          fontsize: 34,
                          padding: EdgeInsets.only(right: 10),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 200,
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.amber.shade200,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueGrey.shade900.withAlpha(100),
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          )
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 5,
                      children: [
                        TextHelper(text: "Outstanding",),
                        TextHelper(
                          text: parseString(data: partyStore.partyList.length.toString(), defaultValue: '0'),
                          textalign: TextAlign.right,
                          fontsize: 34,
                          padding: EdgeInsets.only(right: 10),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              SizedBox(
                height: MediaQuery.sizeOf(context).height-200,
                child: DataGridHelper2(
                    headerColor: Color(0xffd5dcf3),
                    columnSpacing: 5,
                    dataSource: partyStore.partyList.map((m)=>getPartyInMap(m)).toList(),
                    placeholder: "No Party Found\nAdd a new party",
                    columnList: [
                      DataGridColumnModel2(dataField: "name",
                          dataType: CellDataType2.string,
                          title: 'Name',

                      ),
                      DataGridColumnModel2(dataField: "outstanding", dataType: CellDataType2.int,title: 'Outstanding'),
                      DataGridColumnModel2(dataField: "mobile", dataType: CellDataType2.string,
                          title: 'Mobile',
                          showFilter: true
                      ),
                      DataGridColumnModel2(dataField: "address", dataType: CellDataType2.string,title: "Address"),
                    ],
                    uniqueKey: "partylistgrid",
                    width: MediaQuery.sizeOf(context).width-200
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
