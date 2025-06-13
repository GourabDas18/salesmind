import 'package:salesmind/Store/getXStore.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'helper.dart';

enum DateRngePickerType { yearly ,monthly, range }

class DateRangePickerHelper extends StatefulWidget {
  final Function(dynamic) onValueChange;
  final DateRange selectedDate;
  final DateTime initialDate;
  final String? label;
  final Widget? leading;
  final double? labelSize;
  final double? labelWidth;
  final EdgeInsetsGeometry? padding;
  final int? minimumDateRangeLength;
  final DateRngePickerType type;
  final Color? backgroundColor;
   DateRangePickerHelper(
      {super.key,
      required this.onValueChange,
      this.label,
      this.labelSize,
      this.labelWidth,
      this.padding,
        this.leading,
      this.minimumDateRangeLength,
      this.type = DateRngePickerType.range,
        this.backgroundColor,
      DateTime? initialDate,
      DateRange ? selectedDate
      })
      : initialDate = initialDate ?? DateTime.now(),
        selectedDate = selectedDate ?? DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  
  @override
  State<DateRangePickerHelper> createState() => _DateRangePickerHelperState();
}

class _DateRangePickerHelperState extends State<DateRangePickerHelper> {


  DateRange _localSelectedDate= DateRange(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
  MainStore mainStore = Get.find();
 @override
  void initState() {
    // TODO: implement initState
    if(widget.selectedDate != _localSelectedDate){
      _localSelectedDate = widget.selectedDate;
    }
    super.initState();
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    List<DateTime?> tempSelectedDates = [_localSelectedDate.start, _localSelectedDate.end];

    final result = await showDialog<List<DateTime?>>(
      context: context,
      builder: (context) {
        return Obx(
            ()=> AlertDialog(
            title:  TextHelper(text:'Select Date Range',color: mainStore.isDarkMode.value? Colors.grey : Colors.amber.shade900,fontweight: FontWeight.w600,),
            contentPadding: const EdgeInsets.all(4),
            backgroundColor: !mainStore.isDarkMode.value ? Colors.amber.shade50 : const Color.fromARGB(255, 22, 22, 22),
            content: SizedBox(
             width: MediaQuery.of(context).size.width * 0.9,
              // height: 420,
              child: CalendarDatePicker2WithActionButtons(
                config: CalendarDatePicker2WithActionButtonsConfig(
                  modePickersGap: 8,
                  centerAlignModePicker: true,
                  allowSameValueSelection: true,
                  calendarViewMode: widget.type==DateRngePickerType.range ? CalendarDatePicker2Mode.day : widget.type==DateRngePickerType.monthly ? CalendarDatePicker2Mode.month : CalendarDatePicker2Mode.year,
                  dayModeScrollDirection: Axis.horizontal,
                  calendarType:  widget.type==DateRngePickerType.range ?  CalendarDatePicker2Type.range : CalendarDatePicker2Type.single,
                  selectedDayHighlightColor: Colors.amber.shade800,
                  yearTextStyle:  TextStyle(color: mainStore.isDarkMode.value? Color.fromARGB(255, 195, 194, 194) : Colors.black87),
                  monthTextStyle: TextStyle(color: mainStore.isDarkMode.value? Color.fromARGB(255, 195, 194, 194) : Colors.black87),
                  dayTextStyle:  TextStyle(color: mainStore.isDarkMode.value? Color.fromARGB(255, 185, 184, 184) : Colors.black87),
                  selectedDayTextStyle: const TextStyle(color: Color.fromARGB(255, 21, 21, 21)),
                  disabledDayTextStyle: const TextStyle(color: Color.fromARGB(255, 110, 110, 110)),
                  weekdayLabelTextStyle: TextStyle(color:  mainStore.isDarkMode.value?  Color.fromARGB(255, 220, 225, 146): Colors.amber.shade900),
                  nextMonthIcon:  Icon(Icons.arrow_forward_ios, color: mainStore.isDarkMode.value?  Color.fromARGB(255, 213, 213, 221): Colors.black87, size: 12,),
                  lastMonthIcon:  Icon(Icons.arrow_back_ios, color: mainStore.isDarkMode.value?  Color.fromARGB(255, 213, 213, 221): Colors.black87, size: 12,),
                  selectedMonthTextStyle:  TextStyle(color: mainStore.isDarkMode.value?  Color.fromARGB(255, 213, 213, 221): Colors.black87),
                  selectedYearTextStyle:  TextStyle(color: mainStore.isDarkMode.value?  Color.fromARGB(255, 213, 213, 221): Colors.black87),
                  dynamicCalendarRows: true,
                  closeDialogOnCancelTapped: true,
                  closeDialogOnOkTapped: true,
                  controlsTextStyle:  TextStyle(color: Colors.amber.shade900),
                  okButton:  Text("OK", style: TextStyle(color: Colors.amber.shade900)),
                ),
                value: widget.type==DateRngePickerType.range ?  tempSelectedDates: [widget.initialDate],
                onValueChanged: (value) {
                  tempSelectedDates = value;
                },
                onCancelTapped: () {
                  Navigator.of(context).pop();
                },
                onOkTapped: () {
                  Navigator.of(context).pop(tempSelectedDates);
                  widget.type==DateRngePickerType.range ? tempSelectedDates.length==2 ? widget.onValueChange(DateRange(tempSelectedDates[0]!, tempSelectedDates[1]!)) : false :
                  widget.onValueChange(tempSelectedDates[0]);
                },
              ),

            ),

          ),
        );
      },
    );

    if (result != null && result.length==2) {
      setState(() {
        _localSelectedDate = DateRange(result[0]!,result[1]!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=> Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? const Color.fromARGB(255, 37, 37, 37),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color.fromARGB(73, 235, 219, 71)),
          ),
          child: Row(
          children: [
            if (widget.label != null || widget.leading != null)
              SizedBox(
                  width: widget.leading!=null ? null : widget.labelWidth ?? MediaQuery.of(context).size.width * 0.21,
                  child: widget.leading ?? Row(children: [
                    Text(
                      widget.label!,
                      softWrap: true,
                      style: TextStyle(fontSize: widget.labelSize),
                    ),
                    const Text(
                      " *",
                      style: TextStyle(color: Colors.red),
                    )
                  ])),
            const SizedBox(width: 8),
            Expanded(child: GestureDetector(
              onTap: () {_showDateRangePicker(context);},
              child: Text("${DateFormat("dd/MM/yyyy").format(_localSelectedDate.start)} - ${DateFormat("dd/MM/yyyy").format(_localSelectedDate.end)}", style:  TextStyle(fontSize: 13, color: mainStore.isDarkMode.value?  Color.fromARGB(255, 213, 213, 221): Colors.black87),),
            ))
          ],
                ),
        ),
    );
  }
}
