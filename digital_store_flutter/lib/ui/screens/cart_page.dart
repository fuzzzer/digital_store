import 'package:digital_store_flutter/core/constants.dart';
import 'package:digital_store_flutter/ui/widgets/cart_product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/data_cubits/cart_cubit/cart_cubit.dart';
import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userCubitState = context.read<UserCubit>().state;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: defaultPagePadding,
        child: BlocBuilder<CartCubit, CartState>(
          bloc: context.read<CartCubit>()
            ..loadCartItems((userCubitState as UserConsumer).accessToken),
          builder: (context, state) {
            if (state is CartInitial) {
              return const Center(child: Text('Initial state'));
            } else if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded) {
              return Column(
                children: <Widget>[
                  const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          'Cart',
                          style: TextStyle(fontSize: 30),
                        ),
                      )),
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.productsWithCartQuantity.length,
                        itemBuilder: (context, index) {
                          return CartProductTile(
                            productInfo: state.productsWithCartQuantity[index],
                            onPlusTapFunction: () {
                              context.read<CartCubit>().incrementCartProduct(
                                  state.productsWithCartQuantity[index],
                                  (userCubitState as UserConsumer).accessToken);
                            },
                            onMinusTapFunction: () {
                              context.read<CartCubit>().decrementCartProduct(
                                  state.productsWithCartQuantity[index],
                                  (userCubitState as UserConsumer).accessToken);
                            },
                            onRemoveTapFunction: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              context
                                                  .read<CartCubit>()
                                                  .deleteCartProduct(
                                                      state.productsWithCartQuantity[
                                                          index],
                                                      (userCubitState
                                                              as UserConsumer)
                                                          .accessToken);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                          );
                        }),
                  )
                ],
              );
            } else {
              return Center(
                child: Column(
                  children: [
                    const Text('some error occured'),
                    ElevatedButton(
                        onPressed: () => context
                            .read<CartCubit>()
                            .loadCartItems(userCubitState.accessToken),
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
