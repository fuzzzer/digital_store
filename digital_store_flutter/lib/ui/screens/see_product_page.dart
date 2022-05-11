import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../../logic/cubits/widget_cubits/see_product_page_cubit/see_product_page_cubit.dart';

class SeeProductPage extends StatelessWidget {
  const SeeProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                    Image.file(
                      File(state.product.imageLocation),
                      errorBuilder: (context, error, stackTrace) =>
                          const Placeholder(),
                    ),
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
                          child: ElevatedButton(
                              onPressed: () => null, child: const Text('BUY')),
                        ),
                        IconButton(
                          onPressed: () {

                            // context.read<CartCubit>().loadCartItems(accessToken)
                          },
                          icon: const Icon(
                            Icons.shopping_cart,
                            size: 50,
                          ),
                          iconSize: 50,
                        ),
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
