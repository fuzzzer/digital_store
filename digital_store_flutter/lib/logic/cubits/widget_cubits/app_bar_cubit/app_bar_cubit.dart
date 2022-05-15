import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_bar_state.dart';

class AppBarCubit extends Cubit<AppBarState> {
  AppBarCubit() : super(AppBarInitial());

  List<String> savedCategoriesAsSelected =
      []; // just storing data here and managing ui of selecting and unselectig categories by stateful widget

  void isSelectedChanger(final String categoryId) {
    if (savedCategoriesAsSelected.contains(categoryId)) {
      savedCategoriesAsSelected.remove(categoryId);
    } else {
      savedCategoriesAsSelected.add(categoryId);
    }
  }

  changeSearchingState() {
    if (state is! AppBarSearching) {
      emit(AppBarSearching());
    } else {
      emit(AppBarInitial());
    }
  }

  changeSelectingCategoriesState() {
    if (state is! AppBarSelectingCategories) {
      emit(AppBarSelectingCategories());
    } else {
      emit(AppBarInitial());
    }
  }
}
