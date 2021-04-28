import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkCubit extends Cubit<ConnectivityResult> {
  NetworkCubit(): super(ConnectivityResult.none);

  void set(ConnectivityResult state) => emit(state);
}