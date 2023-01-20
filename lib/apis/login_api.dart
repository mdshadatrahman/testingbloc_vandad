import 'package:flutter/foundation.dart' show immutable;
import 'package:testing_bloc_vandad/models.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  //Singletone pattern
  const LoginApi._sharedInstence();
  static const LoginApi _shared = LoginApi._sharedInstence();
  factory LoginApi.instance() => _shared;

  @override
  Future<LoginHandle?> login({required String email, required String password}) =>
      Future.delayed(const Duration(seconds: 2), () => email == 'shadat@gmail.com' && password == '123123')
          .then((isLoggedIn) => isLoggedIn ? const LoginHandle.fooBar() : null);
}
