import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class DataHistory {
  int id;

  String treatment;
  String hasil;
  String type;
  String created_at;

  DataHistory(
      {this.id, this.treatment, this.hasil, this.type, this.created_at});

  factory DataHistory.fromJson(Map<String, dynamic> json) {
    return DataHistory(
      id: json['id'],
      treatment: json['treatment'],
      hasil: json['hasil'],
      type: json['type'],
      created_at: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "treatment": treatment,
      "hasil": hasil,
      "type": type,
      "created_at": created_at,
    };
  }

  @override
  String toString() {
    return 'Data{id: $id}';
  }
}

List<DataHistory> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<DataHistory>.from(data.map((item) => DataHistory.fromJson(item)));
}

String profileToJson(DataHistory data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class GetHistory {
  Client client = Client();

  Future<List<DataHistory>> getProfiles(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('id');
    print("tokenku: $stringValue");
    String _token = stringValue.replaceAll(new RegExp('"'), '');

    final response = await client.post(
        "https://nayaku-api.herokuapp.com/api/apps/history",
        body: {'id_user': _token});
    if (response.statusCode == 200) {
      print(response.body);
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }
}
