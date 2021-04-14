import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_state.dart';
import 'package:streaming_mobile/core/services/location_service.dart';

enum UserLocationEvent { Init, GetUserLocation }

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  final LocationService locationService;
  static LocationData _location;
  var _timer;
  UserLocationBloc({@required this.locationService}) : assert(locationService!=null),super(UserLocationLoadBusy());

  @override
  Stream<UserLocationState> mapEventToState(UserLocationEvent event) async* {
    try {
      yield UserLocationLoadBusy();
      if (event == UserLocationEvent.Init) {
        _location = await locationService.getLocation();
        print(_location);
        if (_location == null) {
          yield UserLocationLoadFailed();
        } else {
          print('here');
          yield UserLocationLoadSuccess(location: _location);
        }

        _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
          var serviceEnabled = await Location.instance.serviceEnabled();
          print(serviceEnabled);
          if(!serviceEnabled){
            add(UserLocationEvent.Init);
            timer?.cancel();
          }
        });

      } else if (event == UserLocationEvent.GetUserLocation) {
        if (_location != null) {
          yield UserLocationLoadSuccess(location: _location);
        } else {
          add(UserLocationEvent.Init);
          yield UserLocationLoadBusy();
        }
      }
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      print("UserLocationBLoc: getting user location failed");
      yield UserLocationLoadFailed();
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
