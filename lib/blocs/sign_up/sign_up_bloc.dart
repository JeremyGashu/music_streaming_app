import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_event.dart';
import 'package:streaming_mobile/blocs/sign_up/sign_up_state.dart';
import 'package:streaming_mobile/data/repository/signup_repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpRepository signUpRepository;
  SignUpBloc({@required this.signUpRepository}) : super(InitialState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SendSignUpData) {
      try {
        yield LoadingState();
        SignupDataResponse signedUp = await signUpRepository.sendSignUpData(
            phone: event.phone, password: event.password);
        if (signedUp.success) {
          yield SignedUpSuccessfully();
        }
        else{
          yield SignUpError(message: signedUp.error);
        }
      } catch (e) {
        yield SignUpError(message: 'Please check your internet connections!');
        print(e);
      }
    } else if (event is VerifyPhoneNumber) {
      yield LoadingState();
      try {
        SignupDataResponse data =
            await signUpRepository.verifyPhoneNumber(phoneNo: event.phone);
        bool success = data.success;
        if (success) {
          yield OTPReceived(phoneNo: event.phone);
        } else {
          yield SignUpError(message: data.error);
        }
      } catch (e) {
        print(e.toString());
        yield SignUpError(message: 'Please check your internet connection!');
      }
    } else if (event is VerifyOTP) {
      yield LoadingState();
      try {
        SignupDataResponse data =
            await signUpRepository.verifyOTP(phoneNo: event.phone, otp: event.otp);
        bool success = data.success;
        if (success) {
          yield OTPVerified(phoneNo: event.phone);
        } else {
          yield SignUpError(message: data.error);
        }
      } catch (e) {
        print(e.toString());
        yield SignUpError(message: 'Please check your internet connection!');
      }
    }
  }
}
