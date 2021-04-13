import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vpn_checker_event.dart';
part 'vpn_checker_state.dart';

class VpnCheckerBloc extends Bloc<VpnCheckerEvent, VpnCheckerState> {
  VpnCheckerBloc() : super(VpnCheckerInitial());

  @override
  Stream<VpnCheckerState> mapEventToState(
    VpnCheckerEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
