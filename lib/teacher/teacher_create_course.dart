import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studyhaven/utilities/constants.dart';

class TeacherCreateCourse extends StatefulWidget {
  final int level;

  const TeacherCreateCourse({Key key, this.level}) : super(key: key);
  @override
  _TeacherCreateCourseState createState() => _TeacherCreateCourseState();
}

class _TeacherCreateCourseState extends State<TeacherCreateCourse> {
  TextEditingController _titleController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;
  bool showSpinner = false;

  @override
  void initState() {
    _titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body(context));
  }

  Widget body(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return portrait();
    } else {
      return landscape();
    }
  }

  Widget portrait() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              /////////////////////////////////////////ITEM 1: clipPath//////////////////////////////////////////////
              clipPathContainer(),
              /////////////////////////////////////////clipPath//////////////////////////////////////////////
              ////////////////////////////////////////////////////////////ITEM 2 EMAILContainer/////////////////////////////////
              ModalProgressHUD(
                inAsyncCall: showSpinner,
                child: Form(
                  key: _formKey,
                  autovalidate: _validate,
                  child: Column(
                    children: <Widget>[
                      titleContainer(),
                      courseContainer(),
                    ],
                  ),
                ),
              )
              /////////////////////////////End of Five container///////////////////////////
            ],
          ),
        ),
      ),
    );
  }

  Widget landscape() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ////////////////////////////////////First Container: fullname///////////////////////
            ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Form(
                key: _formKey,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    titleContainer(),
                    courseContainer(),
                  ],
                ),
              ),
            )
            ////////////////////////////////////5th Container: Register Button///////////////////////
          ],
        ),
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
        labelText: "Course Name",
        hintText: "Enter Course Name",
        border: OutlineInputBorder(),
      ),
    );
  } //fullnameText()

  addCourse() async {
    String _role = "Student";
    if (_formKey.currentState.validate()) {
      //form fields are validated
      _formKey.currentState.save();
      print("Fullname: ${_titleController.text.trim()} ");
      print(widget.level.toString());

      String titl = checkForSpaces(_titleController.text.trim());
      try {
        http.post(addCourseUrl, body: {
          "title": titl,
          "level": widget.level.toString(),
        });
        backToLastPage();
        displayMsg("A new Course has been Added!");
      } catch (e) {
        print("ERROR: $e");
        displayMsg("ERROR: $e");
      }
    } else {
      setState(() {
        _validate = true;
        displayMsg('Please fill the form correctly');
      });
    }
  }

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
              'Enter a Course',
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

  //////////////////////////////////////////end of item 1: Clip path///////////////////////
  //////////////////////////////////////////ITEM 2: FULL NAME//////////////////////////////////////////////////
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
              Icons.trip_origin,
              color: colorGrey,
            ),
          ),
          Container(
            height: 10.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          ////remove container and place widget here.....////////////////////
          Expanded(
            child: titleText(),
          )
        ],
      ),
    );
  }

  ///////////////////////////////////////END OF ITEM 2: FULL NAME/////////////////////////////////////////////

  //////////////////////////////////////////ITEM 6: Course//////////////////////////////////////////////////
  Container courseContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              splashColor: googleColor,
              color: googleColor,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'ADD A COURSE',
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
                          addCourse();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                addCourse();
              },
            ),
          )
        ],
      ),
    );
  }

  ///////////////////////////////////////END OF ITEM 6: REGISTER/////////////////////////////////////////////
  ////////////////////////////////////////////////////////END OF CONTAINER FORM FIELDS////////////////////////////
///////////////////////////////VALIDATION/////////////////////////////////////////////////////////////
/////////////////////////validators/////////////////////////////////////////////////////////////////
  String validateTitle(String value) {
    String pattern = '(^[a-zA-Z ])';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    } else if (value.length < 3) {
      return "Your title is too short, Please ensure you enter a valid course title and it must at least three characters";
    }
    return null;
  } //validateName

  void backToLastPage() {
    Navigator.pop(context);
  }
///////////////////////////////END OF VALIDATION/////////////////////////////////////////////////////////////
} //registerpagestate

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
