import 'package:digital_store_flutter/logic/cubits/app_bar_cubit/app_bar_cubit.dart';
import 'package:digital_store_flutter/logic/cubits/see_product_page_cubit/see_product_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/home_page_cubit/home_page_cubit.dart';
import '../../logic/cubits/user_cubit/user_cubit.dart';
import '../widgets/actions_drawer.dart';
import '../widgets/product_tile.dart';
import 'login_page.dart';
import 'see_product_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ActionsDrawer(),
      floatingActionButton: Builder(builder: (context) {
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserConsumer) {
              return FloatingActionButton(
                onPressed: () => null,
                child: const Icon(Icons.shopping_cart),
              );
            } else {
              return const SizedBox
                  .shrink(); // it will be good to implemet functionality where not authorized user can add items in cart in advance
            }
          },
        );
      }),
      appBar: AppBar(
        title: BlocBuilder<AppBarCubit, AppBarState>(
          builder: (context, state) {
            if (state is AppBarSearching) {
              return const TextField();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        actions: <Widget>[
          BlocBuilder<AppBarCubit, AppBarState>(
            builder: (context, state) {
              return IconButton(
                  onPressed: () =>
                      context.read<AppBarCubit>().changeSearchingState(),
                  icon: state is AppBarSearching
                      ? const Icon(Icons.close,
                          color: Color.fromARGB(255, 232, 52, 16))
                      : const Icon(
                          Icons.search,
                          color: Color.fromARGB(252, 227, 181, 43),
                        ));
            },
          ),
          IconButton(onPressed: () => null, icon: const Icon(Icons.apps)),
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserUnauthenticated) {
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(
                                  loginTitle:
                                      'Log in or register to buy products',
                                )));
                  },
                  icon: const SizedBox(
                    width: 40,
                    height: 40,
                    child: ImageIcon(
                      AssetImage(
                        'assets/images/user_unauthenticated.png',
                      ),
                      size: 40,
                    ),
                  ),
                  iconSize: 40,
                );
              } else {
                return IconButton(
                  onPressed: () {
                    //see user profile
                  },
                  icon: const SizedBox(
                    width: 40,
                    height: 40,
                    child: ImageIcon(
                      AssetImage(
                        'assets/images/user_authenticated.png',
                      ),
                      size: 40,
                    ),
                  ),
                  iconSize: 40,
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: BlocBuilder<HomePageCubit, HomePageState>(
          bloc: context.read<HomePageCubit>()..loadProducts(),
          builder: (context, state) {
            if (state is HomePageInitial) {
              return const Center(child: Text('Initial state'));
            } else if (state is HomePageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomePageLoaded) {
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
                                    create: (context) => SeeProductPageCubit(
                                        productId: state.products[index].id),
                                    child: const SeeProductPage(),
                                  )));
                    },
                    onLongPressFunction: () {
                      //show product preview
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
                        onPressed: () =>
                            context.read<HomePageCubit>()..loadProducts(),
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
      ),
    );
  }
}
