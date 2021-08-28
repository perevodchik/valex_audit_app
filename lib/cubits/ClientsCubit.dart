import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valex_agro_audit_app/All.dart';

class ClientsCubit extends Cubit<List<ClientPreview>> {
  ClientsCubit(): super(<ClientPreview> []);

  void set(List<ClientPreview> newState) => emit(newState.reversed.toList());

  void updateClientLastAudit(String clientId, String user, DateTime date) {
    List<ClientPreview> newState = List.of(state);
    for(var client in newState) {
      if(client.id == clientId) {
        client.userLastAudit = user;
        client.lastAudit = date;
      }
    }
    emit(newState);
  }

  void remove(ClientPreview client) {
    List<ClientPreview> newState = List.of(state);
    newState.removeWhere((c) => c.id == client.id);
    emit(newState);
  }

  void add(List<ClientPreview> newClients) {
    List<ClientPreview> newState = List.of(state);
    newState.addAll(newClients.reversed.toList());
    emit(newState);
  }

  void update(ClientPreview clientToUpdate) {
    List<ClientPreview> newState = List.of(state);
    for(var client in newState) {
      if(client.id == clientToUpdate.id) {
        client.update(clientToUpdate);
      }
    }
    emit(newState);
  }

}