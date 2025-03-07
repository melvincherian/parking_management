import 'package:flutter/material.dart';

class BottomNavbarprovider extends ChangeNotifier{
  int _currentIndex=0;

  int get currentindex=>_currentIndex;
  void setIndex(int index){
    _currentIndex=index;
    notifyListeners();
  }
}