import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/data/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({@required this.authRepository})
      : assert(authRepository != null),
        super(InitialState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield SendingAuthData();
      try {
        await Future.delayed(Duration(seconds: 3));
        String otp = await authRepository.sendAuthData(phoneNo: event.phoneNo);
        if (otp != '') {
          yield OTPReceived(otp: otp, phoneNo: event.phoneNo);
          // yield Authenticated(isAuthenticated: true, otp: otp);
        } else {
          yield Unauthenticated();
        }
      } catch (e) {
        print(e.toString());
        yield AuthenticationError();
        throw Exception(e);
      }
    } else if (event is SendOTPVerification) {
      yield VerifyingOTP();
      await Future.delayed(Duration(seconds: 3));
      try {
        String token = await authRepository.verifyOTP(
            phoneNo: event.phoneNo, otp: event.otp);
        if (token != '') {
          print('OTP => ' + event.otp);
          yield OTPVerified(
            token: token,
            otp: event.otp,
            phoneNo: event.phoneNo,
          );
          //TODO save the token here
          yield Authenticated(isAuthenticated: true, otp: event.otp);
          // yield Authenticated(isAuthenticated: true, otp: otp);
        } else {
          yield OTPVerificationFailed(phoneNo: event.phoneNo);
        }
      } catch (e) {
        print(e.toString());
        yield AuthenticationError();
        throw Exception(e);
      }
    }
  }
}
