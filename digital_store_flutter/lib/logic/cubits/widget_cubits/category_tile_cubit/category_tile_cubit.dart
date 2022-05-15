import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_tile_state.dart';

class CategoryTileCubit extends Cubit<CategoryTileState> {
  CategoryTileCubit(this.categoryId)
      : super(const CategoryTileInitial(isExtended: false, isSelected: false));

  String categoryId;
  bool isExtended = false;

  void isSelectedChanger() {
    if ((state as CategoryTileInitial).isSelected) {
      emit((state as CategoryTileInitial).copyWith(isSelected: false));
    } else {
      emit((state as CategoryTileInitial).copyWith(isSelected: true));
    }
  }

  void isExtendedChanger() {
    if ((state as CategoryTileInitial).isExtended) {
      emit((state as CategoryTileInitial).copyWith(isExtended: false));
    } else {
      emit((state as CategoryTileInitial).copyWith(isExtended: true));
    }
  }

  void setValueOfIsSelected(final bool isSelectedValue) {
    emit((state as CategoryTileInitial).copyWith(isSelected: isSelectedValue));
  }
}
