import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studyhaven/screens/login_page.dart';
import 'package:studyhaven/student/student_course_content.dart';
import 'package:studyhaven/utilities/constants.dart';

class StudentDashboard extends StatefulWidget {
  final int level;

  const StudentDashboard({Key key, this.level}) : super(key: key);
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  Future<List> getCourses() async {
    print('Widget.level => 1 ${widget.level}');
    final response = await http.post(getCoursesBasedOnLevelUrl, body: {
      "level": widget.level.toString(),
    });
    print('Widget.level => 2 ${widget.level}');
    return json.decode(response.body);
  }

  @override
  void initState() {
    String _level = widget.level.toString();
    getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('the level');
    print(widget.level);

    return Scaffold(
      appBar: AppBar(
        title: Text('Courses for Level ${widget.level.toString()}'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorWhite,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(),
            ));
          },
        ),
      ),
      body: FutureBuilder<List>(
        future: getCourses(),
        builder: (context, data) {
          if (data.hasError) {
            return Center(
              child: Container(
                child: Text('Error'),
              ),
            );
          } else if (data.hasData) {
            return Items(
              list: data.data,
              newLevel: widget.level,
            );
          } else {
            CircularProgressIndicator();
          }
          return Container(
            child: Text('NO COURSES AVAILABLE YET'),
          );
        },
      ),
    );
  }
}

class Items extends StatelessWidget {
  final List list;
  final int newLevel;

  const Items({Key key, this.list, this.newLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return ListTile(
            leading: Icon(
              Icons.book,
              color: googleColor,
            ),
            title: Text(
              list[i]['title'],
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                  color: splashColor),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: splashColor,
              ),
              onPressed: () {
                courseContent(context, list[i]['title'], newLevel);
              },
            ),
            onTap: () {
              courseContent(context, list[i]['title'], newLevel);
            },
          );
        });
  }

  void courseContent(BuildContext context, String title, int level) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => StudentCourseContent(
        level: level,
        title: title,
      ),
    ));
  }
}
