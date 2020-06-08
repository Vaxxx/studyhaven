import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studyhaven/screens/play_videos.dart';
import 'package:studyhaven/student/student_dashboard.dart';
import 'package:studyhaven/utilities/constants.dart';

class StudentCourseContent extends StatefulWidget {
  final int level;
  final String title;

  const StudentCourseContent({Key key, this.level, this.title})
      : super(key: key);
  @override
  _StudentCourseContentState createState() => _StudentCourseContentState();
}

class _StudentCourseContentState extends State<StudentCourseContent> {
  Future<List> getCoursesBasedOnLevelAndCourse() async {
    final response = await http.post(getCoursesBasedOnLevelAndCourseUrl, body: {
      "level": widget.level.toString(),
      "course": widget.title,
    });
    return json.decode(response.body);
  }

  @override
  void initState() {
    getCoursesBasedOnLevelAndCourse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'Level is ${widget.level.toString()} and title is ${widget.title}  do youunderstand');
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses Material ${widget.title}'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: colorWhite,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => StudentDashboard(
                level: widget.level,
              ),
            ));
          },
        ),
      ),
      body: FutureBuilder<List>(
        future: getCoursesBasedOnLevelAndCourse(),
        builder: (context, data) {
          if (data.hasError) {
            return Center(
              child: Container(
                child: Text('Error'),
              ),
            );
          } else if (!data.hasData) {
            Center(
              child: Text('NO COURSES MATERIAL AVAILABLE YET!',
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w800,
                      color: googleColor)),
            );
          } else if (data.hasData) {
            return Items(
              list: data.data,
            );
          } else {
            Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            child: Text('NO COURSES MATERIALS AVAILABLE YET',
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w800,
                    color: googleColor)),
          );
        },
      ),
    );
  }
}

class Items extends StatelessWidget {
  final List list;

  const Items({Key key, this.list}) : super(key: key);

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
              list[i]['filename'],
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  color: splashColor),
            ),
            subtitle: Text(
              list[i]['filepath'],
              style: TextStyle(fontSize: 2.0, color: colorWhite),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: splashColor,
              ),
              onPressed: () {
                playVideo(context, list[i]['filepath']);
              },
            ),
            onTap: () {
              playVideo(context, list[i]['filepath']);
            },
          );
        });
  }

  void playVideo(BuildContext context, String url) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PlayVideos(
        url: url,
      ),
    ));
  }
}
