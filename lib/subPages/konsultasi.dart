import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:nayaku_mobile/api/api_login.dart';
import 'package:nayaku_mobile/login_page.dart';
import 'package:nayaku_mobile/subPages/hasil.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Konsultasi extends StatefulWidget {
  @override
  _KonsultasiState createState() => _KonsultasiState();
}

class _KonsultasiState extends State<Konsultasi> {
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  var token, nama, icon;

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('id');
    if (token == null) {
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  //initState
  bool _isLoading = false;
  bool selected = false;
  var userStatus = List<bool>();
  List<User> users;
  List<String> choose = [];
  String dropdownValue = 'Kulit Normal';

  Future<List<User>> _getUsers(String kulit) async {
    var data = await http.post(
        "https://nayaku-api.herokuapp.com/api/apps/complaint",
        body: {'kulit': kulit});

    var jsonData = json.decode(data.body);
    // print(jsonData);

    users = [];

    for (var u in jsonData) {
      User user = User(u["id"], u["keluhan"], u["kulit"]);

      users.add(user);
      userStatus.add(false);
    }

    // print(users.length);

    return users;
  }

  void deleteCheck(String val) {
    print('delete $val');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konsultasi'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        child: Column(
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>[
                'Kulit Normal',
                'Kulit Kering',
                'Kulit Berminyak',
                'Kulit Sensitif',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            FutureBuilder(
              future: _getUsers(dropdownValue),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // print('dataku lah: $snapshot.data');
                if (snapshot.data == null) {
                  print('no data');
                  return Container(child: Center(child: Text("Loading...")));
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapshot.data[index].keluhan),
                          trailing: Checkbox(
                              value: userStatus[index],
                              onChanged: (bool val) {
                                setState(() {
                                  print(userStatus[index] = !userStatus[index]);
                                  if (val == false) {
                                    // deleteCheck(snapshot.data[index].keluhan);
                                    if (choose.length < 0) {
                                      Fluttertoast.showToast(
                                          msg: "Pilih Keluhan",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.greenAccent,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      print(snapshot.data[index].keluhan);
                                      choose
                                          .remove(snapshot.data[index].keluhan);
                                    }
                                  } else {
                                    if (choose.length > 2) {
                                      print(choose.length);
                                      Fluttertoast.showToast(
                                          msg: "Maksimal 3 Keluhan",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.greenAccent,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      userStatus[index] = false;
                                      choose
                                          .remove(snapshot.data[index].keluhan);
                                    } else {
                                      // print(choose.length);
                                      choose.add(snapshot.data[index].keluhan);
                                    }
                                  }
                                  print(choose);
                                });
                              }),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            RaisedButton(
              child: Text(
                " Konsultasi",
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // _getUsers(dropdownValue);
                if (choose.length > 3 || choose.length < 0) {
                  Fluttertoast.showToast(
                      msg: "Pilih 1 Sampai 3 Konsultasi ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.greenAccent,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  _login();
                }
                print(jsonEncode(choose));
              },
              color: Colors.deepOrange,
              textColor: Colors.white,
              splashColor: Colors.grey,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    showAlertDialog(context);
    setState(() {
      _isLoading = true;
    });
    var data = {'kulit': dropdownValue, 'keluhan': choose, 'id_user': token};
    // print(data);
    var res = await Network().authData(data, 'api/apps/konsultasi');
    var body = json.decode(res.body);
    print(body['data'].toString());
    if (body['status'] == 200) {
      Navigator.pop(context);
      if (body['data'].toString() == '[]') {
        Fluttertoast.showToast(
            msg: "Konsultasi Belum Tersedia ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HasilKonsultasi(
                  text: body['data'][0]['hasil'] ?? '',
                  text2: body['data'][1]['hasil'] ?? '',
                  text3: dropdownValue),
            ));
      }
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: body,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setState(() {
      _isLoading = false;
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class User {
  final int id;
  final String keluhan;
  final String kulit;
  User(this.id, this.keluhan, this.kulit);
}

class Choose {
  final String myChoose;
  Choose(this.myChoose);
}
