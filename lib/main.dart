import 'package:flutter/material.dart';
import 'package:nayaku_mobile/home_page.dart';
import 'package:nayaku_mobile/login_page.dart';
import 'package:nayaku_mobile/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// void main() =>   runApp(MaterialApp(home: RegisterProfile()));
void main() async {
  runApp(Check());
}

class Check extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nayaku',
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('id');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = Homepage();
    } else {
      child = LoginPage();
    }
    return Scaffold(
      body: child,
    );
  }
}
