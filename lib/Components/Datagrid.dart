
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import '../Helper/helper.dart';
import '../Store/getXStore.dart';

class DataGridHelperStore extends GetxController {
  RxList<Map<String, int>> editableCell = [
    {"row": -1, "cell": -1}
  ].obs;
  RxList selectedRow = [].obs;
  TextEditingController editCellTextController = TextEditingController();
}

class CellUpdateValue {
  final int rowIndex;
  final int colIndex;
  final String colName;
  final String value;

  CellUpdateValue(
      {required this.rowIndex,
      required this.colIndex,
      required this.colName,
      required this.value});
}

class DataGridHelper extends StatelessWidget {
  final MainStore mainStore = Get.find();

  final List dataSource;
  final List<DataGridColumnModel> columnList;
  final Color headerColor;
  final bool showSelection;
  final bool showFooter;
  final Color? footerColor;
  final double fontSize;
  final double columnSpacing;
  final double width;
  final bool showAlternateColor;
  final String uniqueKey;
  final Function(CellUpdateValue)? onCellValueChange;
  DataGridHelper(
      {super.key,
      required this.dataSource,
      required this.columnList,
      required this.uniqueKey,
      this.fontSize = 13,
      this.columnSpacing = 0,
      required this.width,
      this.onCellValueChange,
      this.showFooter = false,
      this.showAlternateColor = false,
      this.footerColor,
      this.headerColor = const Color.fromARGB(255, 218, 235, 255),
      this.showSelection = false});

  // List selectedRow = [];
  // List editableCell = [
  //   {"row": -1, "cell": -1}
  // ];
  double getAutoWidth() {
    double x = 0;
    int count = 0;
    for (var m in columnList) {
      if (m.width != null) {
        x += m.width!;
        count++;
      }
    }
    return ((width - x) / (columnList.length - count) - 20);
  }

  double getAutoHeadWidth() {
    double x = 0;
    int count = 0;
    for (var m in columnList) {
      if (m.width != null) {
        x += m.width!;
        count++;
      }
    }
    return ((width - x) / (columnList.length - count) - 8);
  }

  String getTextValue(dynamic data, CellDataType cellType) {
    return cellType == CellDataType.int
        ? data == null
            ? '0'
            : data.toString()
        : data == null
            ? '0'
            : data.toString();
  }

  String getSummeryValue(int index, SummeryType? summeryType) {
    if (summeryType == null) {
      return "No summery type found";
    }
    String key = columnList[index].dataField;
    List data = dataSource.map((m) => m[key]).toList();
    // print(data);
    if (summeryType == SummeryType.count) {
      return data.length.toString();
    } else if (summeryType == SummeryType.sum) {
      return double.parse(data
              .fold(
                  0.0,
                  (a, b) =>
                      double.parse(a.toString()) +
                      double.parse(double.tryParse(b.toString()) == null
                          ? '0.0'
                          : b.toString()))
              .toString())
          .toStringAsFixed(2);
    } else {
      return '';
    }
  }

  List<DataColumn> columns(
      List<DataGridColumnModel> list, BuildContext context) {
    return list
        .map((m) => DataColumn(
              headingRowAlignment: m.textAlign == CellTextAlignment.left
                  ? MainAxisAlignment.start
                  : m.textAlign == CellTextAlignment.right
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.center,
              label: Text(m.title ?? m.dataField.toString().toUpperCase(),
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600)),
            ))
        .toList();
  }

  List<DataRow> rows(List dataSource, List<DataGridColumnModel> columnList,
      BuildContext context) {
    List<DataRow> dataRow = [];
    for (int i = 0; i < dataSource.length; i++) {
      Map<String, dynamic> m = dataSource[i];
      List<DataCell> cellList = [];

      for (int cellIndex = 0; cellIndex < columnList.length; cellIndex++) {
        try {
          DataGridColumnModel x = columnList[cellIndex];
          cellList.add(DataCell(
            dataGridHelperStore.editableCell
                        .any((e) => e['row'] == i && e['cell'] == cellIndex) &&
                    x.editable != null &&
                    x.editable == true
                ? Center(
                    child:
                    TextBoxHelperG(
                        width: x.editorWidth ?? x.width ?? getAutoWidth(),
                        controller: dataGridHelperStore.editCellTextController,
                        selectTextOnFocus: x.selectTextOnEditStart,
                      autofocus: true,
                      keyboard: x.keyboard,
                      fontSize: x.fontSize,
                      onValueChange: (e){},
                      value: getTextValue(m[x.dataField], x.dataType),
                        onSubmitted: (value){
                              if (onCellValueChange != null) {
                                onCellValueChange!(CellUpdateValue(
                                    rowIndex: i,
                                    colIndex: cellIndex,
                                    colName: x.dataField,
                                    value: dataGridHelperStore
                                        .editCellTextController.text));
                              }
                              dataGridHelperStore.editableCell.clear();
                              dataGridHelperStore.editCellTextController.text = '';
                        },
                        onTapOutside: () {
                          //dataGridHelperStore.editableCell.removeWhere(
                          //     (e) => e['row'] == i && e['cell'] == cellIndex);
                          if (onCellValueChange != null) {
                            onCellValueChange!(CellUpdateValue(
                                rowIndex: i,
                                colIndex: cellIndex,
                                colName: x.dataField,
                                value: dataGridHelperStore
                                    .editCellTextController.text));
                          }
                          dataGridHelperStore.editableCell.clear();
                          dataGridHelperStore.editCellTextController.text = '';
                        },
                    )
                  )
                : Container(
                    width: x.width ?? getAutoHeadWidth(),
                    alignment: x.textAlign == CellTextAlignment.left
                        ? Alignment.centerLeft
                        : x.textAlign == CellTextAlignment.right
                            ? Alignment.centerRight
                            : Alignment.center,
                    padding: x.textAlign == CellTextAlignment.right
                        ? const EdgeInsets.only(right: 8)
                        : x.textAlign == CellTextAlignment.left
                            ? const EdgeInsets.only(left: 8)
                            : const EdgeInsets.symmetric(horizontal: 0),
                    child: x.customCell != null
                        ? x.customCell!(CustomCellData(
                            rowIndex: i,
                            cellIndex: cellIndex,
                            rowValue: m,
                            cellValue: m[x.dataField]))
                        : Text(
                            getTextValue(m[x.dataField], x.dataType),
                            softWrap: true,
                            textWidthBasis: TextWidthBasis.parent,
                            textAlign: TextAlign.left,
                            // textAlign: x.textAlign == CellTextAlignment.left
                            //     ? TextAlign.left
                            //     : x.textAlign == CellTextAlignment.right
                            //         ? TextAlign.right
                            //         : TextAlign.center,
                            style: TextStyle(
                              fontSize: fontSize,
                            ),
                          ),
                  ),
            onTap: () {
              if (showSelection == false && x.editable == true) {
                dataGridHelperStore.editCellTextController.text =
                    getTextValue(m[x.dataField], x.dataType);
                dataGridHelperStore.editableCell.value = [
                  {'row': i, 'cell': cellIndex}
                ];
              }
            },
          ));
        } catch (e) {}
      }
      dataRow.add(DataRow(
          cells: cellList,
          selected: dataGridHelperStore.selectedRow.contains(i),
          color: !showAlternateColor
              ? WidgetStatePropertyAll(mainStore.isDarkMode.value
                  ? const Color.fromARGB(255, 26, 26, 26)
                  : const Color.fromARGB(255, 255, 255, 255))
              : i % 2 != 0
                  ? WidgetStatePropertyAll(mainStore.isDarkMode.value
                      ? const Color.fromARGB(255, 39, 39, 39)
                      : const Color.fromARGB(255, 242, 248, 248))
                  // ? const WidgetStatePropertyAll(Color.fromARGB(255, 238, 238, 238))
                  : WidgetStatePropertyAll(mainStore.isDarkMode.value
                      ? const Color.fromARGB(255, 26, 26, 26)
                      : const Color.fromARGB(255, 255, 255, 255)),
          onSelectChanged: (d) {
            dataGridHelperStore.selectedRow.removeWhere((f) => f == i);
            if (d == true) {
              dataGridHelperStore.selectedRow.add(i);
            }
          }));
    }

    return dataRow;
  }

  late DataGridHelperStore dataGridHelperStore =
      Get.put(DataGridHelperStore(), tag: uniqueKey);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        color: mainStore.isDarkMode.value ? Colors.black : Colors.white,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Head====
              Container(
                width: width,
                height: 50,
                decoration: BoxDecoration(color: headerColor),
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...columnList.map((e) => SizedBox(
                        width: e.width ?? getAutoHeadWidth(),
                        child: Container(
                            // color: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            alignment: e.textAlign == CellTextAlignment.left
                                ? Alignment.centerLeft
                                : e.textAlign == CellTextAlignment.right
                                    ? Alignment.centerRight
                                    : Alignment.center,
                            child: Text(
                              e.title?.toUpperCase() ??
                                  e.dataField.toUpperCase(),
                              softWrap: true,
                              textWidthBasis: TextWidthBasis.parent,
                              // textAlign: TextAlign.,
                              style:  TextStyle(
                                fontSize: fontSize,
                                // fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                              ),
                            ))))
                  ],
                ),
              ),

              // Grid=======
              dataSource.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text("No Item"),
                      ),
                    )
                  : Expanded(
                      child: SizedBox(
                        width: width,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            DataTable(
                              clipBehavior: Clip.hardEdge,
                                showBottomBorder: true,
                                // border: TableBorder.all(width: 1),
                                columnSpacing: columnSpacing,
                                headingRowColor:
                                    WidgetStatePropertyAll(headerColor),
                                headingRowHeight: 0,
                                horizontalMargin: 0,
                                showCheckboxColumn: showSelection,
                                columns: columns(columnList, context),
                                rows: rows(dataSource, columnList, context))
                          ],
                        ),
                      ),
                    ),

              // Footer=======
              if (showFooter)
                Container(
                  width: width,
                  height: 40,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                      color: footerColor,
                      border: Border.all(
                          width: 0,
                          color: mainStore.isDarkMode.value
                              ? const Color.fromARGB(255, 73, 73, 73)
                              : const Color.fromARGB(255, 197, 196, 196))),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: columnSpacing<8?2:columnSpacing,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        for (int i = 0; i < columnList.length; i++)
                          SizedBox(
                              width:
                                  columnList[i].width ?? getAutoHeadWidth(),
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 8),
                                  alignment: columnList[i].textAlign ==
                                          CellTextAlignment.left
                                      ? Alignment.centerLeft
                                      : columnList[i].textAlign ==
                                              CellTextAlignment.right
                                          ? Alignment.centerRight
                                          : Alignment.center,
                                  child:
                                  columnList[i].customSummaryCell==null ?
                                  TextHelper(
                                   text: !columnList[i].withSummery
                                        ? ''
                                        : columnList[i].summeryPrefix +
                                            getSummeryValue(
                                                i, columnList[i].summeryType),
                                    textalign: columnList[i].textAlign ==
                                        CellTextAlignment.right ? TextAlign.right : columnList[i].textAlign ==
                                        CellTextAlignment.left ? TextAlign.left: TextAlign.center,
                                    fontsize: fontSize,
                                    fontweight: FontWeight.w600,
                                    isWrap: true,

                                  ):
                                  columnList[i].customSummaryCell!(!columnList[i].withSummery
                                      ? ''
                                      : columnList[i].summeryPrefix +
                                      getSummeryValue(
                                          i, columnList[i].summeryType))
                              ))
                      ]),
                )
            ],
          ),
        ),
      );
    });
  }
}

enum CellTextAlignment { center, left, right }

enum CellDataType { string, int, bool }

enum SummeryType { count, sum, none }

class CustomCellData {
  int rowIndex;
  int cellIndex;
  Map rowValue;
  dynamic cellValue;

  CustomCellData(
      {required this.rowIndex,
      required this.cellIndex,
      required this.rowValue,
      required this.cellValue});
}

class DataGridColumnModel {
  final String dataField;
  final String? title;
  final bool? editable;
  final bool selectTextOnEditStart;
  final double? width;
  final double? fontSize;
  final double? editorWidth;
  final TextInputType keyboard;
  final CellDataType dataType;
  final CellTextAlignment textAlign;
  final SummeryType summeryType;
  final bool withSummery;
  final String summeryPrefix;
  final Widget Function(CustomCellData)? customCell;
  final Widget Function(String value)? customSummaryCell;
  DataGridColumnModel(
      {required this.dataField,
      this.title,
      this.editable,
      this.width,
      this.fontSize,
      this.editorWidth,
      this.summeryType = SummeryType.none,
      this.withSummery = false,
      this.selectTextOnEditStart = false,
      this.keyboard = TextInputType.text,
      this.summeryPrefix = '',
      this.customCell,
      this.customSummaryCell,
      required this.dataType,
      this.textAlign = CellTextAlignment.center});
}
