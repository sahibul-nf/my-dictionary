import 'dart:convert';

import 'package:http/http.dart' as http;

class NabiRasul {

  String name;
  String id;
  

  NabiRasul({this.id, this.name});

  factory NabiRasul.createNabiRasul(Map<String, dynamic> object) {
    return NabiRasul(
      id: object['id'],
      name: object['name']
    );
  }

  static Future<List<NabiRasul>> getData() async {
    String urlAPI = 'http://192.168.43.208/my-dictionary-server/get_data.php';
    final apiResult = await http.get(urlAPI);
    List<dynamic> jsonObject = jsonDecode(apiResult.body);

    List<NabiRasul> list = [];
    for (var i = 0; i < jsonObject.length; i++)
      list.add(NabiRasul.createNabiRasul(jsonObject[i]));

    return list;
  }
}