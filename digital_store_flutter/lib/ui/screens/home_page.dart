import 'package:digital_store_flutter/core/constants.dart';
import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/ui/screens/cart_page.dart';
import 'package:digital_store_flutter/ui/widgets/categories_chooser.dart';

import 'package:digital_store_flutter/ui/widgets/home_page_appbar.dart';
import 'package:digital_store_flutter/ui/widgets/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/products_repository.dart';
import '../../logic/cubits/data_cubits/products_cubit/products_cubit.dart';
import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import '../../logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';
import '../../logic/cubits/widget_cubits/see_product_page_cubit/see_product_page_cubit.dart';
import '../widgets/product_tile.dart';
import 'see_product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Builder(builder: (context) {
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserConsumer) {
              return FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                ),
                child: const Icon(Icons.shopping_cart),
              );
            } else {
              return const SizedBox
                  .shrink(); // it will be good to implemet functionality where not authorized user can add items in cart in advance
            }
          },
        );
      }),
      appBar: const HomePageAppBar(),
      body: Padding(
        padding: defaultPagePadding,
        child: Column(
          children: [
            BlocBuilder<AppBarCubit, AppBarState>(
              builder: (context, state) {
                if (state is AppBarInitial) {
                  return Container();
                } else if (state is AppBarSearching) {
                  return Search(
                      inputController:
                          context.read<AppBarCubit>().searchController);
                } else {
                  return const CategoriesChooser();
                }
              },
            ),
            Expanded(
              child: BlocBuilder<ProductsCubit, ProductsState>(
                bloc: context.read<ProductsCubit>()..loadAllProducts(),
                builder: (context, state) {
                  if (state is ProductsInitial) {
                    return const Center(child: Text('Initial state'));
                  } else if (state is ProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductsLoaded) {
                    return ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        return ProductTile(
                          productInfo: state.products[index],
                          onTapFunction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) {
                                    return SeeProductPageCubit(
                                      productsRepository: ProductsRepository(),
                                      productId: state.products[index].id,
                                      authenticationRepository:
                                          AuthenticationRepository(),
                                    );
                                  },
                                  child: const SeeProductPage(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Column(
                        children: [
                          const Text('some error occured'),
                          ElevatedButton(
                            onPressed: () => context.read<ProductsCubit>()
                              ..loadAllProducts(),
                            child: const Text(
                              'refresh',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w800),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
