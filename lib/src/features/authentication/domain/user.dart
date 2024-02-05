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

  late String _firstName;
  String get firstName  => _firstName;
  set firstName(String firstName){
    var split = name.split("");
    _firstName = split[0];
  }

  late String _lastName;
  String get lastName => _lastName;
  set lastName(String lastName){
    var split = name.split("");
    _lastName = split[split.length-1];
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