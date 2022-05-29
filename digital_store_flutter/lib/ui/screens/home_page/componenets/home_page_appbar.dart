import 'package:digital_store_flutter/ui/widgets/user_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/cubits/widget_cubits/app_bar_cubit/app_bar_cubit.dart';

class HomePageAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomePageAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(Icons.shopify, size: 40)),
      title: const Text('Digital store'),
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
        // Todo add admin options, something like this:
        // if (state.isAdmin)
        //           CommandButton(
        //             width: double.infinity,
        //             backgroundColor: const Color.fromARGB(255, 95, 205, 198),
        //             fontWeight: FontWeight.w600,
        //             commandName: 'Admin Panel',
        //             onPressedFunction: () => Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const AdministratorPage(),
        //               ),
        //             ),
        //           ),
        const UserIconButton()
      ],
    );
  }
}
