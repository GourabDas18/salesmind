
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesmind/Store/getXStore.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'helper.dart';
import 'package:logger/logger.dart';

const passkey = "omvashudhareswah";

class DownloadFileResponse{
  final XFile file;
  final String fileName;
  final bool success;
  final String response;
  DownloadFileResponse({required this.file, required this.fileName, required this.success, required this.response});
}

class FileHandlerG{

  Future<String> getAppDirectory()async{
    return await getApplicationDocumentsDirectory().then((e)=>e.path);
  }

  Future<bool> saveFile({required Uint8List file,required String fileName})async{
    try{
      String path = await getAppDirectory();
      File f = await File('$path/$fileName').create();
      await f.writeAsBytes(file);
      return true;
    }
    catch(e){
      return throw('$e');
    }
  }

  Future<DownloadFileResponse> downloadAndSaveFile({required String filePathWithName,required String url, void Function(double progress)? downloadProgress, bool shareAfterDownload=false})async{
    try{
      Dio dio = Dio();
      XFile? file;
      String path = await getAppDirectory();
      await dio.download(url, "$path/$filePathWithName",
        onReceiveProgress: (receivedBytes, totalBytes) {
          if(downloadProgress!=null){
            downloadProgress(receivedBytes / totalBytes);
          }
        },
      )
          .catchError((e){
        return throw(e);
      })
          .whenComplete(() async {
            file =  XFile("$path/$filePathWithName");
            if(shareAfterDownload && file!=null){
              await SharePlus.instance.share(ShareParams(
              title: filePathWithName,
              files: [file!],
              previewThumbnail: file
             )).catchError((e){
               return throw(e);
             });
           }
        // showPdf("$path/${collectionStore.selectedPartyData.value['name'].toString().toLowerCase().replaceAll(' ', '')}.pdf",collectionStore.selectedPartyData.value['name']);
      });
      return DownloadFileResponse(file: file!,fileName: filePathWithName,success: true,response: 'File Download Successfully!');
    }
    catch(e){
      return throw('$e');
    }
  }


}


class LocalStorage{
  final String passkey;
  EncryptedSharedPreferences? sharedPreferences;

  Future<EncryptedSharedPreferences> getPref()async{
    if(sharedPreferences == null){
      await EncryptedSharedPreferences.initialize(passkey);
      var sharedPref = EncryptedSharedPreferences.getInstance();
      sharedPreferences = sharedPref;
      return sharedPreferences!;
    }else{
      return sharedPreferences!;
    }

  }

  Future<String> getStringValue({required String id})async{
    EncryptedSharedPreferences pref = await getPref();
    return parseString(data: pref.getString(id), defaultValue: '');
  }

  Future<bool> getBoolValue({required String id})async{
    EncryptedSharedPreferences pref = await getPref();
    return pref.getBool(id) ?? false;
  }

  Future<int> getIntValue({required String id})async{
    EncryptedSharedPreferences pref = await getPref();
    return parseInt(data: pref.getInt(id), defaultInt: -1);
  }

  Future<void> setStringValue({required String id,required String value,BuildContext? context})async{
    EncryptedSharedPreferences pref = await getPref();
    pref.setString(id, value).catchError((e){
      if(context!=null){
        showAlert("$e", AlertType.error, context);
        debugPrint("$e");
      }
      return false;
    });
  }

  Future<void> clear(String key)async{
    EncryptedSharedPreferences pref = await getPref();
    await pref.remove(key);
  }

  LocalStorage({required this.passkey});
}

class AppLoaderController extends GetxController{
   RxBool loading=false.obs;
}

class AppLoader extends StatefulWidget {
  final Widget child;
  final AppLoaderController controller;
  AppLoader({super.key,required this.child,required this.controller});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {

  @override
  void dispose() {
    if(mounted){
    widget.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=> PopScope(
          canPop: !widget.controller.loading.value,
          child: Stack(
          children: [
            widget.child,
            if(widget.controller.loading.value)
            Positioned.fill(child: Container(
              decoration: const BoxDecoration(color: Colors.white54),
              child: Center(
                child: SizedBox(
                    height: 30,
                    width: 30,
                    child: const  CircularProgressIndicator(color: Colors.blue)),
              ),
            ))
          ],
                ),
        ),
    );
  }
}


class Authenticator{
  List<Map<String,dynamic>> multiUserLists = [];
  late LocalStorage _localStorage;

  Future<void> setUsersList()async{
    _localStorage = LocalStorage(passkey: passkey);
    String data =await _localStorage.getStringValue(id: 'savedusers');
    // await localStorage.clear('savedusers');
    multiUserLists = makeListSerialize(jsonDecode(parseString(data:data==''?'{"data":[]}':data, defaultValue: '{"data":[]}' ))["data"]);
  }

  Future<List<Map<String,dynamic>>> getUsersList()async{
    if(multiUserLists.isEmpty){
      await setUsersList();
      return multiUserLists;
    }else {
      return multiUserLists;
    }
  }

  Future<void> addNewSingleUser(Map<String,dynamic> data, BuildContext context)async{
    if(multiUserLists.isEmpty){
      await setUsersList();
      if(!multiUserLists.any((t)=>t['id']==data['id'])){
        multiUserLists.add(data);
        await _localStorage.setStringValue(id: 'savedusers', value: jsonEncode(makeMapSerialize({"data":multiUserLists})), context: context);
      }
    }else{
      if(!multiUserLists.any((t)=>t['id']==data['id'])){
        multiUserLists.add(data);
        await _localStorage.setStringValue(id: 'savedusers', value: jsonEncode(makeMapSerialize({"data":multiUserLists})), context: context);
      }
    }
  }

  Future<void> removeSingleUser(Map<String,dynamic> data, BuildContext context)async{
    if(multiUserLists.isEmpty){
      await setUsersList();
      multiUserLists.removeWhere((r)=>r['id']==data['id']);
      await _localStorage.setStringValue(id: 'savedusers', value: jsonEncode(makeMapSerialize({"data":multiUserLists})), context: context);
    }else{
      multiUserLists.removeWhere((r)=>r['id']==data['id']);
      await _localStorage.setStringValue(id: 'savedusers', value: jsonEncode(makeMapSerialize({"data":multiUserLists})), context: context);
    }
  }

  Future<bool> isLoggedIn({String? authData, required bool makeLogin,BuildContext? context}) async {
    dynamic authData0;
    bool loggedIn = false;
    _localStorage = LocalStorage(passkey: passkey);
    MainStore mainStore = Get.find();
    if(authData==null) {
      authData0=await _localStorage.getStringValue(id: 'authData');
    }
    else{
      authData0 = authData;
    }
    if (authData0 != null && authData0 != '') {
      if (isJSONParsable(authData0)) {
        mainStore.authData.value = jsonDecode(authData0);
        _localStorage.setStringValue(id: "authData", value: authData0, context: context);
        _localStorage.setStringValue(id: "auth", value: authData0, context: context);
        loggedIn=true;
      } else {
        mainStore.authData.value = {};
      }
    }

    if(makeLogin && context!=null && loggedIn){
      Navigator.pushNamedAndRemoveUntil(context, '/',ModalRoute.withName('/'),);
      return loggedIn;
    }
    if(makeLogin && context!=null && !loggedIn){
      Navigator.pushNamedAndRemoveUntil(context, '/login',ModalRoute.withName('/login'),);
      return loggedIn;
    }
    return loggedIn;
  }

}



final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 3,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

void logInfo(dynamic message) => _logger.i(message);
void logWarning(dynamic message) => _logger.w(message);
void logError(dynamic message) => _logger.e(message);
void logDebug(dynamic message) => _logger.d(message);
void logVerbose(dynamic message) => _logger.v(message);

