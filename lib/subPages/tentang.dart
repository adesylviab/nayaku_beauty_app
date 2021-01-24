import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nayaku_mobile/getBody/tentangResponse.dart';
import 'package:nayaku_mobile/home_page.dart';
import 'package:nayaku_mobile/subPages/maps.dart';

class Tentang extends StatefulWidget {
  @override
  _TentangState createState() => _TentangState();
}

class _TentangState extends State<Tentang> {
  TentangResponse tentangResponse = null;
  String alamat, no_hp;

  @override
  void initState() {
    TentangResponse.getTentangContact().then((value) {
      print(value.data.name);
      setState(() {
        alamat = value.data.name;
        no_hp = value.data.contact;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Column(children: [
            Text(
              'Alamat:',
              style: TextStyle(fontSize: 19.0),
            ),
            Text(
              alamat ?? '',
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            Container(
              height: 20.0,
            ),
            Text(
              'Contact Person:',
              style: TextStyle(fontSize: 19.0),
            ),
            Text(
              no_hp ?? '',
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
            Container(
              height: 20.0,
            ),
            Container(
              child: RaisedButton(
                color: Color(0XFFFF0000),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Maps(),
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Temukan Di Peta',
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.map,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
