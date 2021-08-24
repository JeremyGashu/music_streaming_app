import 'package:equatable/equatable.dart';
import 'package:streaming_mobile/data/models/analytics.dart';

class AnalyticsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendAnalyticsData extends AnalyticsEvent {
  final Analytics analytics;

  SendAnalyticsData({this.analytics});
  @override
  List<Object> get props => [analytics];
}
