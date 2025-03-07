import 'package:flutter/material.dart';

showSnackbar(BuildContext context,String text){
  return ScaffoldMessenger.of(context).showSnackBar(
    
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(text)));
}