import 'dart:convert';
import './store.dart';

class Profile {

  static late String name, phone, role; static late bool verified;
  static String? community; static late bool comm_verified, comm_admin;

  static void update(Map<String, dynamic> data, [bool save = true]) {
    name = data["user"]["name"]; phone = data["user"]["phone"];
    role = data["user"]["role"]; verified = data["user"]["verified"];

    community = data["community"]?["name"];
    comm_verified = data["community"]?["verified"] ?? false;
    comm_admin = data["community"]?["is_admin"] ?? false;

    if (save)
      Store.set(Store.PROFILE, jsonEncode({
        "user": {
          "name": name, "phone": phone, "role": role,
          "verified": verified
        },
        "community": community == null ? null : {
          "name": community!, "verified": comm_verified,
          "is_admin": comm_admin
        }
      }));
  }

  static Future<void> load() async {
    final data = jsonDecode((await Store.get(Store.PROFILE))!);
    update(data, false);
  }
}