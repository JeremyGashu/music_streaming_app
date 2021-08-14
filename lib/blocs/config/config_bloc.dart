import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/config/config_event.dart';
import 'package:streaming_mobile/blocs/config/config_state.dart';
import 'package:streaming_mobile/data/models/config.dart';
import 'package:streaming_mobile/data/repository/config_repository.dart';

class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final ConfigRepository configRepository;
  ConfigBloc({@required this.configRepository}) : super(InitialState());

  @override
  Stream<ConfigState> mapEventToState(ConfigEvent event) async* {
    if (event is LoadConfigData) {
      yield LoadingConfigData();
      try {
        ConfigData configData = await configRepository.getConfigData();
        yield LoadedConfigData(configData: configData);
      } catch (e) {
        yield LoadingConfigDataFailed(message: 'Error Loading Config Data!');
      }
    }
  }
}
