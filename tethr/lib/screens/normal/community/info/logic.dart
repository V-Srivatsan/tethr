import 'package:flutter/material.dart';
import 'package:tethr/lib/net.dart' as net;
import 'package:tethr/lib/profile.dart';

class Member {
  final String uid;
  final String name, phone;
  bool is_admin, verified;

  Member({
    required this.uid,
    required this.name, required this.phone,
    required this.is_admin, required this.verified
  });
}

Future<Map<String, dynamic>?> getInfo(BuildContext context) async {
  if (!Profile.comm_verified) return null;
  final res = await net.request(context, path: "/community/info/", auth: true);
  if (res == null) return null;

  return {
    "name": res["name"], "description": res["description"],
    "members": (res["members"] as Map<String, dynamic>).map(
      (uid, member) => MapEntry(uid, Member(
        uid: uid, name: member["name"], phone: member["phone"],
        is_admin: member["is_admin"], verified: member["verified"]
      ))
    )
  };
}

Future<bool> acceptMembership(BuildContext ctx, String uid) async {
  final res = await net.request(ctx, path: "/community/membership/$uid/", method: .PUT, auth: true);
  return res != null;
}

Future<bool> rejectMembership(BuildContext ctx, String uid) async {
  final res = await net.request(ctx, path: "/community/membership/$uid/", method: .DELETE, auth: true);
  return res != null;
}


Future<bool> makeAdmin(BuildContext ctx, String uid) async {
  final res = await net.request(ctx, path: "/community/membership/$uid/admin/", method: .PUT, auth: true);
  return res != null;
}

Future<bool> removeAdmin(BuildContext ctx, String uid) async {
  final res = await net.request(ctx, path: "/community/membership/$uid/admin/", method: .DELETE, auth: true);
  return res != null;
}

Future<bool> removeFromCommunity(BuildContext ctx, String uid) async {
  final res = await net.request(ctx, path: "/community/membership/$uid/", method: .DELETE, auth: true);
  return res != null;
}