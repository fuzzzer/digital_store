import 'package:digital_store_flutter/logic/cubits/data_cubits/products_cubit/products_cubit.dart';
import 'package:digital_store_flutter/logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/category.dart';

class CategoryTile extends StatefulWidget {
  final Category category;
  bool isSelected;

  CategoryTile({Key? key, required this.category, required this.isSelected})
      : super(key: key);

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SizedBox(
        height: 45,
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(206, 53, 126, 150),
              border: Border.all(),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Row(
            children: [
              IconButton(
                  onPressed: () => null,
                  icon: const Icon(Icons.arrow_drop_down)),
              Expanded(
                child: Text(
                  widget.category.title,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Checkbox(
                      value: widget.isSelected,
                      onChanged: (_) {
                        context
                            .read<AppBarCubit>()
                            .isSelectedChanger(widget.category.id);
                        if (widget.isSelected == false) {
                          context.read<ProductsCubit>().loadCategorizedProducts(
                              categoryId: widget.category.id);
                        } else {
                          if (context
                              .read<AppBarCubit>()
                              .savedCategoriesAsSelected
                              .isEmpty) {
                            context.read<ProductsCubit>().loadAllProducts();
                          } else {
                            context
                                .read<ProductsCubit>()
                                .removeProducts(categoryId: widget.category.id);
                          }
                        }

                        setState(() {
                          widget.isSelected =
                              widget.isSelected == false ? true : false;
                        });
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
