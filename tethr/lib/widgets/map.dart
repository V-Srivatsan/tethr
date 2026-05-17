import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:tethr/lib/location.dart';
import 'loader.dart';

class TethrMap extends StatefulWidget {
  final Iterable<Marker>? markers;
  final bool interactive;
  const TethrMap({super.key, this.markers = null, this.interactive = true });

  @override
  State<TethrMap> createState() => _TethrMapState();
}

class _TethrMapState extends State<TethrMap> {

  bool loading = true;
  late final Position pos;

  @override
  void initState() {
    super.initState();
    () async {
      try {
        final currPos = await Location.getCurrent();
        setState(() { pos = currPos; loading = false; });
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Could not retrieve location"),
        ));
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Loader(
      loading: loading,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 17
        ),
        zoomControlsEnabled: false, myLocationEnabled: true,
        minMaxZoomPreference: MinMaxZoomPreference(15, 19),
        compassEnabled: false, markers: widget.markers?.toSet() ?? Set(),
        scrollGesturesEnabled: widget.interactive,
      )
    );
  }
}
