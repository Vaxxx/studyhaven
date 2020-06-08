import 'package:flutter/material.dart';
import 'package:studyhaven/teacher/teacher_course_content.dart';
import 'package:studyhaven/teacher/teacher_create_course.dart';
import 'package:studyhaven/utilities/constants.dart';

class TeacherDashboard extends StatefulWidget {
  final int level;

  const TeacherDashboard({this.level});
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
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
        title: Text('Welcome'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            /////////////////////////////////////////ITEM 1: clipPath//////////////////////////////////////////////
            clipPathContainer(),
            /////////////////////////////////////////clipPath//////////////////////////////////////////////
            createTeacherLabelContainer(),
            createCourseContainer(),

            createCourseUploadContainer(),
          ],
        ),
      ),
    );
  }

  Widget landscape() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            /////////////////////////////////////////ITEM 1: clipPath//////////////////////////////////////////////
            clipPathContainer(),
            /////////////////////////////////////////clipPath//////////////////////////////////////////////
            ////////////////////////////////////////////////////////////ITEM 2 EMAILContainer/////////////////////////////////
            createTeacherLabelContainer(),
            createCourseContainer(),
            createCourseUploadContainer(),
          ],
        ),
      ),
    );
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
              'Admin Dashboard',
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

  ////////////////////////////////////////////create course////////////////////////////////////////////////
  Container createTeacherLabelContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 50.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Text(
            'Class ${widget.level} Teacher',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                color: splashColor),
          ),
        ],
      ),
    );
  }
  /////////////////////////////////////////end create course////////////////////////////////////////////////

////////////////////////////////////////////create course////////////////////////////////////////////////
  Container createCourseContainer() {
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
                      'Create Course',
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
                          createCourse();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                createCourse();
              },
            ),
          )
        ],
      ),
    );
  }
  /////////////////////////////////////////end create course////////////////////////////////////////////////

  ////////////////////////////////////////////course upload////////////////////////////////////////////////
  Container createCourseUploadContainer() {
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
                      'Upload Course Content',
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
                          Icons.book,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          uploadCourse();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                uploadCourse();
              },
            ),
          )
        ],
      ),
    );
  }
  /////////////////////////////////////////end course upload////////////////////////////////////////////////

  void createCourse() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => TeacherCreateCourse(
        level: widget.level,
      ),
    ));
  }

  void uploadCourse() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => TeacherCourseContent(
        level: widget.level,
      ),
    ));
  }
} //admin dashboard state

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
