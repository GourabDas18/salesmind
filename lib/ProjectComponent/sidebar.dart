import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';
import 'package:moon_icons/moon_icons.dart';
import 'package:salesmind/Helper/helper.dart';
import 'package:get/get.dart';
import 'package:salesmind/Store/getXStore.dart';
class Sidebar extends StatefulWidget {
  final int index ;
  Sidebar({super.key,required this.index});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {

  MainStore mainStore = Get.find();
  SideMenuController controller = SideMenuController();

  @override
  Widget build(BuildContext context) {
    return  SideMenu(
        backgroundColor:  Color(0xff262638),
        mode: SideMenuMode.open,
        maxWidth: 220,
        minWidth: 60,
        hasResizerToggle: true,
        controller: controller,
        builder: (data)=>
            SideMenuData(
                defaultTileData: SideMenuItemTileDefaults(
                  highlightSelectedColor:  Color(0xff14141e),
                  hoverColor:  Color(0xff14141e),
                  borderRadius: BorderRadius.circular(0),
                  titleStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white
                  ),
                  selectedTitleStyle: TextStyle(
                      color: Colors.yellow
                  ),
                ),
                header: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                  decoration: BoxDecoration(
                      color: Color(0xff14141e)
                  ),
                  child:  Row(
                    spacing: 8,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQC9R5aAXBZp7jOM1IzjMT7ejRqJKXcJC9t0Q&s",
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )),
                      TextHelper(text: "ABC Company",color: Colors.white,isWrap: true,)
                    ],
                  ),
                ),
                items:[
                  SideMenuItemDataTile(
                    isSelected: widget.index==0,
                    onTap: () => mainStore.path.value='/',
                    title: 'Home',
                    hasSelectedLine: true,
                    highlightSelectedColor:  Color(0xff14141e),
                    tooltip: 'Home',
                    selectedLineSize: Size(4, 60),
                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    icon: Icon(MoonIcons.generic_home_24_regular,color: Colors.white,),
                    selectedIcon: Icon(MoonIcons.generic_home_24_regular,color: Colors.yellow,),
                  ),
                  SideMenuItemDataTile(
                    isSelected: widget.index==1,
                    onTap: () => mainStore.path.value='/party',
                    title: 'Parties',
                    hasSelectedLine: true,
                    tooltip: 'Party Manager',
                    selectedLineSize: Size(4, 60),
                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    icon: Icon(MoonIcons.generic_users_32_light,color: Colors.white,),
                    selectedIcon: Icon(MoonIcons.generic_users_32_light,color: Colors.yellow,),
                  ),
                  SideMenuItemDataTile(
                      isSelected: widget.index==2,
                      onTap: () => mainStore.path.value='/inventory',
                      title: 'Inventory',
                      hasSelectedLine: true,
                      tooltip: 'Items Manager',
                      selectedLineSize: Size(4, 60),
                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      icon: Icon(MoonIcons.mail_box_32_light,color: Colors.white,),
                      selectedIcon: Icon(MoonIcons.mail_box_32_light,color: Colors.yellow,)
                  ),
                  SideMenuItemDataTile(
                    isSelected: widget.index==3,
                    onTap: () => mainStore.path.value='/sale',
                    title: 'Sale',
                    hasSelectedLine: true,
                    tooltip: 'Sale',
                    selectedLineSize: Size(4, 60),
                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    icon: Icon(MoonIcons.travel_bill_32_light,color: Colors.white,),
                    selectedIcon: Icon(MoonIcons.travel_bill_32_light,color: Colors.yellow,),
                  ),
                  SideMenuItemDataTile(
                    isSelected: widget.index==4,
                    onTap: () => mainStore.path.value='/purchase',
                    title: 'Purchase',
                    hasSelectedLine: true,
                    tooltip: 'Purchase',
                    selectedLineSize: Size(4, 60),
                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
                    icon: Icon(MoonIcons.shop_cart_32_regular,color: Colors.white,),
                    selectedIcon: Icon(MoonIcons.shop_cart_32_regular,color: Colors.yellow,),
                  ),
                  SideMenuItemDataTile(
                      isSelected: widget.index==5,
                      onTap: () => mainStore.path.value='/expense',
                      title: 'Expenses',
                      hasSelectedLine: true,
                      tooltip: 'Expenses',
                      selectedLineSize: Size(4, 60),
                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      icon: Icon(MoonIcons.shop_wallet_alternative_32_regular,color: Colors.white,),
                      selectedIcon: Icon(MoonIcons.shop_wallet_alternative_32_regular,color: Colors.yellow,)
                  ),
                  SideMenuItemDataTile(
                      isSelected: widget.index==6,
                      onTap: () => mainStore.path.value='/reports',
                      title: 'Reports',
                      hasSelectedLine: true,
                      tooltip: 'Reports',
                      selectedLineSize: Size(4, 60),
                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
                      icon: Icon(MoonIcons.chart_bar_alternative_32_regular,color: Colors.white,),
                      selectedIcon: Icon(MoonIcons.chart_bar_alternative_32_regular,color: Colors.yellow,)
                  ),
                ]
            )
    );
  }
}
