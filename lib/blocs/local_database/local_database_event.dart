import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LocalDatabaseEvent extends Equatable {}

class ReadLocalDB extends LocalDatabaseEvent{
  final String boxName;
  final String key;

  ReadLocalDB({@required this.boxName,@required this.key}):assert(boxName!=null && key!=null);

  List<Object> get props => [boxName, key];
}

class InitLocalDB extends LocalDatabaseEvent {
  @override
  List<Object> get props => [];
}

class WriteToLocalDB extends LocalDatabaseEvent {
  final String boxName;
  final String key;
  final dynamic value;

  WriteToLocalDB({@required this.boxName,@required  this.key,@required  this.value}):assert(boxName!=null && key!=null && value!=null);

  List<Object> get props => [boxName, key];
}

class DeleteFromLocalDB extends LocalDatabaseEvent {
  final String boxName;
  final String key;

  DeleteFromLocalDB({@required this.boxName,@required  this.key}):assert(boxName!=null && key!=null);

  List<Object> get props => [boxName, key];
}

class UpdateFromLocalDB extends LocalDatabaseEvent {
  final String boxName;
  final String key;
  final dynamic value;

  UpdateFromLocalDB({@required this.boxName,@required this.key,@required this.value}):assert(boxName!=null && key!=null && value!=null);

  List<Object> get props => [boxName, key];
}