import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_bar_state.dart';

class AppBarCubit extends Cubit<AppBarState> {
  AppBarCubit() : super(AppBarInitial());

  changeSearchingState() {
    if (state is! AppBarSearching) {
      emit(AppBarSearching());
    } else {
      emit(AppBarInitial());
    }
  }
}
