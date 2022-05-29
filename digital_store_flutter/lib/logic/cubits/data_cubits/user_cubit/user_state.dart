part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserUnauthenticated extends UserState {
  final String unAuthenticationReason;
  final bool sessionEnded;

  const UserUnauthenticated(
      {this.unAuthenticationReason = '', final this.sessionEnded = false});

  @override
  List<Object> get props => [sessionEnded];
}

class UserAuthenticated extends UserState {
  final User user;
  final bool isAdmin;

  const UserAuthenticated({
    required final this.user,
    required final this.isAdmin,
  });

  @override
  List<Object> get props => [user, isAdmin];

  UserAuthenticated copyWith({
    User? user,
    bool? isAdmin,
  }) {
    return UserAuthenticated(
      user: user ?? this.user,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

class UserAdministrator extends UserState {
  final User user;

  const UserAdministrator({
    required final this.user,
  });

  @override
  List<Object> get props => [user];
}
