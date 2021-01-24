import 'dart:convert';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:nayaku_mobile/api/api_login.dart';
import 'package:nayaku_mobile/login_page.dart';
import 'package:nayaku_mobile/produk.dart';
import 'package:nayaku_mobile/subPages/history.dart';
import 'package:nayaku_mobile/subPages/konsultasi.dart';
import 'package:nayaku_mobile/tips.dart';
import 'package:nayaku_mobile/subPages/tentang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

final String url =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5P-DEf3fFvZS3hS0KqUATQ0TsViPk3K_tOQ&usqp=CAU';
final Color green = Color(0xFF1E8161);
bool _isLoading = false;
var token, nama, icon;

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('id');
    if (token == null) {
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      _getData(token);
    }
  }

  void _getData(String _token) async {
    var data = {'id': _token};
    print(data);
    var res = await Network().authData(data, 'api/apps/home');
    var body = json.decode(res.body);
    print(body['data']['name']);
    if (body['status'] == 200) {
      setState(() {
        nama = body['data']['name'];
        icon = body['data']['icon'];
      });
    } else {
      // Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showMyDialog();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(32),
                  bottomLeft: Radius.circular(32)),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Column(
                        children: <Widget>[],
                      ),
                    ),
                    CircularProfileAvatar(
                      '',
                      radius: 50, // sets radius, default 50.0
                      backgroundColor: Colors
                          .transparent, // sets background color, default Colors.white
                      borderWidth: 10, // sets border, default 0.0
                      initialsText: Text(
                        icon ?? '',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ), // sets initials text, set your own style, default Text('')
                      borderColor: Colors
                          .greenAccent, // sets border color, default Colors.white
                      elevation:
                          5.0, // sets elevation (shadow of the profile picture), default value is 0.0
                      foregroundColor: Colors.brown.withOpacity(
                          0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                      cacheImage:
                          true, // allow widget to cache image against provided url
                      onTap: () {
                        print('adil');
                      }, // sets on tap
                      showInitialTextAbovePicture:
                          true, // setting it true will show initials text above profile picture, default false
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: <Widget>[],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    nama ?? '',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 3,
            padding: EdgeInsets.all(42),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 0,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Konsultasi(),
                          ));
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.table_chart,
                            ),
                            Text('Konsultasi'),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          child: RaisedButton(
                            color: Colors.white,
                            elevation: 0,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => History(),
                              ));
                            },
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.history,
                                ),
                                Text('History'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 0,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Produk(),
                          ));
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.shopping_bag,
                            ),
                            Text('Produk'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 0,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Tips(),
                          ));
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.library_books,
                            ),
                            Text('Tips'),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: RaisedButton(
                        color: Colors.white,
                        elevation: 0,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Tentang(),
                          ));
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.blur_circular,
                            ),
                            Text('Tentang'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Apakah Anda Yakin?"),
          content:
              new Text("Setelah Log Out Anda Akan diarahkan Ke Form Login"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Log Out"),
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('id');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
