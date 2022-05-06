part of 'app_bar_cubit.dart';

abstract class AppBarState extends Equatable {
  const AppBarState();

  @override
  List<Object> get props => [];
}

class AppBarInitial extends AppBarState {}

class AppBarSearching extends AppBarState {}

class AppBarSelectingCategory extends AppBarState {}
