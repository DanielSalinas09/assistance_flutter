import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';


class PreferencesUser {
  
  static final PreferencesUser _instance = PreferencesUser._internal();

  factory PreferencesUser(){
    return _instance;
  }

  PreferencesUser._internal();

  late SharedPreferences prefs;
  initPrefs()async{
    prefs=await SharedPreferences.getInstance();
  }

  //GET token
  String get token {
    return prefs.getString('token')??'';
  }
  //Setter token
  set token (String value){
    prefs.setString('token', value);
  }
  
  //Get user
  Map<String,dynamic> get user{
    return jsonDecode(prefs.getString('user')??'{}');
  }
  //Setter user
  set user (Map<String,dynamic> value){
    prefs.setString('user', jsonEncode(value));
  }
   
}