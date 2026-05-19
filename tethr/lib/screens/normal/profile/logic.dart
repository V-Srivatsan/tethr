import 'package:flutter/material.dart';
import 'package:tethr/lib/net.dart' as net;
import 'package:tethr/lib/store.dart';
import 'package:tethr/lib/profile.dart';

import 'package:tethr/screens/auth/index.dart' as auth;



Future<void> getProfile(BuildContext ctx) async {
  final res = await net.request(ctx, path: "/user/", auth: true);
  if (res == null) return null;

  Profile.update(res);
}

void signOut(BuildContext ctx) async {
  await PrefStore.clear();
  await Store.clear();
  Navigator.of(ctx).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => auth.Screen()),
    (_) => false
  );
}

