import 'package:digital_store_flutter/core/constants.dart';
import 'package:digital_store_flutter/ui/widgets/cart_product_tile.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:digital_store_flutter/ui/widgets/check_dialog.dart';
import 'package:digital_store_flutter/ui/widgets/payment_dialog.dart';
import 'package:digital_store_flutter/ui/widgets/user_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/authentication_repository.dart';
import '../../data/repositories/products_repository.dart';
import '../../logic/cubits/data_cubits/cart_cubit/cart_cubit.dart';
import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import '../../logic/cubits/widget_cubits/see_product_page_cubit/see_product_page_cubit.dart';
import 'see_product_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [UserIconButton()],
      ),
      body: Padding(
        padding: defaultPagePadding,
        child: BlocBuilder<CartCubit, CartState>(
          bloc: context.read<CartCubit>()..loadCartItems(),
          builder: (context, state) {
            if (state is CartInitial) {
              return const Center(child: Text('Initial state'));
            } else if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded) {
              return state.productsWithCartQuantity.isEmpty
                  ? const Center(
                      child: Text(
                        'Your Cart is clear',
                        style: TextStyle(fontSize: 30),
                      ),
                    )
                  : Column(
                      children: <Widget>[
                        const SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                'Cart',
                                style: TextStyle(fontSize: 30),
                              ),
                            )),
                        SizedBox(
                          width: double.infinity,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: CommandButton(
                              onPressedFunction: () {
                                final oldContext = context;

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CheckDialog(
                                      onCommandFunction: () => oldContext
                                          .read<CartCubit>()
                                          .clearCart(),
                                      title:
                                          'do you really want to clear the cart?',
                                      commandName: 'Clear',
                                    );
                                  },
                                );
                              },
                              commandName: 'Clear Cart',
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: state.productsWithCartQuantity.length,
                              itemBuilder: (context, index) {
                                return CartProductTile(
                                  onLongPressFunction: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) {
                                            return SeeProductPageCubit(
                                                productsRepository:
                                                    ProductsRepository(),
                                                productId: state
                                                    .productsWithCartQuantity[
                                                        index]
                                                    .id,
                                                authenticationRepository:
                                                    AuthenticationRepository());
                                          },
                                          child: const SeeProductPage(),
                                        ),
                                      ),
                                    );
                                  },
                                  productInfo:
                                      state.productsWithCartQuantity[index],
                                  onPlusTapFunction: () {
                                    context
                                        .read<CartCubit>()
                                        .incrementCartProduct(
                                          state.productsWithCartQuantity[index],
                                        );
                                  },
                                  onMinusTapFunction: () {
                                    context
                                        .read<CartCubit>()
                                        .decrementCartProduct(
                                          state.productsWithCartQuantity[index],
                                        );
                                  },
                                  onRemoveTapFunction: () {
                                    final oldContext =
                                        context; // I wonder how can I pass bloc provider cotext to alert dialog

                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CheckDialog(
                                            onCommandFunction: () => oldContext
                                                .read<CartCubit>()
                                                .deleteCartProduct(
                                                  state.productsWithCartQuantity[
                                                      index],
                                                ),
                                            title:
                                                'do you really want to remove product from the cart?',
                                            commandName: 'Remove',
                                          );
                                        });
                                  },
                                );
                              }),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Total Price: ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Text(
                                '${state.totalCartPrice} \$',
                                style: const TextStyle(
                                    color: Colors.blue, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                        CommandButton(
                            commandName: 'Proceed To Checkout',
                            width: 200,
                            onPressedFunction: () {
                              final oldContext = context;
                              final userState = oldContext
                                  .read<UserCubit>()
                                  .state as UserConsumer;

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return PaymentDialog(
                                        balance: userState.user.balance,
                                        totalPrice: state.totalCartPrice,
                                        commandName: 'Pay',
                                        onCommandFunction: () async {
                                          List paymentInfo = await oldContext
                                              .read<CartCubit>()
                                              .cartCheckout();
                                          // is payment successful? --> List[0] = bool
                                          // whats the reason of unsuccefful payment --> List[1] = String

                                          if (paymentInfo[0] == true) {
                                            context
                                                .read<UserCubit>()
                                                .refreshUserProfile();
                                            Navigator.of(context).pop();
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(paymentInfo[1])));
                                        });
                                  });
                            }),
                      ],
                    );
            } else {
              return Center(
                child: Column(
                  children: [
                    const Text('some error occured'),
                    ElevatedButton(
                        onPressed: () =>
                            context.read<CartCubit>().loadCartItems(),
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
