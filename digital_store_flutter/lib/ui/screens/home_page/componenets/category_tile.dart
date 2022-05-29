import 'package:digital_store_flutter/logic/cubits/data_cubits/products_cubit/products_cubit.dart';
import 'package:digital_store_flutter/logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/category.dart';
import '../../../../logic/cubits/widget_cubits/category_tile_cubit/category_tile_cubit.dart';

class CategoryTile extends StatelessWidget {
  final Category category;

  const CategoryTile({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(206, 7, 101, 132),
            border: Border.all(),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () =>
                          context.read<CategoryTileCubit>().isExtendedChanger(),
                      icon: BlocBuilder<CategoryTileCubit, CategoryTileState>(
                        builder: (context, state) {
                          if ((state as CategoryTileInitial).isExtended) {
                            return const Icon(Icons.arrow_drop_down_sharp);
                          } else {
                            return const Icon(Icons.arrow_right_outlined);
                          }
                        },
                      )),
                  Expanded(
                    child: Text(
                      category.title,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: BlocBuilder<CategoryTileCubit, CategoryTileState>(
                      builder: (context, state) {
                        if ((state as CategoryTileInitial).isSelected) {
                          return Checkbox(
                              value: true,
                              onChanged: (_) {
                                if (context
                                        .read<AppBarCubit>()
                                        .searchController
                                        .text !=
                                    '') {
                                  context
                                      .read<AppBarCubit>()
                                      .searchController
                                      .text = '';
                                }

                                // I think its possible to think of better way of managing checkbox state and function
                                context.read<AppBarCubit>().isSelectedChanger(
                                    category
                                        .id); // AppBarCubit saves categories which were selected last time, so this function removes category from saved ones

                                if (context
                                    .read<AppBarCubit>()
                                    .savedCategoriesAsSelected
                                    .isEmpty) {
                                  // this check is true when user unselects all categories filters
                                  context
                                      .read<ProductsCubit>()
                                      .loadAllProducts();
                                } else {
                                  context
                                      .read<ProductsCubit>()
                                      .removeFromFilteredProducts(
                                          categoryId: category.id);
                                }

                                context
                                    .read<CategoryTileCubit>()
                                    .isSelectedChanger();
                              });
                        } else {
                          return Checkbox(
                              value: false,
                              onChanged: (_) {
                                if (context
                                        .read<AppBarCubit>()
                                        .searchController
                                        .text !=
                                    '') {
                                  context
                                      .read<AppBarCubit>()
                                      .searchController
                                      .text = '';
                                }

                                context
                                    .read<AppBarCubit>()
                                    .isSelectedChanger(category.id);

                                context
                                    .read<ProductsCubit>()
                                    .loadCategorizedProducts(
                                        categoryId: category.id);

                                context
                                    .read<CategoryTileCubit>()
                                    .isSelectedChanger();
                              });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<CategoryTileCubit, CategoryTileState>(
              builder: (context, state) {
                if ((state as CategoryTileInitial).isExtended) {
                  return SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: SizedBox(
                      height: 100,
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            color: const Color.fromARGB(165, 138, 138, 138),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  category.description,
                                  style: const TextStyle(color: Colors.white),
                                )),
                          )),
                    ),
                  ));
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
