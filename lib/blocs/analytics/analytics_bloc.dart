import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_mobile/blocs/analytics/analytics_state.dart';
import 'package:streaming_mobile/data/repository/analytics_repository.dart';

import 'analytics_event.dart';

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository analyticsRepository;
  AnalyticsBloc({this.analyticsRepository}) : super(InitialState());

  @override
  Stream<AnalyticsState> mapEventToState(AnalyticsEvent event) async* {
    if (event is SendAnalyticsDataOnAppInit) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      yield SendingAnalyticsData();
      try {
        String savedAnalytics = prefs.getString('analytics_data');
        if(savedAnalytics == null) {
          yield InitialState();
          return;
        }
        bool isSent =
            await analyticsRepository.sendAnalyticsData(analytics: savedAnalytics);
        
        if (isSent) {
          yield SentAnalyticsData();
          bool removed = await prefs.remove('analytics_data');
          print('analytics => sent and removed $removed');
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
