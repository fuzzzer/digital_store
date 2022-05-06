import 'package:digital_store_flutter/logic/cubits/user_cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'logic/cubits/app_bar_cubit/app_bar_cubit.dart';
import 'logic/cubits/home_page_cubit/home_page_cubit.dart';
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
          create: (context) => AppBarCubit(),
        ),
        BlocProvider(
          create: (context) => HomePageCubit(),
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
