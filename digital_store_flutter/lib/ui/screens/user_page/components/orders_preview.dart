import 'package:digital_store_flutter/logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import 'package:digital_store_flutter/logic/cubits/widget_cubits/user_page_cubit/user_page_cubit.dart';
import 'package:digital_store_flutter/ui/widgets/command_button.dart';
import 'package:digital_store_flutter/ui/widgets/orders_tile.dart';
import 'package:digital_store_flutter/ui/widgets/session_timeout_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersPreview extends StatelessWidget {
  const OrdersPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  primary: const Color.fromARGB(232, 57, 56, 56)),
              onPressed: () {
                if (context.read<UserCubit>().state is UserUnauthenticated) {
                  sessionTimeoutNavigation(context);
                } else {
                  context.read<UserPageCubit>().changeWatchingOrdersState();
                }
              },
              child: Row(
                children: [
                  const Expanded(
                      child: Text(
                    'order history',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  )),
                  BlocBuilder<UserPageCubit, UserPageState>(
                    builder: (context, state) {
                      if (state is UserPageWatchingOrders) {
                        return const Icon(Icons.arrow_drop_down_sharp);
                      } else {
                        return const Icon(Icons.arrow_right_outlined);
                      }
                    },
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(151, 158, 158, 158)),
              child: BlocBuilder<UserPageCubit, UserPageState>(
                builder: (context, state) {
                  if (state is UserPageInitial) {
                    return const SizedBox.shrink();
                  } else if (state is UserPageLoading) {
                    return const SizedBox(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is UserPageWatchingOrders) {
                    return SizedBox(
                      height: 300,
                      child: ListView.builder(
                          itemCount: state.orderedProducts.length,
                          itemBuilder: (context, index) => OrdersTile(
                                productInfo: state.orderedProducts[index],
                              )),
                    );
                  } else {
                    if ((state as UserPageError).sessionEnded) {
                      Future.delayed(
                        Duration.zero,
                        () async {
                          context.read<UserCubit>().logout();

                          sessionTimeoutNavigation(context);
                        },
                      );
                      return const SizedBox.shrink();
                    }
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.title),
                        CommandButton(
                          onPressedFunction: () =>
                              context.read<UserPageCubit>().loadOrders(),
                          commandName: 'reload page',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
