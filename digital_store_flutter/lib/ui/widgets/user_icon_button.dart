import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/data/repositories/products_repository.dart';
import 'package:digital_store_flutter/data/repositories/user_repository.dart';
import 'package:digital_store_flutter/logic/cubits/widget_cubits/user_page_cubit/user_page_cubit.dart';
import 'package:digital_store_flutter/ui/screens/login_page/login_page.dart';

import 'package:digital_store_flutter/ui/screens/user_page/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cubits/data_cubits/user_cubit/user_cubit.dart';

class UserIconButton extends StatelessWidget {
  const UserIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
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
      } else if (state is UserAuthenticated) {
        return IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => UserPageCubit(
                      userRepository: UserRepository(),
                      productsRepository: ProductsRepository(),
                      authenticationRepository: AuthenticationRepository()),
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
    });
  }
}
