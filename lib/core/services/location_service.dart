import 'package:location/location.dart';

class LocationService{
  getLocation() async{
    print("UserLocationBLoc: getting user location");
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    print("UserLocationBloc: ");
    print(_permissionGranted);
    if (_permissionGranted == PermissionStatus.deniedForever) {
      return null;
    } else if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("herehere");
        return null;
      }
    }
    print("UserLocationBLoc: location.getLocation()");
    _locationData = await location.getLocation();
    return _locationData;
  }
}