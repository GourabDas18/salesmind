import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moon_icons/moon_icons.dart';
import 'package:salesmind/Helper/ButtonHelper.dart';
import 'package:salesmind/Helper/helper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:salesmind/Helper/utility.dart';
import '../Store/loginStore.dart';
import '../apiconst.dart';
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginStore loginStore = Get.put(LoginStore());
  bool obscureText = true;
  AppLoaderController appLoaderController = AppLoaderController();
  Future<void>login()async{
    DeviceInfoPlugin  deviceInfoPlugin = DeviceInfoPlugin();
    String? deviceName;
    String? deviceId;
    if(GetPlatform.isAndroid){
      AndroidDeviceInfo device = await deviceInfoPlugin.androidInfo;
      deviceName = device.name;
      deviceId = device.id;
    }
    if(GetPlatform.isDesktop){
      WindowsDeviceInfo device = await deviceInfoPlugin.windowsInfo;
      deviceName = device.userName;
      deviceId = device.deviceId;
    }
    if(deviceName==null || deviceId==null){
      return showAlert("Device not found!", AlertType.error, context);
    }
    if(loginStore.email.text.isEmpty || loginStore.password.text.isEmpty){
      return showAlert("Enter email and password correctly", AlertType.error, context);
    }
    Map<String,dynamic> data = {
      'email': loginStore.email.text,
      'password' : loginStore.password.text,
      'deviceName':deviceName,
      "deviceId":deviceId
    };
  CustomResponse resp = await makeApiCall(logInApi, ApiCallType.post,data: data);
  if(resp.success){
    showAlert(resp.response, AlertType.success, context);
    Authenticator authenticator = Authenticator();
    authenticator.addNewSingleUser(resp.data, context);
    authenticator.isLoggedIn(makeLogin: true, context: context,authData: jsonEncode(resp.data));
  }else{
    showAlert(resp.response, AlertType.error, context);
  }
  }


  @override
  Widget build(BuildContext context) {
    return AppLoader(
      controller: appLoaderController,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/workplace-objects.jpg',),fit: BoxFit.cover)
          ),
          child: Center(
            child: Container(
              width: 405,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0, 0),
                    blurRadius: 10
                  )
                ]
              ),
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/workmind_logo_min.png',width: 250,),
                  const SizedBox(height: 1,),
                  // const SizedBox(height: 1,),
                  TextHelper(text: "Log In",fontsize: 22,textalign: TextAlign.center,width: 80,fontweight: FontWeight.w600,),
                  TextHelper(text: "Welcome \nEnter your details",fontsize: 15,),
                  const SizedBox(height: 1.2,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 40,horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200
                    ),
                    child: Column(
                      spacing: 20,
                      children: [
                        Row(
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(MoonIcons.mail_envelope_32_regular),
                            TextBoxHelperG(onValueChange: (v){

                            },
                              controller: loginStore.email,
                              labelText: 'Email',
                              placeholder: "Enter your mail",
                              showAlwaysLabel: true,
                              width: 300,
                            )
                          ],
                        ),
                        Row(
                          spacing: 8,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(MoonIcons.security_lock_32_regular),
                            TextBoxHelperG(
                              onValueChange: (v){},
                              controller: loginStore.password,
                              labelText: 'Password',
                              placeholder: "Enter your password",
                              showAlwaysLabel: true,
                              obscureText:  obscureText,
                              width: 300,
                              trailing: GestureDetector(
                                onTap: (){
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon( obscureText ? MoonIcons.controls_eye_crossed_32_regular : MoonIcons.controls_eye_32_regular),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 6),
                            child: TextHelper(text: "Forget Password ?",color: Colors.blue,),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 1,),
                  ButtonHelperG(
                    child: Center(child: TextHelper(text: "Submit",color: Colors.white,textalign: TextAlign.center,))
                    ,backgroundColor: Colors.blue,
                    width: 300, onTap: () {
                      try {
                        appLoaderController.loading.value=true;
                        login().whenComplete((){
                          appLoaderController.loading.value=false;
                        });
                      }catch(e){
                        showAlert("$e", AlertType.error, context);
                        appLoaderController.loading.value=false;
                      }
                  },)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
