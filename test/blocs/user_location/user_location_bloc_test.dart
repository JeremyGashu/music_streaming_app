
import 'package:flutter_test/flutter_test.dart' as FT;
import 'package:location/location.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_bloc.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_state.dart';
import 'package:streaming_mobile/core/services/location_service.dart';
import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'user_location_bloc_test.mocks.dart';

@GenerateMocks([LocationService])
void main() {
  FT.TestWidgetsFlutterBinding.ensureInitialized();
  UserLocationBloc userLocationBloc;
  MockLocationService locationService;
  group('UserLocationBloc', (){
    Map<String, double> sampleLocation = {"latitude":1.00, "longitude":2.00};
    LocationData locationData = LocationData.fromMap(sampleLocation);
    setUp((){
      locationService = MockLocationService();
      userLocationBloc = UserLocationBloc(locationService: locationService);

      when(locationService.getLocation()).thenAnswer((_) async => locationData);

    });

    test('initial state is [UserLocationLoadBusy] state', (){
      expect(userLocationBloc.state, UserLocationLoadBusy());
    });

    blocTest('upon successfully fetching location state will be [UserLocationLoadSuccess]',
    build: () => userLocationBloc,
      act: (bloc) => bloc.add(UserLocationEvent.Init),
      expect: ()=>[
        UserLocationLoadBusy(),
        UserLocationLoadSuccess(location: locationData)
      ]
    );
  });
}