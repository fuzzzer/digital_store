import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'categories_chooser_state.dart';

class CategoryChooserCubit extends Cubit<CategoryChooserState> {
  CategoryChooserCubit(this.categoryId) : super(CategoryChooserUnSelected());

  String categoryId;

  void selectCategory() {
    emit(CategoryChooserSelected());
  }

  void unSelectCategory() {
    emit(CategoryChooserUnSelected());
  }
}
