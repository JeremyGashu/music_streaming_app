import 'package:equatable/equatable.dart';

class AnalyticsState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialState extends AnalyticsState {}

class SendingAnalyticsData extends AnalyticsState {}

class SentAnalyticsData extends AnalyticsState {}

class SendingAnalyticsDataError extends AnalyticsState {
  final String message;
  SendingAnalyticsDataError({this.message});
}