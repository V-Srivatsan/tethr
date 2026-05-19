import 'package:flutter/cupertino.dart';
import 'package:tethr/lib/net.dart';
import 'package:tethr/lib/profile.dart';

class Request {
  final String user, title, content;
  final DateTime timestamp;
  const Request({
    required this.user, required this.title,
    required this.content, required this.timestamp
  });
}

Future<List<Request>?> getRequests(BuildContext ctx) async {
  if (!Profile.comm_verified) return null;

  final res = await request(
    ctx, method: .GET, path: "/request/",
    auth: true, showError: false
  );
  if (res == null) return null;

 return (res["requests"] as List).map((e) => Request(
    user: e["user"], title: e["title"], content: e["content"],
    timestamp: DateTime.parse(e["timestamp"])
  )).toList(growable: false);
}