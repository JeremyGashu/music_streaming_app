import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_event.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_state.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';
import 'package:streaming_mobile/data/repository/signup_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRepository signUpRepository;
  SignUpBloc({@required this.signUpRepository}) : super(InitialState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SendSignUpData) {
      try {
        yield SendingSignUpData();
        AuthData authData = await signUpRepository.sendSignUpData(
            phone: event.phone, password: event.password);
        if (authData.isAuthenticated) {
          yield SignedUpSuccessfully(authData: authData);
        }
        yield SignUpError(message: 'Failed To Sign up!');
      } catch (e) {
        yield SignUpError(message: 'Failed To Sign up!');
        print(e);
      }
    }
  }
}
