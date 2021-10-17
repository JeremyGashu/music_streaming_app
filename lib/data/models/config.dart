import 'package:equatable/equatable.dart';

class ConfigData extends Equatable {
  final String version;
  final bool forceUpdate;

  ConfigData({this.version, this.forceUpdate = false});

  factory ConfigData.fromJson(Map<String, dynamic> json) => ConfigData(
        version: json['version'],
        forceUpdate: json['force_update'],
      );

  Map<String, dynamic> toJson() => {
        "version": version,
        'force_update': forceUpdate,
      };

  @override
  List<Object> get props => [version, forceUpdate];
}
