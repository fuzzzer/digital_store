import 'package:digital_store_flutter/logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import 'package:digital_store_flutter/ui/widgets/check_dialog.dart';
import 'package:digital_store_flutter/ui/widgets/user_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../../logic/cubits/data_cubits/cart_cubit/cart_cubit.dart';
import '../../logic/cubits/widget_cubits/see_product_page_cubit/see_product_page_cubit.dart';
import '../widgets/payment_dialog.dart';
import 'login_page.dart';

class SeeProductPage extends StatelessWidget {
  const SeeProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [UserIconButton()],
      ),
      body: Padding(
        padding: defaultPagePadding,
        child: BlocBuilder<SeeProductPageCubit, SeeProductPageState>(
          bloc: context.read<SeeProductPageCubit>()..loadProduct(),
          builder: (context, state) {
            if (state is SeeProductPageInitial) {
              return const Center(child: Text('Initial state'));
            } else if (state is SeeProductPageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SeeProductPageLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    state.product.image ?? const Placeholder(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(state.product.title,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 10, 5),
                              child: Text(
                                '\$ ${state.product.price}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 25,
                                    color: Color.fromARGB(223, 18, 74, 164)),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: BlocBuilder<UserCubit, UserState>(
                            builder: (context, userState) {
                              return ElevatedButton(
                                  onPressed: () {
                                    if (userState is UserConsumer) {
                                      final oldContext = context;

                                      showDialog(
                                        context: context,
                                        builder: (context) => PaymentDialog(
                                          balance: userState.user.balance,
                                          totalPrice: state.product.price,
                                          commandName: 'Pay',
                                          onCommandFunction: () async {
                                            List paymentInfo = await oldContext
                                                .read<SeeProductPageCubit>()
                                                .buyProduct();
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
                                          },
                                        ),
                                      );
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) => CheckDialog(
                                                onCommandFunction: () =>
                                                    Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage()),
                                                ),
                                                title: 'sign in to buy product',
                                                commandName: 'sign in',
                                                commandButtonColor:
                                                    Colors.green,
                                              ));
                                    }
                                  },
                                  child: const Text('BUY'));
                            },
                          ),
                        ),
                        BlocBuilder<UserCubit, UserState>(
                          builder: (context, userCubitState) {
                            if (userCubitState is UserConsumer) {
                              return IconButton(
                                onPressed: () {
                                  final oldContext = context;
                                  if (state.isInTheCard) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CheckDialog(
                                        onCommandFunction: () {
                                          oldContext
                                              .read<CartCubit>()
                                              .deleteCartProduct(
                                                  state.product.id);
                                          oldContext
                                              .read<SeeProductPageCubit>()
                                              .loadProduct();
                                        },
                                        title:
                                            'do you really want to remove product from the cart?',
                                        commandName: 'Remove',
                                      ),
                                    );
                                  } else {
                                    oldContext.read<CartCubit>().addCartProduct(
                                        productId: state.product.id,
                                        quantity: 1);

                                    oldContext
                                        .read<SeeProductPageCubit>()
                                        .loadProduct();
                                  }
                                },
                                icon: Icon(Icons.shopping_cart,
                                    size: 50,
                                    color: state.isInTheCard
                                        ? Colors.green
                                        : Colors.black),
                                iconSize: 50,
                              );
                            } else {
                              return IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => CheckDialog(
                                            onCommandFunction: () =>
                                                Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()),
                                            ),
                                            title:
                                                'sign in to add product to the cart',
                                            commandName: 'sign in',
                                            commandButtonColor: Colors.green,
                                          ));
                                },
                                icon: const Icon(Icons.shopping_cart,
                                    size: 50, color: Colors.black),
                                iconSize: 50,
                              );
                            }
                          },
                        )
                      ],
                    ),
                    const Divider(
                      thickness: 3,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(children: [
                            const Text('size',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400)),
                            Text(state.product.size)
                          ]),
                          const VerticalDivider(
                              width: 1,
                              thickness: 1,
                              color: Color.fromARGB(111, 120, 120, 120)),
                          Column(children: [
                            const Text('color',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400)),
                            Text(state.product.color)
                          ]),
                          const VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: Color.fromARGB(111, 120, 120, 120),
                          ),
                          Column(
                            children: [
                              const Text('available quantity',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400)),
                              Text(state.product.quantity.toString())
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Description:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 6, 0, 6),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(state.product.description)),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text((state as SeeProductPageError).title));
            }
          },
        ),
      ),
    );
  }
}
