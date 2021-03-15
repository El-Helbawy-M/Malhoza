import 'dart:io';

import 'package:flutter/material.dart';

class DataListner extends ChangeNotifier {
  //varbiles :
  String title = "", subject = "";
  Color noteColor = Colors.white,
      textColor = Colors.black,
      checkBoxColor = Colors.white;
  File image;
  //End

  //===============================================

  //Funcations :

  changeNoteColor(Color color) {
    noteColor = color;
    notifyListeners();
  }

  //============
  changeTextColor(Color color) {
    textColor = color;
    notifyListeners();
  }

  //============
  changeCheckBoxColor(Color color) {
    checkBoxColor = color;
    notifyListeners();
  }

  //============
  changeTitl(String str) {
    title = str;
    notifyListeners();
  }

  //============
  changeSubject(String str) {
    subject = str;
    notifyListeners();
  }

  //============
  changeImage(File file) {
    image = file;
    notifyListeners();
  }

  clearAll() {
    title = "";
    subject = "";
    noteColor = Colors.white;
    textColor = Colors.black;
    checkBoxColor = Colors.white;
    image = null;
  }

  fillAll(String title, subject, Color noteColor, File image) {
    changeTitl(title);
    changeSubject(subject);
    changeNoteColor(noteColor);
    changeImage(image);
  }

  //============

  //End
}
