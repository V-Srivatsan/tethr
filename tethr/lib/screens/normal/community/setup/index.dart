import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tethr/lib/location.dart';
import 'package:tethr/widgets/fragment.dart';
import 'package:tethr/widgets/loader.dart';
import 'package:tethr/widgets/map.dart';

import 'package:tethr/screens/normal/dashboard/index.dart' as dashboard;
import './logic.dart' as logic;
import 'create.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  bool loading = true;
  List<dynamic> communities = [];
  late Position pos;

  @override
  void initState() {
    super.initState();
    () async {
      final pos = await Location.getCurrent();
      final comms = await logic.getCommunities(context, pos.latitude, pos.longitude);
      setState(() { loading = false; this.pos = pos; communities = comms; });
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Fragment(
      title: "Join Community",
      body: Loader(
        loading: loading,
        child: SafeArea(child: Column(
          crossAxisAlignment: .center,
          children: [

            Flexible(
              flex: 7,
              child: TethrMap(
                markers: communities.map((comm) => Marker(
                  markerId: MarkerId(comm["uid"]),
                  infoWindow: InfoWindow(title: comm["name"]),
                  position: LatLng(comm["lat"], comm["lng"]),
                  onTap: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Join ${comm['name']}?"),
                        content: Text(comm['description']),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: Text("Cancel")
                          ),

                          ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(ctx);
                                setState(() { loading = true; });

                                final res = await logic.joinCommunity(context, comm["uid"], comm["name"]);
                                if (!res) setState(() { loading = false; });
                                else Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (ctx) => dashboard.Screen()),
                                  (_) => false
                                );
                              },
                              child: Text("Join")
                          )
                        ],
                      )
                  )
                )),
              ),
            ),

            Flexible(
              flex: 3,
              child: Padding(
                padding: .symmetric(vertical: 20, horizontal: 15),
                child: Column(
                  children: [
                    Divider(),
                    Expanded(child: Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => CreateCommunity()
                          ));
                        },
                        child: Padding(
                          padding: .symmetric(horizontal: 30, vertical: 20),
                          child: Column(
                            mainAxisSize: .min, spacing: 5,
                            children: [
                              Text(
                                "Create a Community",
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text("Start a new community for your locality. You will become the admin and will be required to approve new members.")
                            ],
                          ),
                        ),
                      )
                    )),
                  ],
                )
              )
            )
          ],
        ))
      )
    );
  }
}


