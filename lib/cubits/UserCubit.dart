import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valex_agro_audit_app/All.dart';

class UserCubit extends Cubit<User?> {
  UserCubit(): super(null);


  void set(User user) => emit(user);

  void update(User user) {
    if(state == null) {
      emit(user);
      return;
    }
    emit(state?.copyWith(name: user.name, company: user.company, rang: user.rang));
  }
}
