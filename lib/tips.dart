import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:nayaku_mobile/api/getHome.dart';

class Tips extends StatefulWidget {
  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  GetHome getHome;
  @override
  void initState() {
    getHome = GetHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GetHome().getProfiles().then((value) => print("value: $value"));
    return Container(
      color: Colors.greenAccent,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tips'),
          backgroundColor: Colors.greenAccent,
        ),
        body: FutureBuilder(
          future: getHome.getProfiles(),
          builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                    "Something wrong with message: ${snapshot.error.toString()}"),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<Data> profiles = snapshot.data;
              return _buildListView(profiles);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<Data> profiles) {
    return profiles.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (context, index) {
                Data profile = profiles[index];
                return Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(6),
                                          bottomLeft: Radius.circular(6))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 4,
                                      ),
                                      ExpandablePanel(
                                        header: Text(profile.judul),
                                        expanded: Html(
                                          data: profile.post,
                                          //Optional parameters:
                                          style: {
                                            "html": Style(
                                              backgroundColor: Colors.black12,
                                            ),
                                            "table": Style(
                                              backgroundColor: Color.fromARGB(
                                                  0x50, 0xee, 0xee, 0xee),
                                            ),
                                            "tr": Style(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey)),
                                            ),
                                            "th": Style(
                                              padding: EdgeInsets.all(6),
                                              backgroundColor: Colors.grey,
                                            ),
                                            "td": Style(
                                              padding: EdgeInsets.all(6),
                                            ),
                                            "var": Style(fontFamily: 'serif'),
                                          },
                                          customRender: {
                                            "flutter": (RenderContext context,
                                                Widget child, attributes, _) {
                                              return FlutterLogo(
                                                style:
                                                    (attributes['horizontal'] !=
                                                            null)
                                                        ? FlutterLogoStyle
                                                            .horizontal
                                                        : FlutterLogoStyle
                                                            .markOnly,
                                                textColor: context.style.color,
                                                size: context
                                                        .style.fontSize.size *
                                                    5,
                                              );
                                            },
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: profiles.length,
            ),
            onRefresh: () => getHome.getProfiles(),
          )
        : Center(child: CircularProgressIndicator());
  }
}
