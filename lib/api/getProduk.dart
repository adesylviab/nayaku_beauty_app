import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class Data {
  int id;
  String nama;
  String foto;
  String deskripsi;
  int harga;

  Data({this.id, this.nama, this.foto, this.deskripsi, this.harga});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        nama: json['nama'],
        deskripsi: json['deskripsi'],
        foto: json['foto'],
        harga: json['harga']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama": nama,
      "foto": foto,
      "deskripsi": deskripsi,
      "harga": harga,
    };
  }

  @override
  String toString() {
    return 'Data{id: $id, name: $nama, foto: $foto, deksripsi: $deskripsi}';
  }
}

List<Data> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Data>.from(data.map((item) => Data.fromJson(item)));
}

String profileToJson(Data data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class GetProduk {
  Client client = Client();

  Future<List<Data>> getProfiles() async {
    final response =
        await client.get("https://nayaku-api.herokuapp.com/api/apps/produk");
    if (response.statusCode == 200) {
      print(response.body);
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }
}
