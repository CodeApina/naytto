import 'package:flutter/foundation.dart';

class User extends ChangeNotifier{
  static final User _instance = User._internal();
  late String? _uid;
  String get uid => _uid!;
  set uid(String uid){
    _uid = uid;
    notifyListeners();
  }

  late String _name;
  String get name => _name;
  set name(String name){
    _name = name;
    notifyListeners();
  }
  late String _apartmentId;
  String get apartmentId => _apartmentId;
  set apartmentId(String aparmentid){
    _apartmentId = aparmentid;
    notifyListeners();
  } 
  late String _tel;
  String get tel => _tel;
  set tel(String tel){
    _tel = tel;
    notifyListeners();
  }
  late String _email;
  String get email => _email;
  set email(String email){
    _email = email;
    notifyListeners();
  }

  factory User(){
    return _instance;
  }

  User._internal(){

  }

}