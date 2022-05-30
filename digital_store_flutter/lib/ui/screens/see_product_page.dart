import 'package:digital_store_flutter/logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import 'package:digital_store_flutter/ui/screens/login_page/login_page.dart';
import 'package:digital_store_flutter/ui/widgets/check_dialog.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:digital_store_flutter/ui/widgets/session_timeout_navigation.dart';
import 'package:digital_store_flutter/ui/widgets/user_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../../logic/cubits/widget_cubits/see_product_page_cubit/see_product_page_cubit.dart';
import '../widgets/payment_dialog.dart';

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
                                    if (userState is UserAuthenticated) {
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
                            if (userCubitState is UserAuthenticated) {
                              return IconButton(
                                onPressed: () async {
                                  final oldContext = context;
                                  if (state.isInTheCard) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => CheckDialog(
                                        onCommandFunction: () async {
                                          await oldContext
                                              .read<SeeProductPageCubit>()
                                              .deleteCartProduct(
                                                  productId: state.product.id);
                                        },
                                        title:
                                            'do you really want to remove product from the cart?',
                                        commandName: 'Remove',
                                      ),
                                    );
                                  } else {
                                    await oldContext
                                        .read<SeeProductPageCubit>()
                                        .addCartProduct(
                                          productId: state.product.id,
                                        );
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
              if ((state as SeeProductPageError).sessionEnded) {
                Future.delayed(
                  Duration.zero,
                  () async {
                    context.read<UserCubit>().logout();

                    sessionTimeoutNavigation(context);
                  },
                );
                return SizedBox.fromSize();
              }
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.title),
                  CommandButton(
                    onPressedFunction: () =>
                        context.read<SeeProductPageCubit>().loadProduct(),
                    commandName: 'reload page',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
