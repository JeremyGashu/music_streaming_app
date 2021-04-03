import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LocalDatabaseState extends Equatable {}

class LocalDBSuccess extends LocalDatabaseState{
  final data;

  LocalDBSuccess({@required this.data});

  @override
  List<Object> get props => [data];
}

class LocalDBIdle extends LocalDatabaseState{
  @override
  List<Object> get props => [];
}

class LocalDBBusy extends LocalDatabaseState{
  @override
  List<Object> get props => [];
}

class LocalDBFailed extends LocalDatabaseState{
  @override
  List<Object> get props => [];
}