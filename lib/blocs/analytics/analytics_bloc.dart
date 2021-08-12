import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/analytics/analytics_state.dart';
import 'package:streaming_mobile/data/repository/analytics_repository.dart';

import 'analytics_event.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository analyticsRepository;
  AnalyticsBloc({this.analyticsRepository}) : super(InitialState());

  @override
  Stream<AnalyticsState> mapEventToState(AnalyticsEvent event) async* {
    if (event is SendAnalyticsData) {
      yield SendingAnalyticsData();
      try {
        bool isSent = await analyticsRepository.sendAnalyticsData(
            analytics: event.analytics);
        if (isSent) {
          yield SentAnalyticsData();
        } else {
          yield SendingAnalyticsDataError(
              message: 'Failed to send analytics data!');
        }
      } catch (e) {
        yield SendingAnalyticsDataError(
            message: 'Failed to send analytics data!');
        print(e);
      }
    }
  }
}
