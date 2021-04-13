part of 'vpn_checker_bloc.dart';

abstract class VpnCheckerState extends Equatable {
  const VpnCheckerState();
  
  @override
  List<Object> get props => [];
}

class VpnCheckerInitial extends VpnCheckerState {}
