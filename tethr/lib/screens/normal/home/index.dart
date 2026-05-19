import 'package:flutter/material.dart';
import 'package:tethr/widgets/loader.dart';

import 'package:tethr/screens/normal/community/setup/index.dart' as comm_setup;
import 'package:tethr/screens/normal/community/info/index.dart' as comm_info;
import 'package:tethr/lib/profile.dart';
import './logic.dart' as logic;

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool loading = true;
  List<dynamic> requests = [];

  @override
  void initState() {
    super.initState();

    () async {
      final res = await logic.getRequests(context);
      if (mounted) setState(() { loading = false; requests = res ?? []; });
      else { loading = false; requests = res ?? []; }
    }();
  }

  @override
  Widget build(BuildContext context) {
    
    return Loader(
      loading: loading,
      child: !loading && Profile.community == null ?
        Center(child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder: (ctx) => comm_setup.Screen()
            )),
            child: Text("Join Community")
        )) :
        SingleChildScrollView(child: Column(
          mainAxisSize: .min,
          children: [

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF007A71), Color(0xFF00B3A0)],
                  begin: Alignment.topCenter, end: Alignment.bottomCenter
                )
              ),
              child: ListTile(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => comm_info.Screen())),
                title: Text(Profile.community ?? "", style: TextStyle(color: Colors.white)),
                subtitle: Text("View community info", style: TextStyle(color: Colors.white70)),
                trailing: Icon(Icons.chevron_right, color: Colors.white),
              )
            ),
          ]
        ))
    );
  }
}
