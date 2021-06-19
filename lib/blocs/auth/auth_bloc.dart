import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:streaming_mobile/blocs/auth/auth_event.dart';
import 'package:streaming_mobile/blocs/auth/auth_state.dart';
import 'package:streaming_mobile/data/models/auth_data.dart';
import 'package:streaming_mobile/data/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({@required this.authRepository})
      : assert(authRepository != null),
        super(InitialState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is VerifyPhoneNumberEvent) {
      yield SendingPhoneVerification();
      try {
        await Future.delayed(Duration(seconds: 3));
        String otp =
            await authRepository.verifyPhoneNumber(phoneNo: event.phoneNo);
        if (otp != '') {
          yield OTPReceived(otp: otp, phoneNo: event.phoneNo);
        } else {
          yield Unauthenticated(authData: AuthData(isAuthenticated: false));
        }
      } catch (e) {
        print(e.toString());
        yield AuthenticationError();
        throw Exception(e);
      }
    } else if (event is CheckAuthOnStartUp) {
      yield CheckingAuthOnStartup();
      var authBox = await Hive.openBox<AuthData>('auth_box');
      AuthData authData = authBox.get('auth_data',
          defaultValue: AuthData(isAuthenticated: false));
      if (authData.isAuthenticated) {
        yield Authenticated(authData: authData);
      } else {
        yield InitialState();
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
            otp: event.otp,
            phoneNo: event.phoneNo,
          );
          // yield Authenticated(isAuthenticated: true, otp: event.otp);
        } else {
          yield OTPVerificationFailed(phoneNo: event.phoneNo);
        }
      } catch (e) {
        print(e.toString());
        yield AuthenticationError();
        throw Exception(e);
      }
    } else if (event is LoginEvent) {
      yield SendingLoginData();
      try {
        AuthData authData = await authRepository.loginUser(
            phone: event.phone, password: event.password);
        print('current auth data: ${authData.isAuthenticated}');
        if (authData.isAuthenticated) {
          yield Authenticated(authData: authData);

          var authBox = await Hive.openBox<AuthData>('auth_box');
          print('saving auth data into  hive');
          await authBox.put('auth_data', authData);

          print(
              'saved auth data ${authBox.get('auth_data', defaultValue: AuthData(isAuthenticated: false))}');
        } else {
          yield InitialState();
        }
      } catch (e) {
        print(e.toString());
        yield AuthenticationError(
            message: 'Please check your internet connection!');
        throw Exception(e);
      }
    } else if (event is LogOutEvent) {
      var authBox = await Hive.openBox<AuthData>('auth_box');
      print('clearing auth data on log out');
      await authBox.clear();

      print(
          'auth data after log out${authBox.get('auth_data', defaultValue: AuthData(isAuthenticated: false))}');
      yield InitialState();
    }
  }
}
