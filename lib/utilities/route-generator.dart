import 'package:flutter/material.dart';
import 'package:studyhaven/admin/admin_dashboard.dart';
import 'package:studyhaven/admin/create_teacher.dart';
import 'package:studyhaven/screens/login_page.dart';
import 'package:studyhaven/screens/register.dart';
import 'package:studyhaven/student/student_dashboard.dart';
import 'package:studyhaven/teacher/teacher_create_course.dart';
import 'package:studyhaven/teacher/teacher_dashboard.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
      case '/admin_dashboard':
        return MaterialPageRoute(
          builder: (_) => AdminDashboard(),
        );
      case '/teacher_dashboard':
        return MaterialPageRoute(
          builder: (_) => TeacherDashboard(),
        );
      case '/student_dashboard':
        return MaterialPageRoute(
          builder: (_) => StudentDashboard(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => Register(), //register a student
        );
      case '/create_teacher':
        return MaterialPageRoute(
          builder: (_) => CreateTeacher(), //register a teacher
        );
      case '/teacher_create_course':
        return MaterialPageRoute(
          builder: (_) => TeacherCreateCourse(), //register a teacher
        );
      default:
        return _errorRoute();
    } //switch
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error Page'),
        ),
        body: Center(
          child: Text('AN ERROR HAS OCCURED!'),
        ),
      );
    });
  } //error ROUTE
} //end RouteGenerator
