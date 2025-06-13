import 'dart:convert';

import '../Store/getXStore.dart';
import 'package:dio/dio.dart' as _dio;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


bool isJSONParsable(String data) {
  try {
    jsonDecode(data);
    return true;
  } catch (e) {
    return false;
  }
}

dynamic parseJSON(String data) {
  dynamic x = jsonDecode(data);
  return x;
}

String imageUrlMake(dynamic data) {
  String img = parseString(data: data, defaultValue: '');
  return img != '' &&
      (img.contains("jpg") ||
          img.contains("jpeg") ||
          img.contains("webp") ||
          img.contains("png"))
      ? "https://saleszing.info/saleszingdev/${img}"
      : '';
}

List<String> imageUrlListMake(dynamic data) {
  return data['imageList'] != null &&
      data['imageList'] is List &&
      data['imageList'].length > 0
      ? data['imageList']
      .map<String>(
        (m) =>
    m['documentUrl'] != null &&
        m['documentUrl'] != '' &&
        (m['documentUrl'].toString().contains("jpg") ||
            m['documentUrl'].toString().contains("jpeg") ||
            m['documentUrl'].toString().contains("webp") ||
            m['documentUrl'].toString().contains("png"))
        ? "https://saleszing.info/saleszingdev/${m['documentUrl'].toString()}"
        : '',
  )
      .toList()
      : [''];
}

enum AlertType { error, success, info }

class CustomResponse {
  bool success;
  dynamic data;
  Object? error;
  String response;
  _dio.Response<dynamic>? raw;
  CustomResponse({
    required this.success,
    this.data,
    this.error,
    required this.response,
    this.raw,
  });
}

// LABEL BOX WIDGET ====
class TextHelper extends StatelessWidget {
  final String text;
  final String? text2;
  final bool isWrap;
  final bool showRequired;
  final bool onlyBottomBorder;
  final bool withBorder;
  final double fontsize;
  final double? width;
  final FontWeight? fontweight;
  final TextAlign textalign;
  final Color? color;
  final Color? bgColor;
  final EdgeInsetsGeometry? padding;
  TextHelper({
    super.key,
    required this.text,
    this.width,
    this.text2,
    this.color,
    this.padding,
    this.showRequired = false,
    this.onlyBottomBorder = false,
    this.withBorder = false,
    this.isWrap = false,
    this.fontsize = 14,
    this.fontweight = FontWeight.w400,
    this.textalign = TextAlign.left,
    this.bgColor,
  });
  MainStore mainStore = Get.find();

  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        border: withBorder
            ? (onlyBottomBorder
            ? Border(
          bottom: BorderSide(
            color: mainStore.isDarkMode.value
                ? Color(0xFF2B2B2B)
                : Color(0xFFD6D6D6),
          ),
        )
            : Border.all(
          color: mainStore.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFD6D6D6),
        ))
            : Border.fromBorderSide(BorderSide.none),
      ),
      alignment: textalign == TextAlign.right
          ? Alignment.centerRight
          : textalign == TextAlign.center
          ? Alignment.center
          : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: RichText(
              textAlign: textalign,
              text: TextSpan(
                text: text,
                style: TextStyle(
                  color: color ??
                      (mainStore.isDarkMode.value
                          ? Color.fromARGB(255, 181, 179, 179)
                          : Colors.black),
                  fontSize: fontsize,
                  fontWeight: fontweight,
                ),
                children: [
                  if (showRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
          if (text2 != null)
            Text(
              "( $text2 )",
              softWrap: isWrap,
              textAlign: textalign,
              style: TextStyle(
                color: color ??
                    (mainStore.isDarkMode.value ? Colors.grey : Colors.black),
                fontSize: fontsize - 3,
                fontWeight: fontweight,
                overflow:
                isWrap ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }

}


class ButtonG extends StatelessWidget {
  final Widget? label;
  final double borderRadius;
  final Color? backgroundColor;
  final double width;
  final double height;
  final Widget? leading;
  final Function()? onTap;
   ButtonG({super.key,
   this.label,
     this.borderRadius = 4,
     this.backgroundColor,
     this.width=80,
     this.height=38,
     this.leading,
     this.onTap
   });

  @override
  Widget build(BuildContext context) {
    return  MoonFilledButton(
      label:label,
      borderRadius: BorderRadius.circular(borderRadius),
      backgroundColor: backgroundColor ?? Colors.grey.shade300,
      leading: leading,
      height: height,
      isFocusable: true,
      width: width,
      onTap: (){
        if(onTap!=null){
          onTap!();
        }
      },
    );
  }
}



// API CALL WIDGET ========

enum ApiCallType { get, post }

Future<CustomResponse> makeApiCall(
    String url,
    ApiCallType callType, {
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      _dio.FormData? formData,
      bool isFormData = false,
    }) async {
  _dio.Dio dio = _dio.Dio();
  MainStore mainStore = Get.find();
  Map<String, dynamic> defaultparam = {

  };
  if (queryParameters != null) {
    defaultparam.addEntries(queryParameters.entries);
  }
  try {
    if (callType == ApiCallType.get) {
      var v = await dio.get(
        "$url",
        queryParameters: defaultparam,
      );
      if (v is String) {
        return CustomResponse(
          success: false,
          response: "Error on api call",
          error: "Error! Internal server error",
        );
      }
      if (v.statusCode== 200) {
        // if (v.statusCode == 200 && v.data['statusCode'] == 200) {
        return CustomResponse(
          success: true,
          response: v.data['message'] ?? "Successfuly data fetched!",
          data: v.data['data'],
          raw: v,
        );
      } else {
        return CustomResponse(
          success: false,
          response: parseString(
            data: v.data['statusMessage'],
            defaultValue: "Error on API Call!",
          ),
          error:
          "Error! ${parseString(data: v.data['statusMessage'], defaultValue: "Error on API Call!")}",
          raw: v,
        );
      }
    } else {
      // FormData fromData = _dio.formD
      var v = await dio.post(
        "$url",
        data: isFormData ? formData : data,
        queryParameters: defaultparam,
        options: _dio.Options(
          headers: isFormData ? {"Content-Type": "multipart/form-data"} : {},
        ),
      );

      if (v is String || v.data is String) {
        return CustomResponse(
          success: false,
          response: "Error on api call",
          error: "Error! Internal server error $v",
          raw: v,
        );
      }
      if (v.statusCode== 200) {
        return CustomResponse(
          success: true,
          response: "Successful!",
          data: v.data['data'],
          raw: v,
        );
      } else {
        return CustomResponse(
          success: false,
          response: parseString(
            data: v.data['message'],
            defaultValue: "Error on API Call! $v",
          ),
          error:
          "Error! ${parseString(data: v.data['message'], defaultValue: "Error on API Call! $v")}",
          raw: v,
        );
      }
    }
  } on _dio.DioException catch (e) {
    print(e);
    if (e.response != null &&
        e.response!.data != null &&
        e.response!.data is Map) {
      return CustomResponse(
        success: false,
        response: "Error on ${e.response!.data['message']}",
        error: "Error on ${e.response!.data['message']}",
      );
    } else {
      return CustomResponse(
        success: false,
        response: "Error on api call",
        error: "Error! $e",
      );
    }
  } catch (e) {
    return CustomResponse(
      success: false,
      response: "Error on api call",
      error: "Error! $e",
    );
  }
}

// TEXT BOX WIDGET ========

class TextBoxHelperG extends StatefulWidget {
  final TextEditingController controller;
  final Function(String value)? onValueChange;
  final Function(String value)? onSubmitted;
  final Function()? onTapOutside;
  final double height;
  final double? width;
  final double? borderRadius;
  final double? fontSize;
  final bool readonly;
  final bool withBorder;
  final TextInputType keyboard;
  final Widget? leading;
  final Widget? trailing;
  final String? placeholder;
  final String? value;
  final String? labelText;
  final Color? labelTextBackgroundColor;
  final Color? backgroundColor;
  final Function? onTap;
  final bool selectTextOnFocus;
  final bool autofocus;
  final bool withDebounce;
  final bool showAlwaysLabel;
  final bool obscureText;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final MoonTextInputSize textInputSize;
  TextBoxHelperG({
    super.key,
    this.onValueChange,
    this.onTap,
    TextEditingController? controller,
    this.height = 35,
    this.borderRadius = 2,
    this.width,
    this.readonly = false,
    this.withBorder = true,
    this.withDebounce = false,
    this.showAlwaysLabel = false,
    this.selectTextOnFocus = false,
    this.obscureText = false,
    this.autofocus = false,
    this.focusNode,
    this.textAlign = TextAlign.left,
    this.keyboard = TextInputType.text,
    this.textInputSize = MoonTextInputSize.sm,
    this.labelText,
    this.labelTextBackgroundColor,
    this.backgroundColor,
    this.leading,
    this.trailing,
    this.placeholder,
    this.onSubmitted,
    this.onTapOutside,
    this.value,
    this.fontSize=13
  }): controller = controller ?? TextEditingController();
  MainStore mainStore = Get.find();
  @override
  State<TextBoxHelperG> createState() => _TextBoxHelperGState();
}

class _TextBoxHelperGState extends State<TextBoxHelperG> {
  bool isActive = false;
  late final FocusNode focusNode = widget.focusNode ?? FocusNode();
  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isActive = true;
        });
      } else {
        setState(() {
          isActive = false;
        });
      }
    });
    if(widget.value!=null && widget.value!=''){
      setState(() {
        widget.controller.text = parseString(data: widget.value, defaultValue: '');
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MoonFormTextInput(
          focusNode: focusNode,
          textInputSize: widget.textInputSize,
          style: TextStyle(
            // fontSize: 9
              fontSize: widget.fontSize
          ),
          height: widget.height,
          width: widget.width,
          readOnly: widget.readonly,
          leading: widget.leading,
          trailing: widget.trailing,
          hintText: widget.placeholder ?? (isActive ? '' : widget.labelText),
          controller: widget.controller,
          keyboardType: widget.keyboard,
          autofocus: widget.autofocus,
          obscureText: widget.obscureText,
          textAlign: widget.textAlign,
          borderRadius: BorderRadius.circular(widget.borderRadius??8),
          inputFormatters: <TextInputFormatter>[
            if (widget.keyboard == TextInputType.number)
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          onTap: () {
            if (widget.selectTextOnFocus) {
              widget.controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: widget.controller.value.text.length,
              );
            }
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          onSubmitted: (v) {
            if (widget.withDebounce) {
              EasyDebounce.debounce(
                'my-debouncerTextBox', // <-- An ID for this particular debouncer
                const Duration(milliseconds: 500), // <-- The debounce duration
                    () async {
                  if (widget.onSubmitted != null) {
                    widget.onSubmitted!(widget.controller.text);
                  }
                }, // <-- The target method
              );
            } else {
              if (widget.onSubmitted != null) {
                widget.onSubmitted!(widget.controller.text);
              }
            }
          },
          onChanged: (value) {
            if (widget.withDebounce) {
              EasyDebounce.debounce(
                'my-debouncerTextBox', // <-- An ID for this particular debouncer
                const Duration(milliseconds: 500), // <-- The debounce duration
                    () async{
                      if(widget.onValueChange!=null){
                        widget.onValueChange!(value);
                      }
                    }, // <-- The target method
              );
            } else {
              if(widget.onValueChange!=null){
                widget.onValueChange!(value);
              }
            }
          },
          onTapOutside: (v) {
            focusNode.unfocus();
            setState(() {
              isActive = false;
            });
            if(widget.onTapOutside!=null){
              widget.onTapOutside!();
            }

          },
          textColor:
          widget.mainStore.isDarkMode.value
              ? Colors.grey[400]
              : Colors.grey[900],
          backgroundColor:
          widget.mainStore.isDarkMode.value
              ? Colors.grey[900]
              : widget.backgroundColor ?? Colors.grey[50],
          activeBorderColor:
          !widget.withBorder
              ? Colors.transparent : Colors.amber,
              // : widget.mainStore.isDarkMode.value
              // ? Colors.grey[800]
              // : Colors.grey[700],
          inactiveBorderColor:
          !widget.withBorder
              ? Colors.transparent
              : widget.mainStore.isDarkMode.value
              ? Colors.grey[800]
              : Colors.grey[400],
        ),
        if ((widget.showAlwaysLabel || isActive||widget.controller.text.isNotEmpty) &&
            widget.labelText != null &&
            widget.labelText != '')
          Positioned(
            top: -11,
            left: 15,
            child: Container(
              decoration: BoxDecoration(
                color:
                widget.mainStore.isDarkMode.value
                    ? Colors.grey[800]
                    : widget.labelTextBackgroundColor ?? Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextHelper(
                text:" ${widget.labelText} ",
                fontsize: 14,
                color: isActive ? Colors.amber.shade700 : Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}

class TextAreaBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String value) onValueChange;
  final Function(String value)? onSubmitted;
  final double height;
  final double? width;
  final bool readonly;
  final bool withBorder;
  final TextInputType keyboard;
  final Widget? leading;
  final Widget? trailing;
  final String? placeholder;
  final String? initialValue;
  final String? labelText;
  final Color? labelTextBackgroundColor;
  final Color? backgroundColor;
  final Function? onTap;
  final bool selectTextOnFocus;
  final bool autofocus;
  final bool withDebounce;
  final bool showAlwaysLabel;
  final bool obscureText;
  final TextAlign textAlign;
  final FocusNode? focusNode;
  final double fontSize;
  final BorderRadiusGeometry? borderRadius;
  TextAreaBox({
    super.key,
    required this.onValueChange,
    this.onTap,
    required this.controller,
    this.height = 40,
    this.width=100,
    this.readonly = false,
    this.withBorder = true,
    this.withDebounce = false,
    this.showAlwaysLabel = false,
    this.selectTextOnFocus = false,
    this.obscureText = false,
    this.autofocus = false,
    this.focusNode,
    this.textAlign = TextAlign.left,
    this.keyboard = TextInputType.text,
    this.fontSize = 13,
    this.labelText,
    this.labelTextBackgroundColor,
    this.backgroundColor,
    this.leading,
    this.trailing,
    this.placeholder,
    this.borderRadius,
    this.onSubmitted,
    this.initialValue,
  });
  MainStore mainStore = Get.find();
  @override
  _TextAreaBoxState createState() => _TextAreaBoxState();
}

class _TextAreaBoxState extends State<TextAreaBox> {
  bool isActive = false;
  late final FocusNode focusNode = widget.focusNode ?? FocusNode();
  @override
  void initState() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isActive = true;
        });
      } else {
        setState(() {
          isActive = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          MoonTextArea(
            focusNode: focusNode,
            textStyle: TextStyle(fontSize: widget.fontSize),
            height: widget.height,
            readOnly: widget.readonly,
            // leading: widget.leading,
            // trailing: widget.trailing,
            hintText: widget.placeholder ?? (isActive ? '' : widget.labelText),
            controller: widget.controller,
            initialValue: widget.initialValue,
            // keyboardType: widget.keyboard,
            autofocus: widget.autofocus,
            // obscureText: widget.obscureText,
            textAlign: widget.textAlign,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(5),
            inputFormatters: <TextInputFormatter>[
              if (widget.keyboard == TextInputType.number)
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            onTap: () {
              if (widget.selectTextOnFocus) {
                widget.controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: widget.controller.value.text.length,
                );
              }
              if (widget.onTap != null) {
                widget.onTap!();
              }
            },
            onSubmitted: (v) {
              if (widget.withDebounce) {
                EasyDebounce.debounce(
                  'my-debouncerTextBox', // <-- An ID for this particular debouncer
                  const Duration(milliseconds: 500), // <-- The debounce duration
                      () async {
                    if (widget.onSubmitted != null) {
                      widget.onSubmitted!(widget.controller.text);
                    }
                  }, // <-- The target method
                );
              } else {
                if (widget.onSubmitted != null) {
                  widget.onSubmitted!(widget.controller.text);
                }
              }
            },
            onChanged: (value) {
              if (widget.withDebounce) {
                EasyDebounce.debounce(
                  'my-debouncerTextBox', // <-- An ID for this particular debouncer
                  const Duration(milliseconds: 500), // <-- The debounce duration
                      () async =>
                      widget.onValueChange(value), // <-- The target method
                );
              } else {
                widget.onValueChange(value);
              }
            },
            onTapOutside: (v) {
              focusNode.unfocus();
              setState(() {
                isActive = false;
              });
            },
            textColor:
            widget.mainStore.isDarkMode.value
                ? Colors.grey[400]
                : Colors.grey[900],
            backgroundColor:
            widget.mainStore.isDarkMode.value
                ? Colors.grey[900]
                : widget.backgroundColor ?? Colors.grey[50],
            activeBorderColor:
            !widget.withBorder
                ? Colors.transparent
                : widget.mainStore.isDarkMode.value
                ? Colors.grey[800]
                : Colors.grey[700],
            inactiveBorderColor:
            !widget.withBorder
                ? Colors.transparent
                : widget.mainStore.isDarkMode.value
                ? Colors.grey[800]
                : Colors.grey[400],
          ),
          if ((widget.showAlwaysLabel || isActive) &&
              widget.labelText != null &&
              widget.labelText != '')
            Positioned(
              top: -11,
              left: 15,
              child: Container(
                decoration: BoxDecoration(
                  color:
                  widget.mainStore.isDarkMode.value
                      ? Colors.grey[800]
                      : widget.labelTextBackgroundColor ?? Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  " ${widget.labelText} ",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AsyncSelectStore extends GetxController {
  RxBool show = false.obs;
  RxBool loading = false.obs;
  RxList contentList = [].obs;
  RxInt selectedId = (-1).obs;
}

class AsyncSelect extends StatefulWidget {
  final String url;
  final String uniqueKey;
  final Map<String, dynamic>? queryParameters;
  final String keyValue;
  final String? placeHolder;
  final String displayValue;
  final String serachValue;
  final String? labelText;
  final Widget? leading;
  final Widget? trailing;
  final Color? labelTextBackgroundColor;
  final Color? backgroundColor;
  final Function(dynamic value) onValueChange;
  final Function? onTextClear;
  final double maxHeight;
  final double contentwidth;
  final double parentHeight;
  final double listHeight;
  final bool withClearText;
  final bool autofocus;
  final bool withBorder;
  final bool showAlwaysLabel;
  final Map<String, dynamic>? value;
  final MoonDropdownAnchorPosition dropDownPosition;
  final Function(Function disposeFunction)? getAsyncDispose;
  final Widget Function(Map<String, dynamic> data)? customComponent;

  AsyncSelect({
    super.key,
    required this.url,
    required this.onValueChange,
    required this.uniqueKey,
    this.queryParameters,
    this.keyValue = 'id',
    this.serachValue = 'q',
    this.maxHeight = 300,
    this.listHeight = 45,
    this.contentwidth = 200,
    this.parentHeight = 50,
    this.leading,
    this.trailing,
    this.placeHolder,
    this.labelText,
    this.withClearText = false,
    this.autofocus = false,
    this.showAlwaysLabel = false,
    this.onTextClear,
    this.value,
    this.labelTextBackgroundColor,
    this.backgroundColor,
    this.withBorder = false,
    this.getAsyncDispose,
    this.customComponent,
    this.dropDownPosition = MoonDropdownAnchorPosition.bottom,
    this.displayValue = 'name',
  });

  @override
  State<AsyncSelect> createState() => _AsyncSelectState();
}

class _AsyncSelectState extends State<AsyncSelect> {
  MainStore mainStore = Get.find();

  TextEditingController textEditingController = TextEditingController();

  late AsyncSelectStore asyncSelectStore = Get.put(
    AsyncSelectStore(),
    tag: widget.uniqueKey,
  );

  void hideList() {
    asyncSelectStore.show.value = false;
  }

  Future callContents(String text, BuildContext context) async {
    if (textEditingController.text == ' ' ||
        textEditingController.text == '  ' ||
        textEditingController.text == '')
      return;
    try {
      asyncSelectStore.loading.value = true;
      CustomResponse resp = await makeApiCall(
        widget.url + text,
        ApiCallType.get,
        queryParameters: {
          'q': textEditingController.text,
          ...?widget.queryParameters,
        },
      );

      if (resp.success) {
        asyncSelectStore.contentList.value = resp.data;
        asyncSelectStore.show.value = true;
        asyncSelectStore.loading.value = false;
      } else {
        asyncSelectStore.loading.value = false;

        showAlert("Error! ${resp.response}", AlertType.error, context);
      }
    } catch (e) {
      showAlert("Error! $e", AlertType.error, context);
      asyncSelectStore.loading.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.getAsyncDispose != null) {
      widget.getAsyncDispose!(hideList);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value != null) {
      textEditingController.text = widget.value![widget.displayValue] ?? '';
    }

    return Obx(() {
      return MoonDropdown(
        show: asyncSelectStore.show.value,
        constrainWidthToChild: true,
        maxWidth: widget.contentwidth,
        maxHeight:
        asyncSelectStore.contentList.isEmpty
            ? 50
            : widget.listHeight >= widget.maxHeight
            ? widget.listHeight + 40
            : asyncSelectStore.contentList.isEmpty
            ? 60
            : asyncSelectStore.contentList.length * 35 > widget.maxHeight
            ? widget.maxHeight
            : asyncSelectStore.contentList.length * 35 > 45
            ? asyncSelectStore.contentList.length * 35
            : 45,
        minHeight:
        asyncSelectStore.contentList.isEmpty ? 40 : widget.listHeight,
        transitionCurve: Curves.decelerate,
        dropdownAnchorPosition: widget.dropDownPosition,
        backgroundColor:
        mainStore.isDarkMode.value
            ? const Color.fromARGB(255, 15, 15, 15)
            : Colors.grey[50],
        onTapOutside: () {
          dynamic value = asyncSelectStore.contentList.firstWhereOrNull(
                (t) => t[widget.keyValue] == asyncSelectStore.selectedId,
          );
          asyncSelectStore.show.value = false;
          if (value != null) {
            textEditingController.text = value?[widget.displayValue];
          } else {
            textEditingController.text = '';
          }
          asyncSelectStore.show.value = false;
        },
        content:
        asyncSelectStore.contentList.isEmpty
        // ignore: avoid_unnecessary_containers
            ? const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [const Text("No data found")],
        )
            : SizedBox(
          height:
          asyncSelectStore.contentList.isEmpty
              ? 60
              : asyncSelectStore.contentList.length * 35 >
              widget.maxHeight
              ? widget.maxHeight
              : asyncSelectStore.contentList.length * 35 > 45
              ? asyncSelectStore.contentList.length * 35
              : 45,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: asyncSelectStore.contentList.length,
            itemBuilder:
                (context, index) => GestureDetector(
              onTap: () {
                dynamic c = asyncSelectStore.contentList[index];
                asyncSelectStore.selectedId.value =
                c[widget.keyValue];
                // textEditingController.clear();
                // if (onTextClear != null) {
                //   onTextClear!();
                // }
                dynamic value = asyncSelectStore.contentList
                    .firstWhereOrNull(
                      (t) =>
                  t[widget.keyValue] == c[widget.keyValue],
                );
                textEditingController.text =
                    value?[widget.displayValue] ?? '';
                asyncSelectStore.show.value = false;
                if (value != null) {
                  widget.onValueChange(value);
                }
              },
              child:
              widget.customComponent != null
                  ? widget.customComponent!(
                asyncSelectStore.contentList[index],
              )
                  : Container(
                margin: const EdgeInsets.only(bottom: 4),
                width: widget.contentwidth,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  color:
                  mainStore.isDarkMode.value
                      ? index % 2 != 0
                      ? Colors.grey[900]
                      : const Color.fromARGB(
                    255,
                    41,
                    40,
                    40,
                  )
                      : index % 2 != 0
                      ? Colors.grey[200]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextHelper(
                    text: parseString(
                      data:
                      asyncSelectStore
                          .contentList[index]?[widget
                          .displayValue],
                      defaultValue: 'No text found!',
                    ),
                    isWrap: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        child: TextBoxHelperG(
          height: widget.parentHeight,
          controller: textEditingController,
          leading: widget.leading,
          labelTextBackgroundColor: widget.labelTextBackgroundColor,
          autofocus: widget.autofocus,
          trailing:
          asyncSelectStore.loading.value
              ? Center(
            child: Transform.scale(
              scale: 0.5,
              child: MoonCircularLoader(
                backgroundColor:
                mainStore.isDarkMode.value
                    ? Colors.black
                    : Colors.grey[300],
                color: Colors.blue,
              ),
            ),
          )
              : widget.withClearText
              ? GestureDetector(
            onTap: () {
              textEditingController.clear();
              if (widget.onTextClear != null) {
                widget.onTextClear!();
              }
            },
            child: const MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Icon(
                MoonIcons.controls_close_24_regular,
                size: 18,
              ),
            ),
          )
              : widget.trailing,
          placeholder: widget.placeHolder,
          showAlwaysLabel: widget.showAlwaysLabel,
          labelText: widget.labelText,
          withBorder: widget.withBorder,
          backgroundColor: widget.backgroundColor,
          onValueChange: (value) async {
            EasyDebounce.debounce(
              'my-debouncer', // <-- An ID for this particular debouncer
              const Duration(milliseconds: 500), // <-- The debounce duration
                  () async => await callContents(
                "?${widget.serachValue}=$value",
                context,
              ), // <-- The target method
            );
            // setState(() {
            //   show = true;
            // });
          },
        ),
      );
    });
  }
}

class DatePickerHelper extends StatefulWidget {
  final Function(String date)? onValueChange;
  final DateTime? value;
  final String? dateFormat;
  final Color? backgroundColor;
  final bool withBorder;
  final bool readOnly;
  final Widget? leading;
  const DatePickerHelper({
    super.key,
    this.onValueChange,
    this.dateFormat = 'yyyy-MM-dd',
    this.value,
    this.leading,
    this.backgroundColor,
    this.withBorder = false,
    this.readOnly = false,
  });

  @override
  State<DatePickerHelper> createState() => _DatePickerHelperState();
}

class _DatePickerHelperState extends State<DatePickerHelper> {
  TextEditingController textEditingController = TextEditingController();
  DateTime? d;
  MainStore mainStore = Get.find();
  @override
  void initState() {
    setState(() {
      if (widget.value != null) {
        d = widget.value;
        textEditingController.text = DateFormat(
          widget.dateFormat,
        ).format(widget.value!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=> TextBoxHelperG(
        onTap: () async {
          if(widget.readOnly){
            return;
          }
          DateTime? dd = await showDatePicker(
            context: context,
            firstDate: DateTime.now().subtract(const Duration(days: 0)),
            lastDate: DateTime(2050),
          );

          if (dd != null && widget.onValueChange != null) {
            setState(() {
              d = dd;
              textEditingController.text = DateFormat(
                widget.dateFormat,
              ).format(dd);
            });
            widget.onValueChange!(DateFormat(widget.dateFormat).format(dd));
          }
        },
        onValueChange: (v) {},
        controller: textEditingController,
        readonly: widget.readOnly,
        withBorder: widget.withBorder,
        backgroundColor: widget.backgroundColor ?? (mainStore.isDarkMode.value ? Colors.black87 : Colors.white ),
        height: 50,
        leading: widget.leading,
      ),
    );
  }
}


class DropDownStore extends GetxController{
  RxList<Map<String,dynamic>> list = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> filteredList = <Map<String,dynamic>>[].obs;
  RxList<Map<String,dynamic>> selectedList = <Map<String,dynamic>>[].obs;
  RxString multiSelectionExpandId = ''.obs;
  Rx<TextEditingController> textController = TextEditingController().obs;
  RxBool showList = false.obs;
  RxMap<String,dynamic> selectedValue = <String,dynamic>{}.obs;
}

class DropDownHelperG extends StatefulWidget {
  final String uniqueKey;
  final String displayKey;
  final String treeViewkey;
  final String valueKey;
  final String placeHolder;
  final Widget? leading;
  final Widget? trailing;
  final double rowHeight;
  final Widget Function(Map<String,dynamic> data)? customRow;
  final double listHeight;
  final double height;
  final double width;
  final double fontSize;
  final double? borderRadius;
  final Alignment followerAnchor;
  final MoonDropdownAnchorPosition dropDownPosition;
  final List<Map<String,dynamic>> items;
  final Function(Map<String,dynamic> value)? onValueChange;
  final Function(List<Map<String,dynamic>> value)? onMultiValueChange;
  final Map<String,dynamic>? value;
  final List<Map<String,dynamic>>? multiSelectValue;
  final bool showClearText;
  final bool isMultiSelect;
  final bool isSearchEnable;
  final Color? backgroundColor;
  DropDownHelperG({
    super.key,
    required this.uniqueKey,
    this.leading,
    this.trailing,
    this.value,
    this.multiSelectValue,
    this.borderRadius,
    this.displayKey='name',
    this.treeViewkey='',
    this.valueKey='id',
    this.placeHolder='Search...',
    required this.items,
    this.rowHeight = 50,
    this.width = 200,
    this.height = 40,
    this.fontSize=13,
    this.customRow,
    this.listHeight = 200,
    this.showClearText = true,
    this.isSearchEnable = false,
    this.isMultiSelect = false,
    this.backgroundColor,
    this.onValueChange,
    this.onMultiValueChange,
    this.followerAnchor = Alignment.topCenter,
    this.dropDownPosition = MoonDropdownAnchorPosition.bottom,
  });

  @override
  State<DropDownHelperG> createState() => _DropDownHelperGState();
}

class _DropDownHelperGState extends State<DropDownHelperG> {
  late DropDownStore dropDownStore = Get.put(DropDownStore(),tag: widget.uniqueKey);
  MainStore mainStore =Get.find();
  @override
  void initState() {
    // TODO: implement initState
    dropDownStore.list.value = widget.items;
    dropDownStore.filteredList.value = widget.items;
    dropDownStore.selectedList.value = widget.multiSelectValue??[];

    if(widget.value!=null && widget.isMultiSelect==false){
      dropDownStore.textController.value.text = parseString(data: widget.value![widget.displayKey], defaultValue: '');
    }
    super.initState();
  }

  Widget multiSelectWidget(Map<String,dynamic> data){
    return Obx(()=>GestureDetector(
      onTap: (){
        if(dropDownStore.selectedList.any((t)=>t[widget.valueKey]==data[widget.valueKey])){
          dropDownStore.selectedList.removeWhere((t)=>t[widget.valueKey]==data[widget.valueKey]);
        }else{
          dropDownStore.selectedList.add(data);
        }
        widget.onMultiValueChange!(dropDownStore.selectedList.value);
      },
      child: Row(
        spacing: 2,
        children: [
          SizedBox(
            width: 50,
            child: MoonCheckbox(
                activeColor: Colors.blue[50],
                checkColor: Colors.blue[800],
                value: dropDownStore.selectedList.any((t)=>t[widget.valueKey]==data[widget.valueKey]), onChanged: (v){
              if(dropDownStore.selectedList.any((t)=>t[widget.valueKey]==data[widget.valueKey])){
                dropDownStore.selectedList.removeWhere((t)=>t[widget.valueKey]==data[widget.valueKey]);
              }else{
                dropDownStore.selectedList.add(data);
              }
              widget.onMultiValueChange!(dropDownStore.selectedList.value);
            }),
          ),
          Expanded(child: TextHelper(text:data[widget.displayKey], ))
        ],
      ),
    ));
  }

  Widget multiSelectWidgetChild(Map<String,dynamic> data){
    return GestureDetector(
      onTap: (){
        dropDownStore.showList.value= true;
      },
      onDoubleTap: (){
        dropDownStore.selectedList.removeWhere((t)=>t[widget.valueKey]==data[widget.valueKey]);
        if(widget.onMultiValueChange!=null){
          widget.onMultiValueChange!(dropDownStore.selectedList.value);
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(15)
              ),
              child: TextHelper(text: data[widget.displayKey],fontsize: widget.fontSize,)),
          Positioned(
              right: -5,
              top:-5,
              child: GestureDetector(
                onTap: (){
                  dropDownStore.selectedList.removeWhere((t)=>t[widget.valueKey]==data[widget.valueKey]);
                  if(widget.onMultiValueChange!=null){
                    widget.onMultiValueChange!(dropDownStore.selectedList.value);
                  }
                },
                child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.grey[500],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Icon(FontAwesomeIcons.xmark,size: 12,)),
              )
          )

        ],
      ),
    );
  }

  Widget treeViewWidget(Map<String,dynamic> data){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: MoonAccordion(
        shadows: [],
        label: TextHelper(text: data['label']),children: [
        for(Map<String,dynamic> m in data['list'])
          multiSelectWidget(m)
      ],),
    );
  }

  Widget singleSelectWidget(Map<String,dynamic> data,int index){
    return GestureDetector(
        onTap: (){
          dropDownStore.showList.value=false;
          if(widget.onValueChange!=null){
            widget.onValueChange!(data);
            dropDownStore.selectedValue.value = makeMapSerialize(data);
            dropDownStore.textController.value.text = parseString(data: dropDownStore.selectedValue[widget.displayKey], defaultValue: '');

          }
        },
        child:
        widget.customRow!= null ?
        widget.customRow!(makeMapSerialize(data))
            : Container(
          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: index.isEven ?
              mainStore.isDarkMode.value
                  ? Colors.grey[900]
                  : Colors.grey[200]
                  : mainStore.isDarkMode.value
                  ? Colors.black87
                  : Colors.white
          ),
          child: TextHelper(
              isWrap: true,
              fontsize: widget.fontSize,
              text: data[widget.displayKey]),));
  }

  Widget treeViewWidgetSingleSelect(Map<String,dynamic> data){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 3),
      child: MoonAccordion(
        shadows: [],
        label: TextHelper(text: data['label']),children: [
        ...(makeListSerialize(data['list']).asMap().map((index,value)=>MapEntry(index,Container(
            margin: EdgeInsets.only(left: 6),
            padding: EdgeInsets.all(6),
            child:
            singleSelectWidget(makeListSerialize(data['list'])[index],index)))
        ).values.toList())
        // for(Map<String,dynamic> m in data['list'])
        //   multiSelectWidget(m)
      ],),
    );
  }

  List<Map<String,dynamic>> listMaker(List<Map<String,dynamic>> list){
    if(widget.treeViewkey==''){
      return list;
    }else{
      List<Map<String,dynamic>> labels = [];
      list.forEach((l){
        int index = labels.indexWhere((w)=>w['label']==l[widget.treeViewkey]);
        if(index==-1){
          labels.add({
            'label':l[widget.treeViewkey],
            'list': [l]
          });
        }else{
          labels[index]['list'].add(l);
        }
      });
      return labels;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
        SizedBox(
          height: widget.isMultiSelect ? 50 : widget.height,
          width: widget.width,
          child: MoonDropdown(
              followerAnchor: widget.followerAnchor,
              dropdownAnchorPosition: widget.dropDownPosition,
              show: dropDownStore.showList.value,
              constrainWidthToChild: true,
              minHeight: 50,
              backgroundColor: mainStore.isDarkMode.value ? Colors.black87 : Colors.white,
              onTapOutside: (){
                dropDownStore.showList.value=false;
              },
              maxHeight: (widget.rowHeight * dropDownStore.filteredList.length) < widget.listHeight ? (widget.rowHeight * dropDownStore.filteredList.length) > 40 ? (widget.rowHeight * dropDownStore.filteredList.length) : 55 : widget.listHeight ,
              content: ListView.builder(
                  padding: EdgeInsets.all(2),
                  itemCount: listMaker(dropDownStore.filteredList.value).length,
                  itemBuilder: (context,index)=>
                  widget.isMultiSelect ?
                  widget.treeViewkey!=''
                      ?  treeViewWidget(listMaker(dropDownStore.filteredList.value)[index])
                      : multiSelectWidget(dropDownStore.filteredList.value[index])
                      :
                  widget.treeViewkey!=''
                      ?  treeViewWidgetSingleSelect(listMaker(dropDownStore.filteredList.value)[index])
                      :
                  singleSelectWidget(dropDownStore.filteredList.value[index],index)
              ),
              child:
              widget.isMultiSelect ?
              dropDownStore.selectedList.length>0 ?
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        for(Map<String,dynamic> m in dropDownStore.selectedList.value)
                          multiSelectWidgetChild(m)
                      ],
                    ),
                  ))
                  : MoonButton(
                onTap: (){
                  dropDownStore.showList.value=true;
                },
                backgroundColor: Colors.black12,
                label: TextHelper(text:'Choose option'),
              )
                  : TextBoxHelperG(
                  leading: widget.leading ?? Icon(MoonIcons.generic_search_24_light),
                  readonly: !widget.isSearchEnable,
                  placeholder: widget.placeHolder,
                  fontSize: widget.fontSize,
                  backgroundColor: widget.backgroundColor??Colors.grey[50],
                  height: widget.height,
                  trailing: widget.trailing ?? (widget.showClearText ?
                  GestureDetector(
                      onTap: (){
                        dropDownStore.textController.value.text='';
                        dropDownStore.filteredList.value = dropDownStore.list.value;
                        if(widget.onValueChange!=null){
                          widget.onValueChange!({});
                          dropDownStore.selectedValue.value = makeMapSerialize({});
                        }
                        return;
                      },
                      child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Icon(FontAwesomeIcons.xmark,size: 14,))): null),
                  onTapOutside: (){
                    // dropDownStore.showList.value=false;
                  },
                  onTap: (){
                    dropDownStore.showList.value=true;
                  },
                  onValueChange: (v){
                    EasyDebounce.debounce(widget.uniqueKey, const Duration(milliseconds: 700), (){
                      if(v==''){
                        dropDownStore.filteredList.value = dropDownStore.list.value;
                        if(widget.onValueChange!=null){
                          widget.onValueChange!({});
                          dropDownStore.selectedValue.value = makeMapSerialize({});
                        }
                        return;
                      }
                      List<Map<String,dynamic>> list =   dropDownStore.list.value;
                      dropDownStore.filteredList.value = list.where((t)=>t[widget.displayKey].toString().toLowerCase().contains(v.toLowerCase())).toList();

                    });
                  },
                  controller: dropDownStore.textController.value)

          ),
        )

    );
  }
}

// SELECT BOX WIDGET ========

class SelectItem {
  final int id;
  final dynamic value;
  SelectItem({required this.id, required this.value});
}

class SelectBoxHelperG extends StatefulWidget {
  final List<SelectItem> items;
  final int? value;
  final List<int> valueList;
  final bool isMultiValue;
  final Function(int value) onValueChange;
  final Function(List<int> valuelist)? onMultiValueChange;
  final bool isWrap;
  const SelectBoxHelperG({
    super.key,
    required this.items,
    this.isWrap = false,
    this.isMultiValue = false,
    this.value = -1,
    this.valueList = const [-1],
    this.onMultiValueChange,
    required this.onValueChange,
  });

  @override
  State<SelectBoxHelperG> createState() => _SelectBoxHelperState();
}

class _SelectBoxHelperState extends State<SelectBoxHelperG> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child:
      widget.isWrap
          ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...widget.items.map(
                    (m) => GestureDetector(
                  onTap: () {
                    if (widget.isMultiValue &&
                        widget.onMultiValueChange != null) {
                      if (widget.valueList.contains(m.id)) {
                        widget.valueList.removeWhere((t) => t == m.id);
                        widget.onMultiValueChange!(widget.valueList);
                      } else {
                        widget.onMultiValueChange!([
                          ...widget.valueList,
                          m.id,
                        ]);
                      }
                    } else {
                      if (widget.value == m.id) {
                        widget.onValueChange(-1);
                      } else {
                        widget.onValueChange(m.id);
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 6,
                    ),
                    margin: const EdgeInsets.only(right: 10, bottom: 8),
                    decoration: BoxDecoration(
                      color:
                      widget.isMultiValue
                          ? widget.valueList.contains(m.id)
                          ? Colors.blue[50]
                          : Colors.white
                          : widget.value == m.id
                          ? Colors.blue[50]
                          : Colors.white,
                      // border: Border.all(
                      //     width: 0,
                      //     color: widget.value == m.id
                      //         ? Color(0xFF0676FC)
                      //         : Colors.blueGrey),
                      borderRadius: BorderRadius.circular(50),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Color(0xFF94B6C6), blurRadius: 5)
                      // ]
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.isMultiValue &&
                            widget.valueList.contains(m.id))
                          Icon(
                            FontAwesomeIcons.check,
                            size: 11,
                            color: Colors.blue[700],
                          ),
                        if (!widget.isMultiValue &&
                            widget.value == m.id)
                          Icon(
                            FontAwesomeIcons.check,
                            size: 11,
                            color: Colors.blue[700],
                          ),
                        if (widget.value == m.id)
                          const SizedBox(width: 6),
                        Text(
                          parseString(data: m.value, defaultValue: ''),
                          style: TextStyle(
                            fontSize: 11,
                            color:
                            widget.isMultiValue
                                ? widget.valueList.contains(m.id)
                                ? Colors.blue[700]
                                : Colors.black
                                : widget.value == m.id
                                ? Colors.blue[700]
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : ListView(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        primary: true,
        children: [
          ...widget.items.map(
                (m) => GestureDetector(
              onTap: () {
                widget.onValueChange(m.id);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                margin: const EdgeInsets.only(right: 10, bottom: 8),
                decoration: BoxDecoration(
                  color:
                  widget.value == m.id
                      ? Colors.blue[50]
                      : Colors.white,
                  border: Border.all(
                    width: 1,
                    color:
                    widget.value == m.id
                        ? Color(0xFF0676FC)
                        : Colors.blueGrey,
                  ),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(color: Color(0xFF94B6C6), blurRadius: 5),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.value == m.id)
                      Icon(
                        FontAwesomeIcons.check,
                        size: 15,
                        color: Colors.blue[700],
                      ),
                    if (widget.value == m.id) const SizedBox(width: 6),
                    Text(
                      parseString(data: m.value, defaultValue: ''),
                      style: TextStyle(
                        color:
                        widget.value == m.id
                            ? Colors.blue[700]
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class AreaChartHelper extends StatelessWidget {
  final List<ChartData> dataSource;
  final LinearGradient gradient;
  final String chartTitle;
  final bool showBorder;
  final bool showXAxis;
  final bool showYAxis;
  final Color gridYLineColor;
  final Color gridXLineColor;
  final Widget Function(dynamic data)? customTooltip;
  AreaChartHelper({
    super.key,
    required this.dataSource,
    this.gradient = const LinearGradient(
      colors: [Color(0xff6eaeff), Color(0x90dbecff)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    required this.chartTitle,
    this.customTooltip,
    this.showBorder = false,
    this.showXAxis = true,
    this.showYAxis = true,
    this.gridXLineColor = const Color(0x6ec8c8c8),
    this.gridYLineColor = const Color(0x6ec8c8c8),
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: showBorder ? 1 : 0,
      title: ChartTitle(
        text: chartTitle,
        alignment: ChartAlignment.near,
        textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      enableAxisAnimation: false,
      zoomPanBehavior: ZoomPanBehavior(
        enableMouseWheelZooming: false,
        enableDoubleTapZooming: false,
        enablePanning: false,
      ),
      primaryXAxis: CategoryAxis(
        labelPlacement: LabelPlacement.betweenTicks,
        majorGridLines: MajorGridLines(color: gridXLineColor),
        isVisible: showXAxis,
        labelStyle: TextStyle(fontSize: 11),
        rangePadding: ChartRangePadding.auto,
      ),
      primaryYAxis: CategoryAxis(
        isVisible: showYAxis,
        majorGridLines: MajorGridLines(color: gridYLineColor),
      ),
      series: <CartesianSeries>[
        SplineAreaSeries(
          // FastLineSeries(
          xValueMapper: (data, _) => data.x,
          yValueMapper: (data, _) => data.y,
          dataSource: dataSource,
          markerSettings: const MarkerSettings(
            isVisible: true,
            shape: DataMarkerType.circle,
            borderColor: Color(0xff00e3ff),
            width: 14,
            height: 14,
          ),
          borderDrawMode: BorderDrawMode.excludeBottom,
          enableTooltip: true,
          name: chartTitle,
          isVisibleInLegend: true,
          borderWidth: 2,
          borderColor: const Color(0xff00e3ff),
          gradient: gradient,
        ),
      ],
      tooltipBehavior: TooltipBehavior(
        enable: true,
        color: Colors.blueAccent[800],
        builder: (
            dynamic data,
            dynamic point,
            dynamic series,
            int pointIndex,
            int seriesIndex,
            ) {
          if ((customTooltip != null)) {
            return customTooltip!(data);
          } else {
            return Container(
              color: Color(0xFF040A0E),
              width: 110,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: TextHelper(
                      text: '${data.x}',
                      color: Colors.blue[100],
                      textalign: TextAlign.center,
                    ),
                  ),
                  Divider(),
                  Container(
                    child: TextHelper(
                      text: '${data.y}',
                      color: Colors.blue[100],
                      fontweight: FontWeight.w600,
                      textalign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// HELPER FUNCTIONS ========

showAlert(String content, AlertType alertType, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.horizontal,
      duration: const Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      showCloseIcon: false,
      elevation: 0,
      content: MoonAlert.filled(
        color:
        alertType == AlertType.error
            ? Colors.red[600]
            : alertType == AlertType.success
            ? Colors.green[600]
            : Colors.blue[600],
        backgroundColor:
        alertType == AlertType.error
            ? Colors.red[50]
            : alertType == AlertType.success
            ? Colors.green[100]
            : Colors.grey[200],
        // borderColor: alertType == AlertType.error
        //     ? Colors.red[600]
        //     : alertType == AlertType.success
        //         ? Colors.green[600]
        //         : Colors.blue[600],
        leading: Icon(
          alertType == AlertType.success
              ? MoonIcons.generic_check_rounded_24_light
              : MoonIcons.notifications_alert_24_light,
        ),
        label: Text(content),
      ),
    ),
  );
}

Future<void> showLoader(BuildContext context) async {
  return showAdaptiveDialog(
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    context: context,
    builder:
        (context1) => Dialog.fullscreen(
      backgroundColor: Color(0x6fffffff),
      child: Container(
        color: Colors.transparent,
        child: Center(child: CircularProgressIndicator(color: Colors.blue)),
      ),
    ),
  );
}

Map<String, dynamic> makeMapSerialize(Map data) {
  return Map<String, dynamic>.from(data);
}

List<Map<String, dynamic>> makeListSerialize(List<dynamic> data) {
  return data
      .map<Map<String, dynamic>>((m) => Map<String, dynamic>.from(m))
      .toList();
}

int parseInt({required dynamic data, required int defaultInt}) {
  try {
    return int.tryParse(
      parseDouble(
        data: data.toString(),
        defaultValue: 0.0,
      ).toStringAsFixed(0),
    ) ==
        null
        ? defaultInt
        : int.parse(
      parseDouble(
        data: data.toString(),
        defaultValue: 0.0,
      ).toStringAsFixed(0),
    );
  } catch (e) {
    return defaultInt;
  }
}

double parseDouble({required dynamic data, required double defaultValue}) {
  try {
    return double.tryParse(data.toString()) == null
        ? defaultValue
        : double.parse(data.toString());
  } catch (e) {
    return defaultValue;
  }
}

String parseDoubleWithLength({
  required dynamic data,
  required String defaultValue,
  int doubleLength = 2,
}) {
  try {
    return double.tryParse(data.toString()) == null
        ? defaultValue
        : double.parse(data.toString()).toStringAsFixed(doubleLength);
  } catch (e) {
    return defaultValue;
  }
}

String parseString({required dynamic data, required String defaultValue}) {
  try {
    return data.toString() == 'null' ? defaultValue : data.toString();
  } catch (e) {
    return defaultValue;
  }
}

String parseIntToString({required dynamic data, required String valueForZero}) {
  try {
    return parseInt(data: data, defaultInt: 0) == 0
        ? valueForZero
        : parseInt(data: data, defaultInt: 0).toString();
  } catch (e) {
    return valueForZero;
  }
}

String parseDateToString({
  required dynamic data,
  required dynamic formatDate,
  required dynamic predefinedDateFormat,
  required String defaultValue,
}) {
  try {
    return DateFormat(formatDate).format(
      DateFormat(
        predefinedDateFormat,
      ).parse(parseString(data: data, defaultValue: '')),
    );
  } catch (e) {
    return defaultValue;
  }
}

String currenyFormater({required dynamic value, required String format}) {
  String val = parseString(data: value, defaultValue: '');
  bool isDouble = false;
  int doubleLen = 0;
  String floatPart = '';
  String intPart = '';
  String reversedFormatStr = '';
  if (val == '' || parseString(data: format, defaultValue: '') == '') {
    throw ErrorHint('Give proper value and format to use currenyFormater');
  }
  if (format.contains('.')) {
    isDouble = true;
    doubleLen = format.substring(format.indexOf('.') + 1).length;
  }
  if (isDouble) {
    val = parseString(
      data: parseDoubleWithLength(
        data: val,
        defaultValue: '0.0',
        doubleLength: doubleLen,
      ),
      defaultValue: '',
    );
    floatPart = val.substring(val.indexOf('.'));
    intPart = val.substring(0, val.indexOf('.')).split('').reversed.join('');
    reversedFormatStr = format
        .substring(0, format.indexOf('.'))
        .split('')
        .reversed
        .join('');
  } else {
    intPart = val.split('').reversed.join('');
    reversedFormatStr = format.split('').reversed.join('');
  }

  List<int> commaIndexList = [];
  String modifiedVal = '';
  for (int i = 0; i < reversedFormatStr.length; i++) {
    if (reversedFormatStr[i] == ',') {
      commaIndexList.add(i - commaIndexList.length - 1);
    }
  }
  for (int i = 0; i < intPart.length; i++) {
    modifiedVal += intPart[i];
    if (i != intPart.length - 1 && commaIndexList.contains(i)) {
      modifiedVal += ',';
    }
  }
  return '₹ ${modifiedVal.split('').reversed.join('')}$floatPart';
}
