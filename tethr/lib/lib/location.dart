import 'package:geolocator/geolocator.dart';

class Location {
  static Future<Position> getCurrent() async {
    if ((await Geolocator.isLocationServiceEnabled()) == false)
      await Geolocator.openLocationSettings();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == .unableToDetermine || permission == .denied)
      permission = await Geolocator.requestPermission();
    if (permission == .denied || permission == .deniedForever)
      await Geolocator.openAppSettings();

    return await Geolocator.getCurrentPosition();
  }
}