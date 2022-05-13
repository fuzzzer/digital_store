part of 'category_tile_cubit.dart';

abstract class CategoryTileState extends Equatable {
  const CategoryTileState();

  @override
  List<Object> get props => [];
}

class CategoryTileInitial extends CategoryTileState {
  final bool isExtended;
  final bool isSelected;

  const CategoryTileInitial({
    required this.isExtended,
    required this.isSelected,
  });

  @override
  List<Object> get props => [isExtended, isSelected];

  CategoryTileInitial copyWith({
    bool? isExtended,
    bool? isSelected,
  }) {
    return CategoryTileInitial(
      isExtended: isExtended ?? this.isExtended,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
