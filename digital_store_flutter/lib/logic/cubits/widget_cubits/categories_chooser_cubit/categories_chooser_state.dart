part of 'categories_chooser_cubit.dart';

abstract class CategoryChooserState extends Equatable {
  const CategoryChooserState();

  @override
  List<Object> get props => [];
}

class CategoryChooserUnSelected extends CategoryChooserState {}

class CategoryChooserSelected extends CategoryChooserState {}
