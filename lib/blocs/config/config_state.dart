import 'package:equatable/equatable.dart';
import 'package:streaming_mobile/data/models/config.dart';

class ConfigState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends ConfigState {}

class LoadingConfigData extends ConfigState {}

class LoadedConfigData extends ConfigState {
  final ConfigData configData;

  LoadedConfigData({this.configData});

  @override
  List<Object> get props => [configData];
}

class LoadingConfigDataFailed extends ConfigState {
  final String message;

  LoadingConfigDataFailed({this.message});
  @override
  List<Object> get props => [message];
}
