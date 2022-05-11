import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/cubits/data_cubits/cart_cubit/cart_cubit.dart';
import 'logic/cubits/data_cubits/categories_cubit/categories_cubit.dart';
import 'logic/cubits/data_cubits/products_cubit/products_cubit.dart';
import 'logic/cubits/data_cubits/user_cubit/user_cubit.dart';
import 'logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';
import 'ui/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartCubit(),
        ),
        BlocProvider(
          create: (context) => ProductsCubit(),
        ),
        BlocProvider(
          create: (context) => CategoriesCubit()..loadCategories(),
        ),
        BlocProvider(
          create: (context) => AppBarCubit(),
        ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Digital Strore',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
