import 'package:digital_store_flutter/data/repositories/authentication_repository.dart';
import 'package:digital_store_flutter/data/repositories/categories_repository.dart';
import 'package:digital_store_flutter/data/repositories/user_repository.dart';
import 'package:digital_store_flutter/ui/core/core_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/global_variables.dart';
import 'data/repositories/cart_repository.dart';
import 'data/repositories/products_repository.dart';
import 'logic/cubits/data_cubits/cart_cubit/cart_cubit.dart';
import 'logic/cubits/data_cubits/categories_cubit/categories_cubit.dart';
import 'logic/cubits/data_cubits/products_cubit/products_cubit.dart';
import 'logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import 'logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';

void main() async {
  setup();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  final data = CoreData();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductsCubit(),
        ),
        BlocProvider(
          create: (context) => CartCubit(
            cartRepository: CartRepository(),
            authenticationRepository: AuthenticationRepository(),
            productsRepository: ProductsRepository(),
          ),
        ),
        BlocProvider(
          create: (context) => CategoriesCubit(
            categoriesRepository: CategoriesRepository(),
          )..loadCategories(),
        ),
        BlocProvider(
          create: (context) => AppBarCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(
            authenticationRepository: AuthenticationRepository(),
            userRepository: UserRepository(),
          )..resumeLoginSeason(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Digital Strore',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: data.router,
      ),
    );
  }
}
