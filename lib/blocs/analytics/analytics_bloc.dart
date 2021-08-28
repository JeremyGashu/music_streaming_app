import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streaming_mobile/blocs/analytics/analytics_state.dart';
import 'package:streaming_mobile/core/utils/analytics_database.dart';
import 'package:streaming_mobile/core/utils/locator.dart';
import 'package:streaming_mobile/data/models/analytics.dart';
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
        bool isSent =
            await analyticsRepository.sendAnalyticsData(analytics: []);
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
    } else if (event is SaveAnalyticsData) {
      var analyticsBox = await Hive.box<Analytics>('analytics_box');
      // AnalyticsDatabase analyticsDatabase = AnalyticsDatabase(analyticsBox);
      yield SavingAnalyticsData();
      analyticsBox.add(event.analytics);
      yield SavedAnalyticsData();
    }
  }
}
