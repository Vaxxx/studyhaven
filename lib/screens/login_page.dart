import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:studyhaven/student/student_dashboard.dart';
import 'package:studyhaven/teacher/teacher_dashboard.dart';
import 'package:studyhaven/utilities/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//declared variables
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool showSpinner = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _validate = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

////////////////////////////////////////////////portrait section///////////////////////////
  Widget portrait() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Haven'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: colorWhite),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //////////////////////////////////////ITEM 1 //////////////////////////////////////////////////////////
              clipPathContainer(),
              //////////////////////////////////////ITEM 2 //////////////////////////////////////////////////////////
              Form(
                key: _formKey,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    emailContainer(),
                    passwordContainer(),
                    loginButtonContainer(),
                  ],
                ),
              ),
              googleLoginButtonContainer(),
              registerButtonContainer(),
              ////////////////////////////////////// END OF ITEM 6 //////////////////////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }

////////////////////////////////////////////////end of portrait section///////////////////////////
  ////////////////////////////////////////////////LAND SCAPE section///////////////////////////
  Widget landscape() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: backgroundImage,
          fit: BoxFit.cover,
        )),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: colorWhite),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //////////////////////////////////////ITEM 2 //////////////////////////////////////////////////////////
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                ),
                Form(
                  key: _formKey,
                  autovalidate: _validate,
                  child: Column(
                    children: <Widget>[
                      emailContainer(),
                      passwordContainer(),
                      loginButtonContainer(),
                    ],
                  ),
                ),
                googleLoginButtonContainer(),
                registerButtonContainer(),
                ////////////////////////////////////// END OF ITEM 6 //////////////////////////////////////////////////////////
              ],
            ),
          ),
        ),
      ),
    );
  } //end landscape

////////////////////////////////////////////////END OF LANDSCAPE section///////////////////////////
////////////////////////////////////////////////form fields//////////////////////////////////////
  TextFormField emailAddress() {
    return TextFormField(
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your Email',
          labelText: 'Enter your Email',
          hintStyle: TextStyle(color: colorGrey)),
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      validator: validateEmail,
    );
  }

///////////////////////////////////////////////////password field/////////////////////////////
  TextFormField passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your Password',
          labelText: 'Enter your Password',
          hintStyle: TextStyle(color: colorGrey)),
      controller: _passwordController,
      validator: validatePassword,
      obscureText: true,
    );
  }

//////////////////////////////////////////login////////////////////////////////
  login() async {
    String email = _emailController.text.trim();
    String pass = _passwordController.text.trim();
    print('Email..................................$email');
    print('Password.................................$pass');
    if (_formKey.currentState.validate()) {
      //form details were filled correctly
      _formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode()); //hide keyboard
      setState(() {
        showSpinner = true;
      });
      print('....................................');
      //check to see if admin
      if (email == 'admin@mail.com' && pass.trim() == 'administrator') {
        //admin
        Navigator.pushNamed(context, '/admin_dashboard');
        displayMsg('Welcome Admin');
      } else {
        try {
          var data = {"email": email, "password": pass};
          var response = await http.post(selectUserUrl, body: data);
          var msg = jsonDecode(response.body);
          var roleMsg = msg.split("_");
          var newRole = roleMsg[0]; //student
          var newLevel = roleMsg[1];
          print('msg............$msg');
          print('roleMsg...........$roleMsg');
          print('newRole..........$newRole');
          print('newLevel................$newLevel');
          if (newRole == "Teacher") {
            //a teacher has been registered
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => TeacherDashboard(
                level: int.parse(newLevel),
              ),
            ));
          } //if teacher
          else if (newRole == "Student") {
            ///a student exists
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => StudentDashboard(
                level: int.parse(newLevel),
              ),
            ));
          } //else student
          else {
            displayMsg("Wrong Credentials entered");
          }
        } catch (e) {
          print("Error................$e");
          displayMsg("You could be having a network issue!");
          //displayMsg(e);
        }
      }
    } else {
      ///form fields not correctly filled
      setState(() {
        _validate = true;
        displayMsg("Please fill the form with the correct details");
      });
    }
  } //login

  register() {
    Navigator.pushNamed(context, '/register');
  }

  googleLogin() {
    print('googlelogin');
  }

  ///////VALIDATE USER
  String validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is Required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  } //validateEmail

  String validatePassword(String value) {
    if (value.length == 0) {
      return "A Password  is Required";
    } else if (value.length < 5) {
      return "Your Password is too short, it must at least five characters";
    }
    return null;
  } //validateName

////////////////////////////////////////////////////////////////////////////////CONTAINERS FOR THE FORM///////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////CONTAINERS FOR EMAIL///////////////////////////////////////
  Container emailContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colorGreyWithOpacity,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ///First Child is the email address
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.person_outline,
              color: colorGrey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: emailAddress(),
          ),

          ///second child is the password field
        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR EMAIL///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////CONTAINERS FOR PASSWORD///////////////////////////////////////
  Container passwordContainer() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colorGreyWithOpacity, width: 1.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.lock_open,
              color: colorGrey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: colorGreyWithOpacity,
            margin: EdgeInsets.only(right: 10.0),
          ),
          Expanded(
            child: passwordField(),
          )
        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR PASSWORD///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////CONTAINERS FOR CLIP PATH///////////////////////////////////////
  ClipPath clipPathContainer() {
    return ClipPath(
      //ITEM 1...IN THE FRAME
      //add a clipper for the background image
      clipper: MyClipper(),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: backgroundImage,
          fit: BoxFit.cover,
        )),
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 50.0, bottom: 20.0),
        child: Column(
          //the text in the background image
          children: <Widget>[
            Text(
              'Study Haven',
              style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            )
          ],
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR CLIPPATH///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// CONTAINERS FOR LOGIN BUTTON///////////////////////////////////////
  Container loginButtonContainer() {
    return Container(
      margin: EdgeInsets.only(top: 30.0),
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
                      'LOGIN',
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
                          Icons.arrow_forward,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          login();
                        },
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                login();
              },
            ),
          )
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////////////////// END CONTAINERS FOR LOGIN BUTTON///////////////////////////////////////V
//////////////////////////////////////////////////////////////////////////////// CONTAINERS FOR GOOGLE LOGIN BUTTON///////////////////////////////////////
  Container googleLoginButtonContainer() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
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
                      'LOGIN WITH GOOGLE',
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
                          Icons.email,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          googleLogin();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {
                googleLogin();
              },
            ),
          )
        ],
      ),
    );
  }

////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR GOOGLE LOGIN BUTTON///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////// CONTAINERS FOR REGISTER BUTTON///////////////////////////////////////
  Container registerButtonContainer() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.only(left: 20.0),
                alignment: Alignment.center,
                child: Text(
                  "DON'T HAVE AN ACCOUNT?",
                  style: TextStyle(color: primaryColor),
                ),
              ),
              onPressed: () {
                register();
              },
            ),
          )
        ],
      ),
    );
  }
//////////////////////////////////////////////////////////////////////////////// END CONTAINERS FOR REGISTER BUTTON///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////END CONTAINERS FOR THE FORM///////////////////////////////////////
} //loginpagestate

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
