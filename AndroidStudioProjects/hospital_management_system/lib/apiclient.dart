import 'dart:convert';

import 'package:http/http.dart' as http;

class Client{
  String baseUrl = 'https://precious-twill-cod.cyclic.app';

  Uri parseUrl(String route){
    var url = Uri.parse('$baseUrl/$route');
    return url;
  }

  Future<List> getCollection(table, {String from=''}) async{
    String last = from.replaceAll(' ', '%20');
    print(last);
    var route = from!='' ? '$table/$last' : table;
    try{
      var response = await http.get(parseUrl(route));
      //var response = await http.get(parseUrl('$table/2021-01-01%2000:00:00'));
      /*if(parseUrl(route).toString().contains('https://precious-twill-cod.cyclic.app/consultations')) {
        print(response.body);
      }*/
      return jsonDecode(response.body) as List;
    } catch(e){
      print(e.toString());
    }
    //print(response.body);
    return [];
  }

  Future<String> getResetLink(email) async{
    var response = await http.post(parseUrl('users/reset_password'), body: {"email":email});
    return response.body;
  }

}