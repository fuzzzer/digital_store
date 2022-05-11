import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/custom_exceptions.dart';
import '../../../../data/models/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserUnauthenticated());

  bool shouldBeRemembered = false;

  void setRemembered() {
    if (shouldBeRemembered == false) {
      shouldBeRemembered = true;
    } else {
      shouldBeRemembered = false;
    }
  }

  Future<List> userLogIn(final String username, final String password) async {
    try {
      Map<String, dynamic> tokens = await AuthenticationRepository()
          .postSignIn({'username': username, 'password': password});

      final accessToken = tokens['accessToken'];
      final refreshToken = tokens['refreshToken'];
      final user = await UserRepository().getUserProfile(accessToken);

      emit(UserConsumer(
          user: user, accessToken: accessToken, refreshToken: refreshToken));
      return [true, 'signed in'];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }

  Future<List> userSignUp({
    required final String username,
    required final String password,
    required final String firstName,
    required final String lastName,
    required final String email,
    required final String phoneNumber,
    required final String adress,
    required final String birthDate,
    required final String gender,
  }) async {
    try {
      await AuthenticationRepository().postsignUp({
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumner': phoneNumber,
        'adress': adress,
        'birthDate': birthDate,
        'sex': gender
      });

      return [true, 'signed up'];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }
}
