import 'package:flutter/cupertino.dart';
import 'package:tethr/lib/net.dart';
import 'package:tethr/lib/profile.dart';

class Announcement {
  final String user, title, content;
  final DateTime timestamp;

  const Announcement(this.user, this.title, this.content, this.timestamp);
}

Future<List<Announcement>?> getAnnouncements(BuildContext ctx) async {
  if (!Profile.verified) return null;
  final res = await request(ctx, path: "/community/announcements/", auth: true);
  if (res == null) return null;

  final List<Announcement> announcements = (res["announcements"] as List)
    .map((ann) => Announcement(
      ann["user"], ann["title"], ann["content"],
      DateTime.parse(ann["created_at"])
    )).toList();

  return announcements;
}

Future<bool> postAnnouncement(BuildContext ctx, Map<String, dynamic> data) async {
  final res = await request(
    ctx, path: "/community/announcements/", auth: true,
    method: .POST, data: data
  );

  return res != null;
}