import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './store.dart';

import 'package:tethr/screens/auth/index.dart' as auth_screen;

enum REQUEST { GET, POST, PUT, PATCH, DELETE }

class Response {
  late final bool ok;
  late final int status;
  late final Map<String, dynamic> data;

  Response(http.Response res) {
    this.ok = res.statusCode == 200;
    this.status = res.statusCode;
    this.data = res.body.isEmpty ? {} : jsonDecode(res.body) as Map<String, dynamic>;
  }
}

Future<Response> _request(
  String path, {
    REQUEST method = REQUEST.GET,
    Map<String, String>? query,
    Map<String, dynamic>? data,
    bool auth = false
  }
) async {
  final uri = Uri.https("sponge-romantic-pangolin.ngrok-free.app", path, query);
  final body = data == null ? null : jsonEncode(data);

  final Map<String, String> headers = method == REQUEST.GET ? {} : {"Content-Type": "application/json"};
  if (auth)
      headers["Authorization"] = (await Store.get(Store.TOKEN))!;

  print("$method $uri");

  http.Response res;
  switch(method) {
    case REQUEST.GET:
      res = await http.get(uri, headers: headers);
      break;
    case REQUEST.POST:
      res = await http.post(uri, headers: headers, body: body);
      break;
    case REQUEST.PUT:
      res = await http.put(uri, headers: headers, body: body);
      break;
    case REQUEST.PATCH:
      res = await http.patch(uri, headers: headers, body: body);
      break;
    case REQUEST.DELETE:
      res = await http.delete(uri, headers: headers, body: body);
      break;
  }

  final r = Response(res);
  print(r.data);

  return r;
}

Future<Map<String, dynamic>?> request(
  BuildContext context, {
    required String path,
    REQUEST method = REQUEST.GET,
    Map<String, String>? query,
    Map<String, dynamic>? data,
    bool auth = false, bool showError = true
  }
) async {
  Response res = await _request(path, method: method, query: query, data: data, auth: auth);

  if (res.status == 401) {
    final auth_res = await _request("/user/auth/refresh/", method: REQUEST.PUT, data: {
      "refresh_token": await Store.get(Store.REFRESH_TOKEN)
    });

    if (!auth_res.ok)
      return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => auth_screen.Screen()),
        (_) => false
      );

    await Store.set(Store.TOKEN, auth_res.data["token"]);
    Store.set(Store.REFRESH_TOKEN, auth_res.data["refresh_token"]);

    res = await _request(path, method: method, query: query, data: data, auth: auth);
  }

  if (res.ok) return res.data;
  if (showError)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res.data["detail"] ?? res.data["message"] ?? "An unexpected error occurred")
    ));
  return null;
}