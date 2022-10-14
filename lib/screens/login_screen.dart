// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_auth/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // device info
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String? _deviceName;
  

  @override
  void initState() {
    _emailController.text = 'andra@test.com';
    _passwordController.text = 'password';

    getDeviceName();
    super.initState();
  }

  void getDeviceName() async {
    try{
      if(Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        _deviceName = androidInfo.model;
      }else if(Platform.isIOS){
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        _deviceName = iosInfo.utsname.machine;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  controller: _emailController,
                  validator: (value) =>
                      value!.isEmpty ? 'please enter valid email' : null),
              TextFormField(
                  controller: _passwordController,
                  validator: (value) =>
                      value!.isEmpty ? 'please enter password' : null),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                minWidth: double.infinity,
                color: Colors.blue,
                child: Text('Login', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Map creds = {
                    'email': _emailController.text,
                    'password': _passwordController.text,
                    'device_name': _deviceName ?? 'Unknown',
                  };
                  if (_formKey.currentState!.validate()) {
                    Provider.of<Auth>(context, listen: false)
                        .login(creds: creds);
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
