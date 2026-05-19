import 'package:flutter/cupertino.dart';
import 'package:tethr/lib/net.dart' as net;

Future<List<dynamic>> getCommunities(BuildContext ctx, double lat, double lng) async {
  final res = await net.request(
      ctx, path: "/community/",
      query: { "lat": lat.toString(), "lng": lng.toString()
  });
  return res == null ? [] : res["communities"];
}

Future<bool> createCommunity(BuildContext ctx, Map<String, dynamic> data) async {
  final res = await net.request(ctx, path: "/community/", method: .POST, data: data, auth: true);
  return res != null;
}

Future<bool> joinCommunity(BuildContext ctx, String uid, String name) async {
  final res = await net.request(ctx, path: "/community/join/$uid/", method: .POST, auth: true);
  return res != null;
}

