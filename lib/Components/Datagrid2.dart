import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moon_design/moon_design.dart';
import 'package:salesmind/Helper/helper.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../Store/getXStore.dart';


class DataGridHelperStore extends GetxController {
  RxList<Map<String, int>> editableCell = [
    {"row": -1, "cell": -1}
  ].obs;
  RxList selectedRow = [].obs;
  TextEditingController editCellTextController = TextEditingController();
  RxList<int> filterShowIndex = <int>[].obs;
  RxList<String> filterOpenIndex = <String>[].obs;
  RxList<Map<String,dynamic>> filteredData = <Map<String,dynamic>>[].obs;
  RxList filteredDataSource = [].obs;
  List<DataRow> rows = <DataRow>[].obs;
  RxDouble footerWidth=(0.0).obs;
  RxInt totalPage = 0.obs;
  RxInt currentPageIndex = 0.obs;
  RxBool isPaginate = false.obs;
}

class CellUpdateValue2 {
  final int rowIndex;
  final int colIndex;
  final String colName;
  final String value;

  CellUpdateValue2(
      {required this.rowIndex,
        required this.colIndex,
        required this.colName,
        required this.value});
}

class DataGridHelper2 extends StatefulHookWidget {

  final List dataSource;
  final List<DataGridColumnModel2> columnList;
  final Color headerColor;
  final bool showSelection;
  final bool showFooter;
  final Color? footerColor;
  final double fontSize;
  final bool withPaginate;
  final int defaultPageSize;
  final double columnSpacing;
  final double width;
  final bool showAlternateColor;
  final String uniqueKey;
  final String placeholder;
  final Function(CellUpdateValue2)? onCellValueChange;
  DataGridHelper2(
      {super.key,
        required this.dataSource,
        required this.columnList,
        required this.uniqueKey,
        this.fontSize = 13,
        this.columnSpacing = 0,
        this.defaultPageSize = 0,
        this.withPaginate = false,
        required this.width,
        this.onCellValueChange,
        this.showFooter = false,
        this.showAlternateColor = false,
        this.placeholder = "No Item",
        this.footerColor,
        this.headerColor = const Color.fromARGB(255, 218, 235, 255),
        this.showSelection = false});

  @override
  State<DataGridHelper2> createState() => _DataGridHelper2State();
}

class _DataGridHelper2State extends State<DataGridHelper2> {
  final GlobalKey myTableKey = GlobalKey();
  final MainStore mainStore = Get.find();
  ScrollController horizontalScrollCon = ScrollController();
  ScrollController footerScrollCon = ScrollController();
  ScrollController verticalScrollCon = ScrollController();
  // List selectedRow = [];
  double getAutoWidth() {
    double x = 0;
    int count = 0;
    for (var m in widget.columnList) {
      if (m.width != null) {
        x += m.width!;
        count++;
      }
    }
    return ((widget.width - x) / (widget.columnList.length - count) - 8 );
  }

  double getAutoHeadWidth() {
    double x = 0;
    int count = 0;
    for (var m in widget.columnList) {
      if (m.width != null) {
        x += m.width!;
        count++;
      }
    }
    return ((widget.width - x) / (widget.columnList.length - count) - (8+ widget.columnSpacing) );
  }

  String getTextValue(dynamic data, CellDataType2 cellType) {
    return cellType == CellDataType2.int
        ? data == null
        ? '0'
        : data.toString()
        : data == null
        ? '0'
        : data.toString();
  }

  String getSummeryValue(int index, SummeryType2? summeryType,List dataSource) {
    if (summeryType == null) {
      return "No summery type found";
    }
    String key = widget.columnList[index].dataField;
    List data = dataSource.map((m) => m[key]).toList();
    // print(data);
    if (summeryType == SummeryType2.count) {
      return data.length.toString();
    } else if (summeryType == SummeryType2.sum) {
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
      List<DataGridColumnModel2> list, BuildContext context) {
    return list
        .map((m) => DataColumn(
      headingRowAlignment: m.textAlign == CellTextAlignment2.left
          ? MainAxisAlignment.start
          : m.textAlign == CellTextAlignment2.right
          ? MainAxisAlignment.end
          : MainAxisAlignment.center,
      label: Text(m.title ?? m.dataField.toString().toUpperCase(),
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w600)),
    ))
        .toList();
  }

  Widget cellBuilding(TableVicinity v, List dataSource){
    int x = v.xIndex;
    int x2 = v.xIndex;
    int y = v.yIndex;
    int y2 = v.yIndex;
    // Map<String,dynamic> m = widget.dataSource[y];


    Map<String,dynamic> m = {};
    if(y!=0){
      y = v.yIndex-1;
      m = dataSource[v.yIndex-1];
    }else{
      m = dataSource[y];
    }
    return  Obx(
        ()=> GestureDetector(
        onTap: () {
          if (widget.showSelection == false && widget.columnList[x].editable == true) {
            dataGridHelperStore.editCellTextController.text =
                getTextValue(m[widget.columnList[x].dataField], widget.columnList[x].dataType);
            dataGridHelperStore.editableCell.value = [
              {'row': y, 'cell': x}
            ];
          }
        },
        child:
        y2==0?
        Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1,color: Color(0xcaf1f1f1))),
                color: widget.headerColor
            ),
            child:
            Row(
              children: [
                Expanded(
                  child: TextHelper(text: parseString(data: widget.columnList[x2].title ?? widget.columnList[x2].dataField, defaultValue: ""),
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 4),

                    textalign: widget.columnList[x2].textAlign == CellTextAlignment2.left
                        ? TextAlign.left
                        : widget.columnList[x2].textAlign == CellTextAlignment2.right
                            ? TextAlign.right
                            : TextAlign.center,
                    fontweight: FontWeight.w600,
                    fontsize: widget.fontSize+1,
                    isWrap: true,
                  ),
                ),
                if(dataGridHelperStore.filterShowIndex.contains(x2))
                  MoonPopover(
                      show: dataGridHelperStore.filterOpenIndex.contains(x.toString()),
                      popoverPosition: x2.toString()=='0' ? MoonPopoverPosition.bottomRight : MoonPopoverPosition.bottomLeft,
                      onTapOutside: (){
                        dataGridHelperStore.filterOpenIndex.remove(x.toString());
                      },
                      backgroundColor: mainStore.isDarkMode.value ? Colors.blueGrey.shade900 : Colors.white,
                      content: Column(
                        children: [
                          SizedBox(
                            width: 180,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextHelper(text: "Select All",fontsize: 14,fontweight: FontWeight.w600,),
                                MoonCheckbox(
                                  value: dataGridHelperStore.filteredData.indexWhere((t)=>t['key']==widget.columnList[x2].dataField)==-1 ? false:
                                  dataGridHelperStore.filteredData.firstWhere((t)=>t['key']==widget.columnList[x2].dataField,orElse: ()=>{'value':[]})['value'].length== widget.dataSource.length ? true: null
                                  ,
                                  onChanged: (v){
                                    if(v!=null && v==true) {
                                      int filterIndex = dataGridHelperStore
                                          .filteredData
                                          .indexWhere((t) =>
                                      t['key'] == widget
                                          .columnList[x2]
                                          .dataField);
                                      if (filterIndex == 0) {
                                        dataGridHelperStore
                                            .filteredData.add({
                                          'key': widget
                                              .columnList[x2]
                                              .dataField,
                                          'value': widget.dataSource.map((m) =>m[widget.columnList[x2].dataField].toString()).toList()
                                        });
                                      }
                                      else {
                                        if(filterIndex!=-1){
                                          dataGridHelperStore.filteredData.value.removeAt(filterIndex);}
                                        dataGridHelperStore.filteredData.add({
                                          'key': widget
                                              .columnList[x]
                                              .dataField,
                                          'value': widget.dataSource.map((m) => m[widget.columnList[x2].dataField].toString()).toList()
                                        });
                                      }

                                    }else{
                                      int filterIndex = dataGridHelperStore.filteredData.indexWhere((t) =>t['key'] == widget.columnList[x2].dataField);
                                      dataGridHelperStore.filteredData.value.removeAt(filterIndex);
                                    }
                                    filterDataSource();
                                  },activeColor: Colors.blue,tristate: true,

                                )
                              ],),
                          ),
                          SizedBox(
                              width: 180,
                              child: Divider()),
                          Container(
                            width: 180,
                            height: 150,
                            child:
                            ListView.builder(
                                padding:EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                                itemCount: getUniqueFilterList(x2).length,
                                itemBuilder: (context,childIndex)=>
                                    GestureDetector(
                                      onTap: (){
                                        bool isChecked = isFilterItemSelected(widget.columnList[x2].dataField,getUniqueFilterList(x2)[childIndex]);
                                        if(isChecked){
                                          removeFilterItemSelect(widget.columnList[x2].dataField,getUniqueFilterList(x2)[childIndex]);
                                        }else{
                                          setFilterItemSelect(widget.columnList[x2].dataField,getUniqueFilterList(x2)[childIndex]);
                                        }
                                        filterDataSource();
                                      },
                                      child: Row(
                                        children: [
                                          StreamBuilder<Object>(
                                              stream: dataGridHelperStore.filteredData.stream,
                                              builder: (context, snapshot) {
                                                return MoonCheckbox(
                                                    activeColor: Colors.blue,
                                                    onChanged: (v){
                                                      bool isChecked = isFilterItemSelected(widget.columnList[x2].dataField,getUniqueFilterList(x2)[childIndex]);
                                                      if(isChecked){
                                                        removeFilterItemSelect(widget.columnList[x2].dataField,getUniqueFilterList(x2)[childIndex]);
                                                      }else{
                                                        setFilterItemSelect(widget.columnList[x2].dataField,getUniqueFilterList(x2)[childIndex]);
                                                      }
                                                      filterDataSource();
                                                    },
                                                    value: isFilterItemSelected(widget.columnList[x2].dataField,getUniqueFilterList(x2)[childIndex]));
                                              }
                                          ),
                                          Expanded(
                                            child: TextHelper(text:getUniqueFilterList(x2)[childIndex].toString(),fontsize: 12,),
                                          ),
                                        ],
                                      ),
                                    )
                            ),
                          ),
                        ],
                      ),
                      child:  GestureDetector(
                        onTap: (){
                          if(dataGridHelperStore.filterOpenIndex.contains(x2.toString())) {
                            dataGridHelperStore.filterOpenIndex
                                .remove(x2.toString());
                          }else{
                            dataGridHelperStore.filterOpenIndex.add(x2.toString());
                          }
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          color: Colors.transparent,
                          child:  Icon(FontAwesomeIcons.filter,size: 12,color: dataGridHelperStore.filteredData.indexWhere((t)=>t['key']==widget.columnList[x2].dataField)==-1?Colors.black87:Colors.blue.shade700,),
                        ),
                      ))
              ],
            ))

            :

        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1,color: Color(0xcaf1f1f1))),
          ),
          child: dataGridHelperStore.editableCell
              .any((e) => e['row'] == y && e['cell'] == x) &&
              widget.columnList[x].editable != null &&
              widget.columnList[x].editable == true
              ? Center(
              child:
              TextBoxHelperG(
                width: widget.columnList[x].editorWidth ?? widget.columnList[x].width ?? getAutoWidth(),
                controller: dataGridHelperStore.editCellTextController,
                selectTextOnFocus: widget.columnList[x].selectTextOnEditStart,
                autofocus: true,
                keyboard: widget.columnList[x].keyboard,
                fontSize: widget.columnList[x].fontSize,
                onValueChange: (e){},
                value: getTextValue(m[widget.columnList[x].dataField], widget.columnList[x].dataType),
                onSubmitted: (value){
                  if (widget.onCellValueChange != null) {
                    widget.onCellValueChange!(CellUpdateValue2(
                        rowIndex: y,
                        colIndex: x,
                        colName: widget.columnList[x].dataField,
                        value: dataGridHelperStore
                            .editCellTextController.text));
                  }
                  dataGridHelperStore.editableCell.clear();
                  dataGridHelperStore.editCellTextController.text = '';
                },
                onTapOutside: () {
                  //dataGridHelperStore.editableCell.removeWhere(
                  //     (e) => e['row'] == i && e['cell'] == cellIndex);
                  if (widget.onCellValueChange != null) {
                    widget.onCellValueChange!(CellUpdateValue2(
                        rowIndex: y,
                        colIndex: x,
                        colName: widget.columnList[x].dataField,
                        value: dataGridHelperStore
                            .editCellTextController.text));
                  }
                  dataGridHelperStore.editableCell.clear();
                  dataGridHelperStore.editCellTextController.text = '';
                },
              )
            // MoonTextInput(
            //   width: x.editorWidth ?? x.width ?? getAutoWidth(),
            //   style: TextStyle(fontSize: fontSize),
            //   initialValue: getTextValue(m[x.dataField], x.dataType),
            //   backgroundColor: mainStore.isDarkMode.value
            //       ? const Color.fromARGB(255, 124, 124, 124)
            //       : const Color.fromARGB(59, 146, 146, 146),
            //   activeBorderColor: Colors.transparent,
            //   autofocus: true,
            //   controller: dataGridHelperStore.editCellTextController,
            //   // onChanged: (value) {
            //   //   if (onCellValueChange != null) {
            //   //     EasyDebounce.debounce(
            //   //         uniqueKey, const Duration(milliseconds: 500), () {
            //   //       onCellValueChange!(CellUpdateValue(
            //   //           rowIndex: i,
            //   //           colIndex: cellIndex,
            //   //           colName: x.dataField,
            //   //           value: dataGridHelperStore
            //   //               .editCellTextController.text));
            //   //     });
            //   //   }
            //   // },
            //
            //   onEditingComplete: () {
            //     if (onCellValueChange != null) {
            //       onCellValueChange!(CellUpdateValue(
            //           rowIndex: i,
            //           colIndex: cellIndex,
            //           colName: x.dataField,
            //           value: dataGridHelperStore
            //               .editCellTextController.text));
            //     }
            //
            //     dataGridHelperStore.editableCell.clear();
            //     dataGridHelperStore.editCellTextController.text = '';
            //   },
            //   onTapOutside: (event) {
            //     //dataGridHelperStore.editableCell.removeWhere(
            //     //     (e) => e['row'] == i && e['cell'] == cellIndex);
            //     if (onCellValueChange != null) {
            //       onCellValueChange!(CellUpdateValue(
            //           rowIndex: i,
            //           colIndex: cellIndex,
            //           colName: x.dataField,
            //           value: dataGridHelperStore
            //               .editCellTextController.text));
            //     }
            //     dataGridHelperStore.editableCell.clear();
            //     dataGridHelperStore.editCellTextController.text = '';
            //   },
            // ),
          )
              : Container(
            width: widget.columnList[x].width ?? getAutoHeadWidth(),
            alignment: widget.columnList[x].textAlign == CellTextAlignment2.left
                ? Alignment.centerLeft
                : widget.columnList[x].textAlign == CellTextAlignment2.right
                ? Alignment.centerRight
                : Alignment.center,
            padding: widget.columnList[x].textAlign == CellTextAlignment2.right
                ? const EdgeInsets.only(right: 8)
                : widget.columnList[x].textAlign == CellTextAlignment2.left
                ? const EdgeInsets.only(left: 8)
                : const EdgeInsets.symmetric(horizontal: 0),
            child: widget.columnList[x].customCell != null
                ? widget.columnList[x].customCell!(CustomCellData2(
                rowIndex: y,
                cellIndex: x,
                rowValue: m,
                cellValue: m[widget.columnList[x].dataField]))
                : Text(
              getTextValue(m[widget.columnList[x].dataField], widget.columnList[x].dataType),
              softWrap: true,
              textWidthBasis: TextWidthBasis.parent,
              textAlign: TextAlign.left,
              // textAlign: x.textAlign == CellTextAlignment.left
              //     ? TextAlign.left
              //     : x.textAlign == CellTextAlignment.right
              //         ? TextAlign.right
              //         : TextAlign.center,
              style: TextStyle(
                fontSize: widget.fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // FIlter Item CRUD =====
  bool isFilterItemSelected(String key,dynamic value){
   int index = dataGridHelperStore.filteredData.value.indexWhere((t)=>t['key']==key);
   if(index==-1) return false;
   Map<String,dynamic> data = dataGridHelperStore.filteredData.value[index];
   return data['value'].contains(value.toString());
  }

  void setFilterItemSelect(String key,dynamic value){
    int index = dataGridHelperStore.filteredData.indexWhere((t)=>t['key']==key);
    if(index==-1){
      dataGridHelperStore.filteredData.add({
        'key':key,
        'value':[value.toString()]
      });
    }else{
      dataGridHelperStore.filteredData[index]['value'].add(value.toString());
    }
    dataGridHelperStore.filteredData.refresh();
  }

  void removeFilterItemSelect(String key,dynamic value){
    int index = dataGridHelperStore.filteredData.indexWhere((t)=>t['key']==key);
    if(index==-1){
     return;
    }else{
      int length =  dataGridHelperStore.filteredData[index]['value'].length;
      if(length>1){
        dataGridHelperStore.filteredData[index]['value'].remove(value.toString());
      }else{
        dataGridHelperStore.filteredData.removeAt(index);
      }
    }
    dataGridHelperStore.filteredData.refresh();
  }

  void filterDataSource(){
    List data = [...widget.dataSource];
    dataGridHelperStore.filteredData.forEach((fData){
      data.retainWhere((d)=>fData['value'].contains(d[fData['key']].toString()));
    });
    dataGridHelperStore.filteredDataSource.value = data;
    setFilteredDataSourceWithPaginate(filterData: false);
  }

  //===================================

  List<DataRow> rows(List dataSource, List<DataGridColumnModel2> columnList,
      BuildContext context) {
    List<DataRow> dataRow = [];
    for (int i = 0; i < dataSource.length; i++) {
      Map<String, dynamic> m = dataSource[i];
      List<DataCell> cellList = [];

      for (int cellIndex = 0; cellIndex < columnList.length; cellIndex++) {
        try {
          DataGridColumnModel2 x = columnList[cellIndex];
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
                    if (widget.onCellValueChange != null) {
                      widget.onCellValueChange!(CellUpdateValue2(
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
                    if (widget.onCellValueChange != null) {
                      widget.onCellValueChange!(CellUpdateValue2(
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
              // MoonTextInput(
              //   width: x.editorWidth ?? x.width ?? getAutoWidth(),
              //   style: TextStyle(fontSize: fontSize),
              //   initialValue: getTextValue(m[x.dataField], x.dataType),
              //   backgroundColor: mainStore.isDarkMode.value
              //       ? const Color.fromARGB(255, 124, 124, 124)
              //       : const Color.fromARGB(59, 146, 146, 146),
              //   activeBorderColor: Colors.transparent,
              //   autofocus: true,
              //   controller: dataGridHelperStore.editCellTextController,
              //   // onChanged: (value) {
              //   //   if (onCellValueChange != null) {
              //   //     EasyDebounce.debounce(
              //   //         uniqueKey, const Duration(milliseconds: 500), () {
              //   //       onCellValueChange!(CellUpdateValue(
              //   //           rowIndex: i,
              //   //           colIndex: cellIndex,
              //   //           colName: x.dataField,
              //   //           value: dataGridHelperStore
              //   //               .editCellTextController.text));
              //   //     });
              //   //   }
              //   // },
              //
              //   onEditingComplete: () {
              //     if (onCellValueChange != null) {
              //       onCellValueChange!(CellUpdateValue(
              //           rowIndex: i,
              //           colIndex: cellIndex,
              //           colName: x.dataField,
              //           value: dataGridHelperStore
              //               .editCellTextController.text));
              //     }
              //
              //     dataGridHelperStore.editableCell.clear();
              //     dataGridHelperStore.editCellTextController.text = '';
              //   },
              //   onTapOutside: (event) {
              //     //dataGridHelperStore.editableCell.removeWhere(
              //     //     (e) => e['row'] == i && e['cell'] == cellIndex);
              //     if (onCellValueChange != null) {
              //       onCellValueChange!(CellUpdateValue(
              //           rowIndex: i,
              //           colIndex: cellIndex,
              //           colName: x.dataField,
              //           value: dataGridHelperStore
              //               .editCellTextController.text));
              //     }
              //     dataGridHelperStore.editableCell.clear();
              //     dataGridHelperStore.editCellTextController.text = '';
              //   },
              // ),
            )
                : Container(
              width: x.width ?? getAutoHeadWidth(),
              alignment: x.textAlign == CellTextAlignment2.left
                  ? Alignment.centerLeft
                  : x.textAlign == CellTextAlignment2.right
                  ? Alignment.centerRight
                  : Alignment.center,
              padding: x.textAlign == CellTextAlignment2.right
                  ? const EdgeInsets.only(right: 8)
                  : x.textAlign == CellTextAlignment2.left
                  ? const EdgeInsets.only(left: 8)
                  : const EdgeInsets.symmetric(horizontal: 0),
              child: x.customCell != null
                  ? x.customCell!(CustomCellData2(
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
                  fontSize: widget.fontSize,
                ),
              ),
            ),
            onTap: () {
              if (widget.showSelection == false && x.editable == true) {
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
          color: !widget.showAlternateColor
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

  List getUniqueFilterList(int colIndex){
    return Set.from(widget.dataSource.map((d)=>d[widget.columnList[colIndex].dataField])).toList();
  }

  late DataGridHelperStore dataGridHelperStore =
  Get.put(DataGridHelperStore(), tag: widget.uniqueKey);

  void _getWidgetSizeAndPosition() {
    // Ensure the widget is mounted and has a RenderObject
    if (myTableKey.currentContext != null) {
      final RenderBox renderBox = myTableKey.currentContext!.findRenderObject() as RenderBox;
      dataGridHelperStore.footerWidth.value = renderBox.size.width;
    }
  }

  void initOwnWork({isForFilter=false}){
    if(isForFilter){
      List<int> indexList = [];
      widget.columnList.asMap().forEach((index,c){
        if(c.showFilter){
          indexList.add(index);
        }
      });
      dataGridHelperStore.filterShowIndex.value = indexList;
      if(widget.withPaginate && widget.dataSource.length>widget.defaultPageSize){
        setFilteredDataSourceWithPaginate(filterData: true);
      }
    } else{
      dataGridHelperStore.filteredDataSource.value = widget.dataSource;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getWidgetSizeAndPosition();
      horizontalScrollCon.addListener((){
        if(footerScrollCon.hasClients && footerScrollCon.position.hasPixels && horizontalScrollCon.offset-65 >= footerScrollCon.position.maxScrollExtent){
          footerScrollCon.jumpTo(footerScrollCon.position.maxScrollExtent);
        }
        else if(horizontalScrollCon.offset < 60){
          footerScrollCon.jumpTo(0);
        }
        else{
          footerScrollCon.jumpTo(horizontalScrollCon.offset - 65);
        }
      });

    });
  }

  void setFilteredDataSourceWithPaginate({filterData=false}){
    if(!filterData){
      dataGridHelperStore.isPaginate.value = (dataGridHelperStore.filteredDataSource.value.length > widget.defaultPageSize) &&  widget.withPaginate;
      dataGridHelperStore.totalPage.value = (dataGridHelperStore.filteredDataSource.value.length / widget.defaultPageSize).toInt();
    }else{
      dataGridHelperStore.isPaginate.value = (widget.dataSource.length > widget.defaultPageSize) &&  widget.withPaginate;
      dataGridHelperStore.totalPage.value = (widget.dataSource.length / widget.defaultPageSize).toInt();
    }
    if(filterData){
    dataGridHelperStore.filteredDataSource.value = widget.dataSource.sublist(dataGridHelperStore.currentPageIndex.value,dataGridHelperStore.currentPageIndex.value+ widget.defaultPageSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect((){
      if(mounted){
        initOwnWork();
      }
    },[widget.dataSource]);

    useEffect((){
      if(mounted){
        initOwnWork(isForFilter: true);
      }
    },[widget.columnList]);

    return Obx(() {
      return Column(
        children: [
          Expanded(
            child: Scrollbar(
              trackVisibility: widget.dataSource.isNotEmpty && GetPlatform.isDesktop,
              thumbVisibility: widget.dataSource.isNotEmpty && GetPlatform.isDesktop,
              interactive: true,
              controller: horizontalScrollCon,
              child: Scrollbar(
                trackVisibility:widget.dataSource.isNotEmpty && GetPlatform.isDesktop,
                thumbVisibility:widget.dataSource.isNotEmpty && GetPlatform.isDesktop,
                interactive: true,
                controller: verticalScrollCon,
                child: Container(
                  margin: GetPlatform.isDesktop ? EdgeInsets.only(right: 10,bottom: 10) : EdgeInsets.zero,
                  color: mainStore.isDarkMode.value ? Colors.black : Colors.white,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //Head====
                        // Container(
                        //   width: widget.width,
                        //   height: 50,
                        //   decoration: BoxDecoration(color: widget.headerColor),
                        //   child: Row(
                        //     // mainAxisSize: MainAxisSize.max,
                        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       ...widget.columnList.asMap().map((colIndex,e) => MapEntry(
                        //           colIndex
                        //         ,SizedBox(
                        //             width: e.width ?? getAutoHeadWidth(),
                        //             child: Container(
                        //               // color: Colors.red,
                        //                 padding: const EdgeInsets.symmetric(
                        //                     vertical: 15, horizontal: 5),
                        //                 alignment: e.textAlign == CellTextAlignment2.left
                        //                     ? Alignment.centerLeft
                        //                     : e.textAlign == CellTextAlignment2.right
                        //                     ? Alignment.centerRight
                        //                     : Alignment.center,
                        //                 child: Row(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: [
                        //                     TextHelper(
                        //                       text: e.title?.toUpperCase() ??
                        //                           e.dataField.toUpperCase(),
                        //                       isWrap: true,
                        //                         fontsize: widget.fontSize,
                        //                         color: e.headerFontColor ?? Colors.black,
                        //                         fontweight: FontWeight.w600,
                        //                       ),
                        //                     if(dataGridHelperStore.filterShowIndex.contains(colIndex))
                        //                     MoonPopover(
                        //                         show: dataGridHelperStore.filterOpenIndex.contains(colIndex.toString()),
                        //                         popoverPosition: colIndex.toString()=='0' ? MoonPopoverPosition.bottomRight : MoonPopoverPosition.bottomLeft,
                        //                         onTapOutside: (){
                        //                           dataGridHelperStore.filterOpenIndex.remove(colIndex.toString());
                        //                         },
                        //                         backgroundColor: mainStore.isDarkMode.value ? Colors.blueGrey.shade900 : Colors.white,
                        //                         content: Column(
                        //                           children: [
                        //                             SizedBox(
                        //                               width: 180,
                        //                               child: Row(
                        //                                 mainAxisAlignment: MainAxisAlignment.end,
                        //                                 children: [
                        //                                 TextHelper(text: "Select All",fontsize: 14,fontweight: FontWeight.w600,),
                        //                                 MoonCheckbox(
                        //                                   value: dataGridHelperStore.filteredData.indexWhere((t)=>t['key']==widget.columnList[colIndex].dataField)==-1 ? false:
                        //                                   dataGridHelperStore.filteredData.firstWhere((t)=>t['key']==widget.columnList[colIndex].dataField,orElse: ()=>{'value':[]})['value'].length== widget.dataSource.length ? true: null
                        //                                   ,
                        //                                   onChanged: (v){
                        //                                     if(v!=null && v==true) {
                        //                                       int filterIndex = dataGridHelperStore
                        //                                           .filteredData
                        //                                           .indexWhere((t) =>
                        //                                       t['key'] == widget
                        //                                           .columnList[colIndex]
                        //                                           .dataField);
                        //                                       if (filterIndex == 0) {
                        //                                         dataGridHelperStore
                        //                                             .filteredData.add({
                        //                                           'key': widget
                        //                                               .columnList[colIndex]
                        //                                               .dataField,
                        //                                           'value': widget.dataSource.map((m) =>m[widget.columnList[colIndex].dataField].toString()).toList()
                        //                                         });
                        //                                       }
                        //                                       else {
                        //                                         if(filterIndex!=-1){
                        //                                         dataGridHelperStore.filteredData.value.removeAt(filterIndex);}
                        //                                         dataGridHelperStore.filteredData.add({
                        //                                           'key': widget
                        //                                               .columnList[colIndex]
                        //                                               .dataField,
                        //                                           'value': widget.dataSource.map((m) => m[widget.columnList[colIndex].dataField].toString()).toList()
                        //                                         });
                        //                                       }
                        //
                        //                                     }else{
                        //                                       int filterIndex = dataGridHelperStore.filteredData.indexWhere((t) =>t['key'] == widget.columnList[colIndex].dataField);
                        //                                       dataGridHelperStore.filteredData.value.removeAt(filterIndex);
                        //                                     }
                        //                                     filterDataSource();
                        //                                   },activeColor: Colors.blue,tristate: true,
                        //
                        //                                 )
                        //                               ],),
                        //                             ),
                        //                             SizedBox(
                        //                                 width: 180,
                        //                                 child: Divider()),
                        //                             Container(
                        //                               width: 180,
                        //                               height: 150,
                        //                               child:
                        //                               ListView.builder(
                        //                                 padding:EdgeInsets.symmetric(vertical: 0,horizontal: 5),
                        //                                   itemCount: getUniqueFilterList(colIndex).length,
                        //                                   itemBuilder: (context,childIndex)=>
                        //                               GestureDetector(
                        //                                 onTap: (){
                        //                                   bool isChecked = isFilterItemSelected(widget.columnList[colIndex].dataField,getUniqueFilterList(colIndex)[childIndex]);
                        //                                   if(isChecked){
                        //                                     removeFilterItemSelect(widget.columnList[colIndex].dataField,getUniqueFilterList(colIndex)[childIndex]);
                        //                                   }else{
                        //                                     setFilterItemSelect(widget.columnList[colIndex].dataField,getUniqueFilterList(colIndex)[childIndex]);
                        //                                   }
                        //                                   filterDataSource();
                        //                                 },
                        //                                 child: Row(
                        //                                   children: [
                        //                                     StreamBuilder<Object>(
                        //                                       stream: dataGridHelperStore.filteredData.stream,
                        //                                       builder: (context, snapshot) {
                        //                                         return MoonCheckbox(
                        //                                           activeColor: Colors.blue,
                        //                                             onChanged: (v){
                        //                                               bool isChecked = isFilterItemSelected(widget.columnList[colIndex].dataField,getUniqueFilterList(colIndex)[childIndex]);
                        //                                               if(isChecked){
                        //                                                 removeFilterItemSelect(widget.columnList[colIndex].dataField,getUniqueFilterList(colIndex)[childIndex]);
                        //                                               }else{
                        //                                                 setFilterItemSelect(widget.columnList[colIndex].dataField,getUniqueFilterList(colIndex)[childIndex]);
                        //                                               }
                        //                                               filterDataSource();
                        //                                             },
                        //                                             value: isFilterItemSelected(widget.columnList[colIndex].dataField,getUniqueFilterList(colIndex)[childIndex]));
                        //                                       }
                        //                                     ),
                        //                                     Container(
                        //                                       child: TextHelper(text:getUniqueFilterList(colIndex)[childIndex].toString(),fontsize: 12,),
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                               )
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         child:  GestureDetector(
                        //                           onTap: (){
                        //                             if(dataGridHelperStore.filterOpenIndex.contains(colIndex.toString())) {
                        //                               dataGridHelperStore.filterOpenIndex
                        //                                   .remove(colIndex.toString());
                        //                             }else{
                        //                               dataGridHelperStore.filterOpenIndex.add(colIndex.toString());
                        //                             }
                        //                           },
                        //                           child: Container(
                        //                             width: 20,
                        //                             height: 20,
                        //                             color: Colors.transparent,
                        //                             child:  Icon(FontAwesomeIcons.filter,size: 16,color: dataGridHelperStore.filteredData.indexWhere((t)=>t['key']==widget.columnList[colIndex].dataField)==-1?Colors.black87:Colors.blue.shade700,),
                        //                           ),
                        //                         ))
                        //                   ],
                        //                 )))
                        //       )).values
                        //     ],
                        //   ),
                        // ),












                        // Grid======

                        widget.dataSource.isEmpty
                            ?  Expanded(
                          child: Center(
                            child: Text(widget.placeholder),
                          ),
                        )
                            : Expanded(
                              child: SizedBox(
                                width: widget.width,
                                child: TableView.builder(
                                    pinnedRowCount: 1,
                                    clipBehavior: Clip.hardEdge,
                                    columnCount: widget.columnList.length,
                                    // rowCount: widget.dataSource.length,
                                    rowCount: dataGridHelperStore.filteredDataSource.length+1,
                                    verticalDetails: ScrollableDetails(direction: AxisDirection.down, controller: verticalScrollCon),
                                    horizontalDetails:
                                    ScrollableDetails.horizontal(
                                        controller: horizontalScrollCon,
                                        ),
                                    // columns: columns(columnList, context),
                                    // rows: rows(dataSource, columnList, context)
                                    columnBuilder: (int index){
                                      if(widget.columnList[index].width!=null){
                                        return  TableSpan(
                                            extent: FixedSpanExtent(widget.columnList[index].width ?? 100)
                                        );
                                      }else{
                                        return TableSpan(
                                            extent: MinSpanExtent(FixedSpanExtent(500), FixedSpanExtent(getAutoWidth()))
                                          // FixedTableSpanExtent(widget.columnList[index].width??getAutoWidth())
                                        );
                                      }

                                    },
                                    rowBuilder: (int index)=>const TableSpan(extent: FixedSpanExtent(40),),
                                    cellBuilder: (BuildContext context, TableVicinity vicinity) =>TableViewCell(
                                        child: cellBuilding(vicinity,dataGridHelperStore.filteredDataSource.value))
                                ),
                              ),
                            ),

                        // Footer=======
                        if (widget.showFooter)
                          SingleChildScrollView(
                            controller: footerScrollCon,
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            child: Container(
                              // width: widget.width,
                              height: 40,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                  color: widget.footerColor,
                                  border: Border.all(
                                      width: 0,
                                      color: mainStore.isDarkMode.value
                                          ? const Color.fromARGB(255, 73, 73, 73)
                                          : const Color.fromARGB(255, 197, 196, 196))),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: widget.columnSpacing<8?2:widget.columnSpacing,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    for (int i = 0; i < widget.columnList.length; i++)
                                      SizedBox(
                                          width: widget.columnList[i].width ?? getAutoHeadWidth(),
                                          child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 10),
                                              alignment: widget.columnList[i].textAlign ==
                                                  CellTextAlignment2.left
                                                  ? Alignment.centerLeft
                                                  : widget.columnList[i].textAlign ==
                                                  CellTextAlignment2.right
                                                  ? Alignment.centerRight
                                                  : Alignment.center,
                                              child:
                                              widget.columnList[i].customSummaryCell==null ?
                                              TextHelper(
                                                text: !widget.columnList[i].withSummery
                                                    ? ''
                                                    : widget.columnList[i].summeryPrefix +
                                                    getSummeryValue(
                                                        i, widget.columnList[i].summeryType,dataGridHelperStore.filteredDataSource.value),
                                                textalign: widget.columnList[i].textAlign ==
                                                    CellTextAlignment2.right ? TextAlign.right : widget.columnList[i].textAlign ==
                                                    CellTextAlignment2.left ? TextAlign.left: TextAlign.center,
                                                fontsize: widget.fontSize,
                                                fontweight: FontWeight.w600,
                                                isWrap: true,

                                              ):
                                              widget.columnList[i].customSummaryCell!(!widget.columnList[i].withSummery
                                                  ? ''
                                                  : widget.columnList[i].summeryPrefix +
                                                  getSummeryValue(
                                                      i, widget.columnList[i].summeryType,dataGridHelperStore.filteredDataSource.value))
                                          ))
                                  ]),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5,),
          if(dataGridHelperStore.isPaginate.value)
          Row(
            spacing: 9,
            children: [
              TextHelper(text: "Pages : "),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 5,
                    children: [
                      for(int i=0;i<dataGridHelperStore.totalPage.value;i++)
                        GestureDetector(
                          onTap: (){
                            dataGridHelperStore.currentPageIndex.value = i;
                            setFilteredDataSourceWithPaginate(filterData: true);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: dataGridHelperStore.currentPageIndex.value==i ? Colors.blue : Colors.blue.shade300
                            ),
                            child: TextHelper(text: "${i + 1}",fontweight: FontWeight.w600,textalign: TextAlign.center,color:Colors.white),

                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5,),
        ],
      );
    });
  }
}

enum CellTextAlignment2 { center, left, right }

enum CellDataType2 { string, int, bool }

enum SummeryType2 { count, sum, none }

class CustomCellData2 {
  int rowIndex;
  int cellIndex;
  Map rowValue;
  dynamic cellValue;

  CustomCellData2(
      {required this.rowIndex,
        required this.cellIndex,
        required this.rowValue,
        required this.cellValue});
}

class DataGridColumnModel2 {
  final String dataField;
  final String? title;
  final bool? editable;
  final bool selectTextOnEditStart;
  final Color? headerFontColor;
  final double? width;
  final double? fontSize;
  final bool showFilter;
  final double? editorWidth;
  final TextInputType keyboard;
  final CellDataType2 dataType;
  final CellTextAlignment2 textAlign;
  final SummeryType2 summeryType;
  final bool withSummery;
  final String summeryPrefix;
  final Widget Function(CustomCellData2)? customCell;
  final Widget Function(String value)? customSummaryCell;
  DataGridColumnModel2(
      {required this.dataField,
        this.title,
        this.editable,
        this.width,
        this.fontSize,
        this.editorWidth,
        this.summeryType = SummeryType2.none,
        this.withSummery = false,
        this.showFilter = false,
        this.headerFontColor,
        this.selectTextOnEditStart = false,
        this.keyboard = TextInputType.text,
        this.summeryPrefix = '',
        this.customCell,
        this.customSummaryCell,
        required this.dataType,
        this.textAlign = CellTextAlignment2.center});
}
