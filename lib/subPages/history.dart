import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nayaku_mobile/api/getHistory.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  String name, token;
  double lat, lng;
  var imgUrl =
      'https://media.tabloidbintang.com/files/thumb/92bc280c3b0a6e1f22a2ba3cccdc82d7.jpg';
  var title = 'Pedagang Bakso';
  var desc =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Consectetur a erat nam at.';
  GetHistory getHome;
  @override
  void initState() {
    getTokenLogin();
    getHome = GetHistory();
    super.initState();
  }

  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('id');
    token = stringValue;
  }

  DateTime tempDate;

  @override
  Widget build(BuildContext context) {
    GetHistory().getProfiles(token).then((value) => print("value: $value"));
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.greenAccent,
      ),
      body: FutureBuilder(
        future: getHome.getProfiles(token),
        builder:
            (BuildContext context, AsyncSnapshot<List<DataHistory>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<DataHistory> profiles = snapshot.data;
            return _buildListView(profiles);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<DataHistory> profiles) {
    return profiles.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (context, index) {
                DataHistory profile = profiles[index];
                tempDate =
                    new DateFormat("yyyy-MM-dd").parse(profile.created_at);
                return Container(
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: Container(
                          padding: EdgeInsets.all(10.0),
                          width: MediaQuery.of(context).size.width,
                          child: Container(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(6),
                                      bottomLeft: Radius.circular(6))),
                              child: Container(
                                child: Table(
                                  border: TableBorder.all(
                                      color: Colors.black26,
                                      width: 1,
                                      style: BorderStyle.none),
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                          child:
                                              Center(child: Text('Tanggal'))),
                                      TableCell(
                                        child: Center(child: Text(':')),
                                      ),
                                      TableCell(
                                          child: Center(
                                        child: Text(tempDate.day.toString() +
                                            "-" +
                                            tempDate.month.toString() +
                                            "-" +
                                            tempDate.year.toString()),
                                      )),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                          child:
                                              Center(child: Text('Perawatan'))),
                                      TableCell(
                                        child: Center(child: Text(':')),
                                      ),
                                      TableCell(
                                          child: Center(
                                              child: Text(profile.treatment))),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                          child: Center(child: Text('Produk'))),
                                      TableCell(
                                        child: Center(child: Text(':')),
                                      ),
                                      TableCell(
                                          child: Center(
                                              child: Text(profile.hasil))),
                                    ]),
                                    TableRow(children: [
                                      TableCell(
                                          child: Center(child: Text('Kulit'))),
                                      TableCell(
                                        child: Center(child: Text(':')),
                                      ),
                                      TableCell(
                                          child: Center(
                                              child: Text(profile.type))),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              },
              itemCount: profiles.length,
            ),
            onRefresh: () => getHome.getProfiles(token),
          )
        : Center(child: CircularProgressIndicator());
  }
}
