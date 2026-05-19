import 'package:flutter/material.dart';
import 'package:tethr/widgets/fragment.dart';
import 'info.dart';
import 'members.dart';

import 'package:tethr/lib/profile.dart';
import './logic.dart' as logic;

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool loading = true;
  String? name, description;
  Map<String, logic.Member> members = {};

  @override
  void initState() {
    super.initState();

    () async {
      final res = await logic.getInfo(context);
      setState(() {
        loading = false;
        if (res != null) {
          members = res["members"];
          name = res["name"]; description = res["description"];
        }
      });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Fragment(
      loading: loading, title: "Community Info",
      body: SafeArea(child: Padding(
        padding: .only(left: 15, right: 15, top: 10),
        child: !Profile.comm_verified ?
          Center(child: Text("Community verification pending...")) :
          SingleChildScrollView(child: Column(
            mainAxisSize: .min, crossAxisAlignment: .stretch, spacing: 20,
            children: [

              Info(name: name ?? "", description: description ?? ""),
              Divider(),
              Members(members)

            ],
          )),
      )),
    );
  }
}

