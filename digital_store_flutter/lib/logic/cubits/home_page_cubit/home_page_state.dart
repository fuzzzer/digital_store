part of 'home_page_cubit.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageInitial extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List<Product> products;
  const HomePageLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class HomePageError extends HomePageState {
  final String title;
  const HomePageError({this.title = ''});

  @override
  List<Object> get props => [title];
}
