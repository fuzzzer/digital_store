import 'package:digital_store_flutter/logic/cubits/data_cubits/products_cubit/products_cubit.dart';
import 'package:digital_store_flutter/logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Search extends StatelessWidget {
  const Search({Key? key, required this.inputController}) : super(key: key);

  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        onChanged: (_) {
          context.read<AppBarCubit>().clearSavedCategories();

          if (inputController.text == '') {
            context.read<ProductsCubit>().loadAllProducts();
          } else {
            context
                .read<ProductsCubit>()
                .loadSearchedProducts(inputController.text);
          }
        },
        controller: inputController,
        style: const TextStyle(fontWeight: FontWeight.w400, fontFamily: 'bold'),
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 0, 0, 0), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                    color: Color.fromARGB(255, 3, 132, 132), width: 1.5)),
            suffixIcon: IconButton(
                onPressed: () {
                  if (inputController.text == '') {
                    context.read<ProductsCubit>().loadAllProducts();
                  } else {
                    context
                        .read<ProductsCubit>()
                        .loadSearchedProducts(inputController.text);
                  }
                },
                icon: const Icon(Icons.search))),
      ),
    );
  }
}
