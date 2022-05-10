import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserUnauthenticated());

  void userLogIn(final String username, final String password) async {
    try {
      Map<String, dynamic> tokens = await AuthenticationRepository()
          .postSignIn({'username': username, 'password': password});

      final accessToken = tokens['accessToken'];
      final refreshToken = tokens['refreshToken'];
      final user = await UserRepository().getUserProfile(accessToken);

      emit(UserConsumer(
          user: user, accessToken: accessToken, refreshToken: refreshToken));
    } on Exception catch (ex) {
      print(ex);
    }
  }
}
