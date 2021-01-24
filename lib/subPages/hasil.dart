import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nayaku_mobile/api/api_login.dart';
import 'package:nayaku_mobile/home_page.dart';
import 'package:nayaku_mobile/login_page.dart';
import 'package:nayaku_mobile/subPages/history.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HasilKonsultasi extends StatefulWidget {
  final String text, text2, text3;
  HasilKonsultasi(
      {Key key,
      @required this.text,
      @required this.text2,
      @required this.text3})
      : super(key: key);
  @override
  _HasilKonsultasiState createState() => _HasilKonsultasiState();
}

class _HasilKonsultasiState extends State<HasilKonsultasi> {
  bool _isLoading = false;
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  var token, nama, icon;

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      token = localStorage.getString('id');
    });
    if (token == null) {
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Konsultasi'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: Expanded(
              child: RichText(
                text: new TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: new TextStyle(
                    fontSize: 24.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    new TextSpan(
                        text:
                            'Perawatan Kecantikan Wajah Yang Harus Anda Ambil Adalah: '),
                    new TextSpan(
                        text: widget.text,
                        style: new TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          widget.text2 != null
              ? Container(
                  margin: EdgeInsets.all(10.0),
                  child: Expanded(
                    child: RichText(
                      text: new TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: new TextStyle(
                          fontSize: 24.0,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                              text:
                                  'Produk Kecantikan Wajah Yang Harus Anda Ambil Adalah: '),
                          new TextSpan(
                              text: widget.text2,
                              style:
                                  new TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                )
              : '',
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                child: Text(
                  " Simpan",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  _login();
                },
                color: Colors.deepOrange,
                textColor: Colors.white,
                splashColor: Colors.grey,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
              RaisedButton(
                child: Text(
                  " Hubungi",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  //+62 813-9015-8749
                  FlutterOpenWhatsapp.sendSingleMessage("6281390158749",
                      "Halo, Saya ingin bertanya tentang Perawatan ${widget.text} dan Produk ${widget.text2}");
                },
                color: Colors.deepOrange,
                textColor: Colors.white,
                splashColor: Colors.grey,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _login() async {
    showAlertDialog(context);
    setState(() {
      _isLoading = true;
    });
    var data = {
      'kulit': widget.text3,
      'perawatan': widget.text,
      'produk': widget.text2,
      'id_user': token
    };
    print(data);
    var res = await Network().authData(data, 'api/apps/addhistory');
    var body = json.decode(res.body);
    print(body);
    if (body['status'] == 200) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(),
          ));
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
