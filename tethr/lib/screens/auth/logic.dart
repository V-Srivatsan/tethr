import 'package:flutter/material.dart';
import 'package:tethr/lib/net.dart' as net;
import 'package:tethr/lib/store.dart';

Future<bool> sendOTP(BuildContext ctx, Map<String, dynamic> data) async {
  final res = await net.request(
      ctx, data: data,
      path: "/user/auth/login/", method: net.REQUEST.POST,
  );
  return res != null;
}

Future<bool> verifyOTP(BuildContext ctx, Map<String, dynamic> data) async {
  final res = await net.request(
    ctx, data: data,
    path: "/user/auth/verify/", method: net.REQUEST.POST,
  );
  if (res == null) return false;

  Store.set(Store.TOKEN, res["token"]);
  Store.set(Store.REFRESH_TOKEN, res["refresh_token"]);
  Store.set(Store.NAME, res["name"]);
  PrefStore.clear();
  return true;
}

Future<bool> signup(BuildContext ctx, Map<String, dynamic> data) async {
  final res = await net.request(
    ctx, data: data,
    path: "/user/auth/register/", method: net.REQUEST.POST,
  );
  return res != null;
}

