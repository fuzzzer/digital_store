import 'package:bloc/bloc.dart';
import 'package:digital_store_flutter/core/services/update_singletons.dart';
import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/global_variables.dart';
import '../../../../data/models/custom_exceptions.dart';
import '../../../../data/models/tokens.dart';
import '../../../../data/models/user.dart';
import '../../../global_logics/local_storing_logic.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(
      {required this.authenticationRepository, required this.userRepository})
      : super(const UserUnauthenticated());

  AuthenticationRepository authenticationRepository;
  UserRepository userRepository;

  void setRememberMeValue() {
    if (getIt.get<Map>()['userShouldBeRemembered'] == false) {
      getIt.get<Map>()['userShouldBeRemembered'] = true;
    } else {
      getIt.get<Map>()['userShouldBeRemembered'] = false;
    }
  }

  Future<List> userLogin(final String username, final String password) async {
    try {
      Map<String, dynamic> tokens = await authenticationRepository
          .postSignIn({'username': username, 'password': password});

      updateTokens(tokens);

      final user = await userRepository.getUserProfile();

      if (getIt.get<Map>()['userShouldBeRemembered']) {
        storeCredentials(getIt.get<Tokens>().refreshToken);
      }

      final bool isAdmin;

      if (username == 'me1') {
        isAdmin = true;
      } else {
        isAdmin = true;
      }

      emit(UserAuthenticated(user: user, isAdmin: isAdmin));

      return [true, 'signed in'];
    } on InvalidTokenRecievedException catch (ex) {
      return [false, ex.reason];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }

  Future<void> resumeLoginSeason() async {
    String? refreshToken = await readSavedRefreshTokenFromHive();

    if (refreshToken != null && refreshToken != '') {
      try {
        Map<String, dynamic> tokens =
            await authenticationRepository.postRefresh(refreshToken);

        updateTokens(tokens);

        final user = await userRepository.getUserProfile();

        getIt.get<Map>()['userShouldBeRemembered'] = true;
        storeCredentials(getIt.get<Tokens>().refreshToken);

        final bool isAdmin;

        if (user.username == 'me1') {
          isAdmin = true;
        } else {
          isAdmin = true;
        }

        emit(UserAuthenticated(user: user, isAdmin: isAdmin));
      } on Exception {
        removeOldRefreshTokenFromHive();
        emit(const UserUnauthenticated());
      }
    } else {
      emit(const UserUnauthenticated());
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
    required final String sex,
  }) async {
    try {
      await authenticationRepository.postsignUp({
        'username': username,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'adress': adress,
        'birthDate': birthDate,
        'sex': sex
      });

      return [true, 'signed up'];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }

  void updateBalance(final double deposit) async {
    double newBalance = deposit + (state as UserAuthenticated).user.balance;

    try {
      await userRepository.patchUserBalance({'amount': newBalance});
      final user = await userRepository.getUserProfile();
      emit((state as UserAuthenticated).copyWith(user: user));
    } on InvalidTokenException {
      emit(const UserUnauthenticated(
          unAuthenticationReason: 'session expired', sessionEnded: true));
    }
  }

  void refreshUserProfile() async {
    try {
      final user = await userRepository.getUserProfile();
      emit((state as UserAuthenticated).copyWith(user: user));
    } on InvalidTokenException {
      emit(const UserUnauthenticated(
          unAuthenticationReason: 'session expired', sessionEnded: true));
    } on MessageException catch (ex) {
      emit(UserUnauthenticated(unAuthenticationReason: ex.reason));
    }
  }

  Future<List> updateProfile({
    required final String firstName,
    required final String lastName,
    required final String email,
    required final String phoneNumber,
    required final String adress,
    required final String sex,
  }) async {
    try {
      await userRepository.patchUserProfile({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'adress': adress,
        'sex': sex
      });

      final user = await userRepository.getUserProfile();

      emit((state as UserAuthenticated).copyWith(user: user));

      return [true, 'profile updated'];
    } on InvalidTokenException {
      emit(const UserUnauthenticated(
          unAuthenticationReason: 'session expired', sessionEnded: true));
      return [false, 'session expired'];
    } on MessageException catch (ex) {
      return [false, ex.reason];
    }
  }

  void logout() {
    Map<String, dynamic> tokens = {'accessToken': '', 'refreshToken': ''};
    updateTokens(tokens);
    removeOldRefreshTokenFromHive();
    emit(const UserUnauthenticated());
  }
}
