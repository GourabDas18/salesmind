import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import '../Store/getXStore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';

class Carousel extends StatefulWidget {
  List<String> imageUrlList = [];
  int selectedDotIndex = 0;
  double maxWidth;
  double height;
  bool isMini;
  BoxFit boxfit;
  Carousel(
      {super.key,
      required this.imageUrlList,
      this.isMini = false,
        this.boxfit = BoxFit.contain,
      required this.maxWidth,
      required this.height});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  MoonCarouselScrollController scrollController =
      MoonCarouselScrollController();
  MainStore mainStore = Get.find();
  @override
  Widget build(BuildContext context) {
    return widget.isMini
        ? Container(
            child: Stack(
              children: [
                SizedBox(
                  height: widget.height,
                  // width: 200,
                  width: widget.maxWidth,
                  child: OverflowBox(
                    maxWidth: widget.maxWidth,
                    child: MoonCarousel(
                      itemExtent: widget.height,
                      clampMaxExtent: true,
                      itemCount: widget.imageUrlList.length,
                      controller: scrollController,
                      transitionCurve: Curves.easeOutBack,
                      // loop: true,
                      onIndexChanged: (i) => setState(() {
                        widget.selectedDotIndex = i;
                      }),
                      itemBuilder:
                          (BuildContext context, int itemIndex, int _) =>
                              ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                            child: CircularProgressIndicator(
                              value: progress.progress,
                              color: Colors.grey[500],
                            ),
                          ),
                          imageUrl: widget.imageUrlList[itemIndex],
                          color: mainStore.isDarkMode.value
                              ? const Color.fromARGB(0, 185, 185, 185)
                              : const Color.fromARGB(255, 233, 236, 238),
                          colorBlendMode: BlendMode.multiply,
                          // height: widget.height,
                          // width: widget.maxWidth,
                          fit: widget.boxfit,
                          // progressIndicatorBuilder: (context, child, loadingProgress) {
                          //   if (loadingProgress == null) return child;
                          //   return Center(
                          //     child: CircularProgressIndicator(
                          //       value: loadingProgress.expectedTotalBytes !=
                          //               null
                          //           ? loadingProgress.cumulativeBytesLoaded /
                          //               loadingProgress.expectedTotalBytes!
                          //           : null,
                          //     ),
                          //   );
                          // },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if(widget.imageUrlList.length>1)
                Positioned(
                    top: 5,
                    left: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < widget.imageUrlList.length; i++)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.fastOutSlowIn,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: i == widget.selectedDotIndex
                                  ? Colors.blue
                                  : Colors.grey[300],
                            ),
                            width: widget.isMini ? 6 : 9,
                            height: widget.isMini ? 6 : 9,
                          )
                      ],
                    ))
              ],
            ),
          )
        : Column(
            children: [
              SizedBox(
                height: widget.height,
                // width: 200,
                width: widget.maxWidth,
                child: OverflowBox(
                  maxWidth: widget.maxWidth,
                  child: MoonCarousel(
                    itemExtent: widget.maxWidth,
                    clampMaxExtent: true,
                    itemCount: widget.imageUrlList.length,
                    controller: scrollController,
                    transitionCurve: Curves.easeOutBack,
                    // loop: true,
                    onIndexChanged: (i) => setState(() {
                      widget.selectedDotIndex = i;
                    }),
                    itemBuilder: (BuildContext context, int itemIndex, int _) =>
                        //     Image.network(
                        //   widget.imageUrlList[itemIndex],
                        //   color: mainStore.isDarkEnable.value
                        //       ? const Color.fromARGB(0, 185, 185, 185)
                        //       : const Color.fromARGB(255, 233, 236, 238),
                        //   colorBlendMode: BlendMode.multiply,
                        //   // height: widget.height,
                        //   // width: widget.maxWidth,
                        //   fit: BoxFit.contain,
                        //   loadingBuilder: (context, child, loadingProgress) {
                        //     if (loadingProgress == null) return child;
                        //     return Center(
                        //       child: CircularProgressIndicator(
                        //         value: loadingProgress.expectedTotalBytes != null
                        //             ? loadingProgress.cumulativeBytesLoaded /
                        //                 loadingProgress.expectedTotalBytes!
                        //             : null,
                        //       ),
                        //     );
                        //   },
                        // )
                        CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, progress) =>
                          Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                          color: Colors.grey[500],
                        ),
                                              ),
                                              imageUrl: widget.imageUrlList[itemIndex],
                                              color: mainStore.isDarkMode.value
                          ? const Color.fromARGB(0, 185, 185, 185)
                          : const Color.fromARGB(255, 255, 254, 251),
                                              colorBlendMode: BlendMode.multiply,
                                              // height: widget.height,
                                              // width: widget.maxWidth,
                                              fit: widget.boxfit,
                                              // progressIndicatorBuilder: (context, child, loadingProgress) {
                                              //   if (loadingProgress == null) return child;
                                              //   return Center(
                                              //     child: CircularProgressIndicator(
                                              //       value: loadingProgress.expectedTotalBytes !=
                                              //               null
                                              //           ? loadingProgress.cumulativeBytesLoaded /
                                              //               loadingProgress.expectedTotalBytes!
                                              //           : null,
                                              //     ),
                                              //   );
                                              // },
                                            ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if(widget.imageUrlList.length>1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < widget.imageUrlList.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutSine,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: i == widget.selectedDotIndex
                            ? Colors.blue
                            : Colors.grey[300],
                      ),
                      width: widget.isMini ? 4 : 9,
                      height: widget.isMini ? 4 : 9,
                    )
                ],
              )
            ],
          );
  }

  @override
  void dispose() {
    super.dispose();
    Timer(Duration(milliseconds: 200), () {
      scrollController.dispose();
    });
  }
}
