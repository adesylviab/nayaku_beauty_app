import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class TentangResponse {
  Data data;
  int status;
  String message;

  TentangResponse({this.data, this.status, this.message});

  factory TentangResponse.getTentang(Map<String, dynamic> object) {
    return TentangResponse(
      data: object['data'][0] != null
          ? new Data.fromJson(object['data'][0])
          : null,
      status: object['status'],
      message: object['message'],
    );
  }

  static Future<TentangResponse> getTentangContact() async {
    String url = "https://nayaku-api.herokuapp.com/api/apps/tentang";
    var apiResult = await http.get(url);
    var jsonObject = json.decode(apiResult.body);
    print(jsonObject);
    return TentangResponse.getTentang(jsonObject);
  }
}

class Data {
  int id;
  String name;
  String contact;
  String detail;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
      this.name,
      this.contact,
      this.detail,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contact = json['contact'];
    detail = json['detail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['detail'] = this.detail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
