import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/user_location/user_location_bloc.dart';

class LocationDisabledPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Location required'),
      content: Text(
          'Please allow location permission from settings, to continue using the app'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              BlocProvider.of<UserLocationBloc>(context)
                  .add(UserLocationEvent.Init);
              Navigator.of(context).pop();
            },
            child: Text('try again'))
      ],
    );
  }
}
