import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var primaryColor = Color(0xFF4aa0d5);
var backgroundImage = AssetImage('images/bg.png');
var backgroundColor = Colors.blue;
var colorGrey = Colors.grey;
var colorGreyWithOpacity = Colors.grey.withOpacity(0.5);
var splashColor = Color(0xFF3B5998);
var colorWhite = Colors.white;
var googleColor = Color(0xfff32e06);

void displayMsg(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: googleColor,
      textColor: colorWhite);
}

String checkForSpaces(String s) {
  String newS = "";
  if (s.split(" ").length > 1) {
    var list = s.split(" ");
    for (String l in list) newS += l.trim();
  } else {
    newS = s;
  }
  return newS;
}

String insertUserUrl = "https://fearlessnaija.com/projectapp/insertuser.php";
String selectUserUrl = "https://fearlessnaija.com/projectapp/selectuser.php";
String addCourseUrl = "https://fearlessnaija.com/projectapp/addcourse.php";
//String getCoursesUrl = "https://fearlessnaija.com/projectapp/addcourse.php";
String fileUploadUrl =
    "https://fearlessnaija.com/projectapp/uploadcoursecontent.php";
String getCoursesBasedOnLevelUrl =
    "https://fearlessnaija.com/projectapp/getcoursesbasedonlevel.php";
String getCoursesBasedOnLevelAndCourseUrl =
    "https://fearlessnaija.com/projectapp/getcoursecontentbasedonlevelandcourse.php";
