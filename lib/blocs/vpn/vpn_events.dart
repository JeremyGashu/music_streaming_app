//startListenning

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class VPNEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartListening extends VPNEvent {
  final int intervalInSeconds;
  StartListening({@required this.intervalInSeconds})
      : assert(intervalInSeconds != null);
}

class VPNEnabledEvent extends VPNEvent {
  @override
  List<Object> get props => [];
}

class VPNDisabledEvent extends VPNEvent {
  @override
  List<Object> get props => [];
}
