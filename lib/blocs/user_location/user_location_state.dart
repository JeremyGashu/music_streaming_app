import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class UserLocationState extends Equatable{}

class UserLocationLoadBusy extends UserLocationState{
  @override
  List<Object> get props => [];
}

class UserLocationLoadSuccess extends UserLocationState{
  final location;

  UserLocationLoadSuccess({@required this.location}):assert(location!=null);

  @override
  // TODO: implement props
  List<Object> get props => [location];
}

class UserLocationLoadFailed extends UserLocationState{
  @override
  List<Object> get props => [];
}