import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/category.dart';
import '../../../../data/repositories/categories_repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  // List<CategoryChooserCubit> categoriesChooser = [];

  void loadCategories() async {
    List<Category> categories = await CategoriesRepository().getAllCategories();

    // for (final category in categories) {
    //   categoriesChooser.add(CategoryChooserCubit(category.id));
    // }

    try {
      emit(CategoriesLoaded(categories: categories));
    } on Exception catch (ex) {
      emit(CategoriesError(title: ex.toString()));
    }
  }
}
