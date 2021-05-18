import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/connectivity/connectivity_event.dart';
import 'package:streaming_mobile/blocs/connectivity/connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  StreamSubscription _subscription;
  ConnectivityBloc() : super(ConnectivityState.DISCONNECTED);

  @override
  Stream<ConnectivityState> mapEventToState(ConnectivityEvent event) async* {
    if (event is StartListening) {
      Connectivity().onConnectivityChanged.listen((result) {
        if (result == ConnectivityResult.none) {
          add(EmitDisconnectedEvent());
        } else if (result == ConnectivityResult.mobile) {
          add(EmitMobileDataEvent());
        } else if (result == ConnectivityResult.wifi) {
          add(EmitWifiEvent());
        }
      });
    } else if (event is EmitDisconnectedEvent) {
      yield ConnectivityState.DISCONNECTED;
    } else if (event is EmitMobileDataEvent) {
      yield ConnectivityState.MOBILE;
    } else if (event is EmitWifiEvent) {
      yield ConnectivityState.WIFI;
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
