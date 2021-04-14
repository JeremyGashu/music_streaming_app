import 'dart:async';

import 'package:check_vpn_connection/check_vpn_connection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_events.dart';
import 'package:streaming_mobile/blocs/vpn/vpn_state.dart';

class VPNBloc extends Bloc<VPNEvent, VPNState> {
  VPNBloc() : super(InitialVPNState());

  @override
  Stream<VPNState> mapEventToState(VPNEvent event) async* {
    if (event is StartListening) {
      Timer.periodic(Duration(seconds: event.intervalInSeconds), (timer) async {
        bool status = await CheckVpnConnection.isVpnActive();
        if (status) {
          print('VPN Enabled!');
          add(VPNEnabledEvent());
        } else {
          print('VPN Disabled!');
          add(VPNDisabledEvent());
        }
      });
    } else if (event is VPNEnabledEvent) {
      yield VPNEnabled();
    } else if (event is VPNDisabledEvent) {
      yield VPNDisabled();
    }
  }
}
