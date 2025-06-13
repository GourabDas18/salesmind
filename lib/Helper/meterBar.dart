

import 'package:flutter/material.dart';

class MeterBar extends StatelessWidget {
  final int width;
  final double? height;
  final int fillPercentage;
  final int emptyPercentage;
  final Color? fillColor;
  final Color? emptyColor;
  final double radius;
  final String? bottomText;
  const MeterBar({super.key, required this.fillPercentage, required this.emptyPercentage, this.fillColor, this.emptyColor, required this.width, this.height, this.radius= 5, this.bottomText});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          children: [
            Container(
              width: (width * fillPercentage)/100,
              height: height??20,
              decoration: BoxDecoration(
                borderRadius:  fillPercentage > 99 ? BorderRadius.circular(radius) :  BorderRadius.only(topLeft: Radius.circular(radius),bottomLeft: Radius.circular(radius)),
                  color: fillColor ?? const Color.fromARGB(255, 255, 170, 0),
                ),
              
            ),
            Container(
              width: (width * emptyPercentage)/100,
              height: height??20,
              decoration:  BoxDecoration(
                borderRadius: emptyPercentage > 99 ? BorderRadius.circular(radius) :  BorderRadius.only(topRight: Radius.circular(radius),bottomRight: Radius.circular(radius)),
                 color: emptyColor ?? const Color.fromARGB(255, 131, 131, 131),
                ),
               
            ),
          ],
        ),
        bottomText!=null ? Text(bottomText!,style: const TextStyle(fontSize: 11,color: Color.fromARGB(255, 173, 173, 173)),) : Container()
      ],
    );
  }
}