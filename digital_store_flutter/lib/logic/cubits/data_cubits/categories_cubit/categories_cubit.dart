import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/category.dart';
import '../../../../data/repositories/categories_repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit({required final this.categoriesRepository})
      : super(CategoriesInitial());

  final CategoriesRepository categoriesRepository;

  void loadCategories() async {
    final List<Category> categories =
        await categoriesRepository.getAllCategories();

    try {
      emit(CategoriesLoaded(categories: categories));
    } on Exception catch (ex) {
      emit(CategoriesError(title: ex.toString()));
    }
  }
}
