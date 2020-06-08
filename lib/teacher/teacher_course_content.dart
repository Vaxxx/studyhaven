import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart';
import 'package:studyhaven/model/course.dart';
import 'package:studyhaven/teacher/teacher_dashboard.dart';
import 'package:studyhaven/utilities/constants.dart';

class TeacherCourseContent extends StatefulWidget {
  final int level;

  const TeacherCourseContent({Key key, this.level}) : super(key: key);
  @override
  _TeacherCourseContentState createState() => _TeacherCourseContentState();
}

class _TeacherCourseContentState extends State<TeacherCourseContent> {
  List<String> courseList;
  String _course = "Mathematics";
  File _file;
  String uploadMsg = "";
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  TextEditingController _titleController;
  bool _validate = false;
  bool showSpinner = false;
  // GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future getFile() async {
    File file = await FilePicker.getFile();
    setState(() {
      _file = file;
      uploadMsg = '$_file has been chosen';
    });
  }

  void uploadFile(filePath) async {
    String _title = checkForSpaces(_titleController.text.toString());
    String _level = widget.level.toString();

    print(
        "File name: $_title \n File Path :  \n Level: $_level \nCourse: $_course");
    if (_title == "") {
      displayMsg("Please enter a title");
    } else {
      setState(() {
        showSpinner = true;
      });
      print('Title : $_title and Course: $_course');
      String fileName = basename(filePath.path);
      String extension = fileName.split('.').last;
      String _path = "$_course-$_title.$extension";
      print('Level:..........${widget.level.toString()}');
      print('Filename.......................$fileName');
      try {
        FormData formData = new FormData.fromMap({
          "filename": _title,
          "filepath": _path,
          "level": _level,
          "course": _course,
          "file":
              await MultipartFile.fromFile(filePath.path, filename: fileName)
        });
        print('Before Response...............................');
        Response response = await Dio().post(fileUploadUrl, data: formData);
        print('Response..........................................$response');
        clearFields();
        displayMsg("File uploaded successfully");
        _showSnackbarMsg(response.data['message']);
      } catch (e) {
        print('Error....................$e');
      }
    }
  }

  void clearFields() {
    setState(() {
      uploadMsg = "";
      _titleController.text = "";
    });
  }

  Future<List> getCoursesBasedOnLevel() async {
    courseList = List<String>();
    var data = {"level": widget.level.toString()};
    var response = await http.post(getCoursesBasedOnLevelUrl, body: data);
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

    List<Course> parsedCourseList =
        parsed.map<Course>((json) => Course.fromJson(json)).toList();

    for (int i = 0; i < parsedCourseList.length; i++) {
      courseList.add(parsedCourseList[i].title);
    }
    //_course = courseList[0];
    return courseList;
  }

  void _showSnackbarMsg(String msg) {
    _scaffoldstate.currentState.showSnackBar(SnackBar(
      content: Text(msg),
    ));
  }

  @override
  void initState() {
    print('its init state');
    print('the level is ${widget.level.toString()}');
    _titleController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  getDropdownButton() {
    return FutureBuilder<List>(
      future: getCoursesBasedOnLevel(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return DropdownButton(
          value: _course,
          items: snapshot.data.map((value) {
            return DropdownMenuItem(
              child: Text(value),
              value: value,
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _course = newValue;
            });
          },
        );
      },
    );
  } //validateTitle

  @override
  Widget build(BuildContext context) {
    print('the course list second item');

    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text("Upload Course Content"),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
            color: colorWhite,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => TeacherDashboard(
                level: widget.level,
              ),
            ));
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          /////////////////////////////////////////ITEM 1: clipPath//////////////////////////////////////////////
          clipPathContainer(),
          ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Form(
              //key: _formKey,
              autovalidate: _validate,
              child: Column(
                children: <Widget>[
                  titleContainer(),
                  courseNameContainer(),
                  chooseFileContainer(),
                  Text(uploadMsg == "" ? "" : uploadMsg),
                  uploadFileContainer(),
                ],
              ),
            ),
          )
          /////////////////////////////End of Five container///////////////////////////
        ],
      ),
    );
  }

  ///form elements///////////////////////////////////////////////////////////////
  TextFormField titleText() {
    return TextFormField(
      controller: _titleController,
      keyboardType: TextInputType.text,
      validator: validateTitle,
      decoration: InputDecoration(
        labelText: "Enter a title for the material",
        hintText: "eg Introduction to Calculus",
        border: OutlineInputBorder(),
      ),
    );
  } //titleText()

  ClipPath clipPathContainer() {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: backgroundImage, fit: BoxFit.cover)),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        child: Column(
          children: <Widget>[
            Text(
              'Study Haven',
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
            Text(
              'Upload Course Contents',
              style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: splashColor),
            )
          ],
        ),
      ),
    );
  }

//////////////////////////title container//////////////////////////////////////////////
  Container titleContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorGreyWithOpacity, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Icon(
              Icons.title,
              color: colorGrey,
            ),
          ),
          Container(
            height: 10.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: titleText(),
          )
        ],
      ),
    );
  }
  ////////////////////////////////////////////end title container

//////////////////////////course name container//////////////////////////////////////////////
  Container courseNameContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorGreyWithOpacity, width: 1.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Icon(
              Icons.title,
              color: colorGrey,
            ),
          ),
          Container(
            height: 10.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: getDropdownButton(),
          )
        ],
      ),
    );
  }

////////////////////////////////////////////end Course name container
//////////////////////////////////////////Choose a file Container///////////////////////////////////////////////
  Container chooseFileContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              splashColor: splashColor,
              color: splashColor,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Choose File',
                      style: TextStyle(color: colorWhite),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Transform.translate(
                    offset: Offset(15.0, 0.0),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0)),
                        splashColor: colorWhite,
                        color: colorWhite,
                        child: Icon(
                          Icons.receipt,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          getFile();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                getFile();
              },
            ),
          )
        ],
      ),
    );
  }

  ////////////////////////////////////////end choose file container////////////////////////////////
  // ///////////////////////////////////////////////////////////Upload file Container///////////////////////
  Container uploadFileContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              splashColor: splashColor,
              color: splashColor,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Upload File',
                      style: TextStyle(color: colorWhite),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Transform.translate(
                    offset: Offset(15.0, 0.0),
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.0)),
                        splashColor: colorWhite,
                        color: colorWhite,
                        child: Icon(
                          Icons.receipt,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          uploadFile(_file);
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                uploadFile(_file);
              },
            ),
          )
        ],
      ),
    );
  }
  ////////////////////////////////////////end upload file container//////////////////////

/////////////////////////validators/////////////////////////////////////////////////////////////////
  String validateTitle(String value) {
    String pattern = '(^[a-zA-Z ])';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return " A title for the material is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    } else if (value.length < 3) {
      return "The title of the material is too short. Please ensure  it is at least three characters";
    }
    return null;
  } //validateTitle

  String validateCourseName(String value) {
    String pattern = '(^[a-zA-Z ])';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Course Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    } else if (value.length < 3) {
      return "The name of the course is too short. Please ensure  it is at least three characters";
    }
    return null;
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
