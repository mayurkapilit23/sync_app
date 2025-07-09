import 'dart:convert';

import 'package:http/http.dart' as http;

class Repo {
  static const _baseApi = 'http://192.168.15.201:4000/todo/';
  static const _loginApi = 'http://192.168.15.201:4000/todo/sign_in';

  static Future<http.Response> postRequest(var body, String apiUrl) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      print('Login error: $e');
      throw Exception(e.toString());
    }
  }

  static Future<http.Response> getRequest(String url) async {
    try {
      final uri = Uri.parse(url);
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('GET request error: $e');
      throw Exception(e.toString());
    }
  }

  // Future<http.Response?> uploadTask(String taskTitle) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://example.com/api/todos'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(<String, String>{'title': taskTitle}),
  //     );
  //     return response;
  //   } catch (e) {
  //     print('Error uploading task: $e');
  //     return null;
  //   }
  // }
}
