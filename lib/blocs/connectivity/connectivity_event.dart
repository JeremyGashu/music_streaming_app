import 'package:equatable/equatable.dart';

class ConnectivityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartListening extends ConnectivityEvent {
  @override
  List<Object> get props => [];
}

class EmitWifiEvent extends ConnectivityEvent {
  @override
  List<Object> get props => [];
}

class EmitMobileDataEvent extends ConnectivityEvent {
  @override
  List<Object> get props => [];
}

class EmitDisconnectedEvent extends ConnectivityEvent {
  @override
  List<Object> get props => [];
}
