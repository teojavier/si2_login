import 'package:flutter/material.dart';

// ignore: camel_case_types
class registerformprovider extends ChangeNotifier{

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String type = '';


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  set isLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm(){
    return formkey.currentState?.validate() ?? false;
  }

}