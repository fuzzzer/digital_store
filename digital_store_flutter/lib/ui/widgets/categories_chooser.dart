import 'package:digital_store_flutter/ui/widgets/category_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/data_cubits/categories_cubit/categories_cubit.dart';
import '../../logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';
import '../../logic/cubits/widget_cubits/category_tile_cubit/category_tile_cubit.dart';

class CategoriesChooser extends StatefulWidget {
  const CategoriesChooser({Key? key}) : super(key: key);

  @override
  State<CategoriesChooser> createState() => _CategoriesChooserState();
}

class _CategoriesChooserState extends State<CategoriesChooser> {
  double initialHeight = 200;
  double height = 200;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 30,
      child: SizedBox(
        height: height,
        child: GestureDetector(
            child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Color.fromARGB(105, 46, 46, 45),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(children: [
            BlocBuilder<CategoriesCubit, CategoriesState>(
              bloc: context.read<CategoriesCubit>()..loadCategories(),
              builder: (context, state) {
                if (state is CategoriesInitial) {
                  return const Center(child: Text('Categories Initial state'));
                } else if (state is CategoriesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoriesLoaded) {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: state.categories.length,
                        itemBuilder: (
                          BuildContext context,
                          int index,
                        ) {
                          return BlocProvider(
                              create: (context) =>
                                  CategoryTileCubit(state.categories[index].id)
                                    ..setValueOfIsSelected(context
                                        .read<AppBarCubit>()
                                        .savedCategoriesAsSelected
                                        .contains(state.categories[index].id)),
                              child: CategoryTile(
                                category: state.categories[index],
                              ));
                        }),
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        const Text('some error occured'),
                        ElevatedButton(
                            onPressed: () => context
                                .read<CategoriesCubit>()
                                .loadCategories(),
                            child: const Text(
                              'refresh',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w800),
                            ))
                      ],
                    ),
                  );
                }
              },
            ),
            GestureDetector(
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  double dy = details.delta.dy;

                  if ((dy < 0 ||
                          height < MediaQuery.of(context).size.height - 120) &&
                      (dy > 0 || height > initialHeight - 100)) {
                    height += dy;
                  }
                });
              },
              child: SizedBox(
                height: 20,
                width: double.infinity,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 79, 79, 79),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
            )
          ]),
        )),
      ),
    );
  }
}
