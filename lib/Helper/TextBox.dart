import 'package:salesmind/Store/getXStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum TextBoxStylingMode { outlined, underlined, none }

class TextBoxHelper extends StatelessWidget {
  MainStore mainStore = Get.find();
  final String? label;
  final bool readOnly;
  final bool decimalOnly;
  final bool autoFocus;
  final String? hintText;
  final bool? required;
  final String? deFaultValue;
  final double withPadding;
  final double? textFieldWidth;
  final double? labelWidth;
  final double? labelSize;
  final double? hintFontSize;
  final double? fontSize;
  final double borderRadius;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboard;
  final Function onValueChange;
  final Function? onFocusIn;
  final Color? backgroundColor;
  final Color? borderColor;
  final TextBoxStylingMode stylingMode;
  final TextEditingController textEditingController;
  TextBoxHelper(
      {super.key,
      this.label,
      required this.onValueChange,
      this.withPadding = 10,
      this.required,
      this.hintText,
      this.deFaultValue,
      this.readOnly = false,
      this.autoFocus = false,
      this.textFieldWidth,
      this.labelWidth,
      this.backgroundColor,
      this.borderColor,
      this.borderRadius=8,
      this.stylingMode = TextBoxStylingMode.outlined,
      this.labelSize,
      this.hintFontSize,
      this.fontSize,
      this.keyboard,
      this.minLines,
      this.maxLines,
      this.onFocusIn,
      this.decimalOnly = false,
      TextEditingController? textEditingController})
      : textEditingController = textEditingController ?? TextEditingController();

  addDefault(data) {
    if (deFaultValue != null) {
      textEditingController.text == ''
          ? textEditingController.text = deFaultValue ?? ''
          : false;
    }
  }



  @override
  Widget build(BuildContext context) {
    addDefault(deFaultValue);
    return Obx(
        ()=> Padding(
        padding: EdgeInsets.all(withPadding),
        child: Row(
          children: [
            if (label != null)
              SizedBox(
                  width: labelWidth ?? MediaQuery.of(context).size.width * 0.21,
                  child: Row(children: [
                    Text(
                      label!,
                      softWrap: true,
                      style: TextStyle(fontSize: labelSize),
                    ),
                    if (required != null && required == true)
                      const Text(
                        " *",
                        style: TextStyle(color: Colors.red),
                      )
                  ])),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  width: textFieldWidth,

                  child: TextField(
                    controller: textEditingController,
                    readOnly: readOnly,
                    style: TextStyle(
                        fontSize: fontSize ?? 12,
                        fontWeight:
                            readOnly ? FontWeight.w600 : FontWeight.normal),
                    autofocus: autoFocus,
                    maxLines: maxLines,
                    minLines: minLines,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) => onValueChange(value),
                    onTap: () {
                      if (onFocusIn != null) {
                        onFocusIn!();
                      }
                    },
                    inputFormatters:
                        decimalOnly ? [NumericInputFormatter()] : null,
                    keyboardType: decimalOnly
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : keyboard ?? TextInputType.text,
                    decoration: InputDecoration(
                      hintText: hintText ?? '',
                      hintStyle: TextStyle(
                          fontSize: hintFontSize ?? fontSize, color: Colors.grey),
                      filled: true,
                      fillColor: readOnly
                          ? backgroundColor ?? (mainStore.isDarkMode.value ? const Color.fromARGB(255, 45, 45, 42) : Colors.white)
                          : backgroundColor ?? (mainStore.isDarkMode.value ? const Color.fromARGB(255, 37, 37, 37) : Colors.white),

                      focusedBorder: stylingMode == TextBoxStylingMode.outlined
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                              borderSide: BorderSide(
                                  color: readOnly
                                      ? Colors.transparent
                                      : mainStore.isDarkMode.value ?
                                          const Color.fromARGB(255, 51, 48, 18) :
                                          Colors.amber.shade700
                              ),
                            )
                          : stylingMode == TextBoxStylingMode.underlined
                              ? UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                      color: readOnly
                                          ? Colors.transparent
                                          : mainStore.isDarkMode.value ?
                                      const Color.fromARGB(255, 51, 48, 18) :
                                      Colors.amber.shade700),
                                )
                              : InputBorder.none,
                      disabledBorder: stylingMode == TextBoxStylingMode.outlined
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                              borderSide: BorderSide(
                                  color: readOnly
                                      ? Colors.transparent
                                      : borderColor ??
                                          const Color.fromARGB(255, 94, 88, 29)),
                            )
                          : stylingMode == TextBoxStylingMode.underlined
                              ? UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                      color: readOnly
                                          ? Colors.transparent
                                          : borderColor ??
                                              const Color.fromARGB(
                                                  255, 94, 88, 29)),
                                )
                              : InputBorder.none,
                      enabledBorder: stylingMode == TextBoxStylingMode.outlined
                          ? OutlineInputBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                              borderSide: BorderSide(
                                  color: readOnly
                                      ? Colors.transparent
                                      : borderColor ??
                                          Colors.grey.shade500),
                            )
                          : stylingMode == TextBoxStylingMode.underlined
                              ? UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  borderSide: BorderSide(
                                      color: readOnly
                                          ? Colors.transparent
                                          : borderColor ??
                                          Colors.grey.shade500),
                                )
                              : InputBorder
                                  .none, // Optional: Adds a border for clarity
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // Regular expression to allow only digits and one decimal point.
    final regex = RegExp(r'^[0-9]*\.?[0-9]*$');

    if (regex.hasMatch(newText)) {
      // Ensure that there's only one decimal point
      if (newText.contains('.') &&
          newText.indexOf('.') != newText.lastIndexOf('.')) {
        return oldValue; // Reject input if multiple decimal points are entered
      }
      return newValue; // Accept the input
    } else {
      return oldValue; // Reject invalid input
    }
  }
}
