import 'package:salesmind/Store/getXStore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
class ButtonHelperG extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double? height;
  final double? width;
  final double borderRadius;
  final double? shadowOpacity;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? fontColor;
  final Widget child;
  final Widget? leading;
  final Widget? trailing;
  final Function() onTap;
  final Function()? onDblTap;
  final bool visible;
  ButtonHelperG({super.key,this.shadowOpacity, this.padding, this.height, this.width,this.borderRadius=10,
    this.backgroundColor,
    this.borderColor,
    this.fontColor,
    required this.child,
    required this.onTap,
    this.leading,
    this.trailing,
    this.onDblTap,
    this.visible=true
  });
  MainStore mainStore = Get.find();
  @override
  Widget build(BuildContext context) {
    return 
    visible ?
    GestureDetector(
      onTap: () {
        if(onDblTap!=null){
          onDblTap!();
        }
      },
      child: MoonButton(
        height: height,
        width: width,
        autofocus: true,
        onTap: onTap,

        padding:
        padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderRadius: BorderRadius.circular(borderRadius),
        backgroundColor: backgroundColor ?? const Color.fromARGB(255, 43, 42, 42),
        // borderColor: borderColor ?? Colors.blue,
        label: child,
        leading: leading,
        trailing: trailing,
      ),
    ):
    Container()
    ;
  }
}
