import 'package:equatable/equatable.dart';
import 'package:streaming_mobile/data/models/analytics.dart';

class AnalyticsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendAnalyticsData extends AnalyticsEvent {

  @override
  List<Object> get props => [];
}


class SaveAnalyticsData extends AnalyticsEvent {
  final Analytics analytics;

  SaveAnalyticsData({this.analytics});

  @override
  List<Object> get props => [analytics];
}
