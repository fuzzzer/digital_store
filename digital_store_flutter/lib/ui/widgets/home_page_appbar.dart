import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:digital_store_flutter/data/repositories/user_repository.dart';
import 'package:digital_store_flutter/logic/cubits/widget_cubits/user_page_cubit/user_page_cubit.dart';
import 'package:digital_store_flutter/ui/screens/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import '../../logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';
import '../screens/login_page.dart';

class HomePageAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: const Text('digital store'),
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
        BlocBuilder<AppBarCubit, AppBarState>(
          builder: (context, state) {
            return IconButton(
                onPressed: () => context
                    .read<AppBarCubit>()
                    .changeSelectingCategoriesState(),
                icon: state is AppBarSelectingCategories
                    ? const Icon(Icons.close,
                        color: Color.fromARGB(255, 232, 52, 16))
                    : const Icon(
                        Icons.apps,
                      ));
          },
        ),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserUnauthenticated) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
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
            } else if (state is UserConsumer) {
              return IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => UserPageCubit(
                            userRepository: UserRepository(),
                            productsRepository: ProductsRepository(),
                            authenticationRepository:
                                AuthenticationRepository()),
                        child: const UserPage(),
                      ),
                    ),
                  );
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
            } else {
              return const SizedBox.shrink();
            }
          },
        )
      ],
    );
  }
}
