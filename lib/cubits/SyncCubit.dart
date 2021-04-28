import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valex_agro_audit_app/All.dart';

class SyncCubit extends Cubit<Sync> {
  SyncCubit(): super(Sync.AWAIT);

  void set(Sync newState) => emit(newState);
}