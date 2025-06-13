import 'package:salesmind/Helper/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moon_design/moon_design.dart';

class TreeWidget extends StatelessWidget {
  final List<String> treeKeyList;
  final List<Map<String, dynamic>> dataSource;
  final bool firstChildExpand;
  final Widget Function(dynamic childData) childCellMaker;
  const TreeWidget(
      {super.key,
      required this.treeKeyList,
      required this.dataSource,
      required this.childCellMaker,
        this.firstChildExpand=false
      });

  List<Map<String, dynamic>> treeDataCreator(
      {required List<Map<String, dynamic>> data,
      required List<String> treeKeys}) {
    List<Map<String, dynamic>> newList = [];
    List<String> uniqueListParent = [];
    List makeData(String key, int index, List data) {
      List<String> uniqueList = [];
      List returnList = [];
      if (index < treeKeys.length - 1) {
        for (var e in data) {
          if (!uniqueList.any((t) => t == e[key])) {
            uniqueList.add(e[key]);
          }
        }
        for (var unique in uniqueList) {
          returnList.add({
            'treeIndex': treeKeys.length - 1 - index,
            'child': makeData(treeKeys[index], index + 1,
                data.where((d) => d[treeKeys[index]] == unique).toList()),
            'name': unique
          });
        }
      } else {
        returnList.add({'treeIndex': 0, 'child': data});
      }
      return returnList;
    }

    for (var x in data) {
      // if (uniqueListParent.isNotEmpty) {
      if (!uniqueListParent.any((u) => u == x[treeKeys[0]])) {
        uniqueListParent.add(parseString(data: x[treeKeys[0]], defaultValue: ''));
      }
      // }
    }

    for (var uniqueP in uniqueListParent) {
      newList.add({
        'treeIndex': treeKeys.length - 1,
        'name': uniqueP,
        'child': makeData(treeKeys[1], 1,
            data.where((d) => d[treeKeys[0]] == uniqueP).toList())
      });
    }

    return newList;
  }

  Widget makeTreeWidget(
      {required List<Map<String, dynamic>> data,
      required BuildContext context}) {
    return Column(
        children: data.isEmpty
            ? []
            : data[0]['treeIndex'] != null && data[0]['treeIndex'] == 0
                ? data[0]['child'].map<Widget>((c) {
                    return childCellMaker(c);
                  }).toList()
                : data.asMap()
                    .map((index,d) =>
            MapEntry(
              index
              , Column(
                            children: [
                              MoonAccordion(
                                initiallyExpanded: index==0 ?firstChildExpand:false,
                                label: Padding(
                                  padding: EdgeInsets.only(
                                      left: 5 *
                                          (double.tryParse(d['treeIndex']
                                                      .toString()) ==
                                                  null
                                              ? 0.0
                                              : double.parse(
                                                  d['treeIndex'].toString()))),
                                  child: Text(
                                    d['name'],
                                  ),
                                ),
                                // showDivider: false,
                                showBorder: false,
                                decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.transparent)),
                                children: [
                                  makeTreeWidget(
                                      data: d['child']
                                          .map<Map<String, dynamic>>(
                                              (m) => Map<String, dynamic>.from(m))
                                          .toList(),
                                      context: context)
                                ],
                              ),
                            ],
                          ),
            )).values.toList());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: makeTreeWidget(
          data: treeDataCreator(data: dataSource, treeKeys: treeKeyList),
          context: context),
    ));
  }
}
