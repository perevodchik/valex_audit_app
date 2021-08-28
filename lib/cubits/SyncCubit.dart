import 'package:flutter_bloc/flutter_bloc.dart';

class SyncCubit extends Cubit<String> {
  SyncCubit(): super("");

  void set(String newState) => emit(newState);
}