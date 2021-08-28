import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valex_agro_audit_app/All.dart';

class NetworkRepository {
  static StreamSubscription<ConnectivityResult>? subscription;

  static void subscribeToChanges() {
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      print("${DateTime.now()}: current network state: $result");
      BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!).set(result);
      if(result == ConnectivityResult.none)
        await FirebaseFirestore.instance.disableNetwork();
      else {
        await FirebaseFirestore.instance.enableNetwork();
        sync();
      }
    });
  }

  static void unsubscribeFromChanges() async {
    await subscription?.cancel();
    subscription = null;
  }

  static Future<void> refreshNetworkStatus() async {
    var _hasNetwork = await hasNetwork();
    if(!_hasNetwork) {
      BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!).set(ConnectivityResult.none);
    } else {
      var state = await Connectivity().checkConnectivity();
      BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!).set(state);
    }
  }

  static Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      print(result);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("have network");
        return true;
      }
    } on SocketException catch (_) {
      print("no network");
      return false;
    }
    print("no network");
    return false;
  }

  static Future<void> sync() async {
    print("sync begin");
    var network = BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!);
    if(network.state != ConnectivityResult.wifi) return;
    BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("start_sync");
    await syncClients(network);
    await syncReviews(network);
    await syncAudits(network);

    BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Sync.DONE");
    print("sync finish");
  }

  static Future<void> syncAudits(NetworkCubit network) async {
    var audits = await LocalStorage().getAuditsAll();
    for(var audit in audits) {
      var network = BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!);
      if(network.state != ConnectivityResult.wifi) return;

      var clientId = audit.clientId;
      if(isCacheId(clientId))
        clientId = toFirebaseId(clientId);
      audit.clientId = clientId;
      BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Синхронізація аудиту ${audit.id}");

      audit.data = await LocalStorage().getAuditData(audit.id);
      audit.auditQuestions = await LocalStorage().getAuditQuestions(audit.id);
      for(var q1 in audit.auditQuestions.entries) {
        for(var q0 in q1.value.entries) {
          for(var q in q0.value) {
            var c = 0;
            for(var p = 0; p < (q.photosSrc ?? []).length; p++) {
              var srcTmp = q.photosSrc![p];
              var file = File(srcTmp);
              // TODO compress
              // var result = await FlutterImageCompress.compressWithFile(
              //     file.absolute.path,
              //     quality: 70
              // );
              // await file.writeAsBytes(result!.toList());

              var path = "${audit.firebaseId}/${q.question}_${c++}.jpg";
              var storageRef = FirebaseStorage
                  .instance
                  .ref()
                  .child("$path");
              try {
                BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Завантаження фотографії аудиту $path");
                var uploadTask = await storageRef.putFile(file);
                var url = await uploadTask.ref.getDownloadURL();
                q.photosSrc![p] = path;
                BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Видалення локальної фотографії аудиту $path");
                await file.delete();
              } catch(e) {
                BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("$e");
              }
            }
          }
        }
      }
      await AuditRepository.addAudit(audit);
      BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Видалення локальних даних аудиту ${audit.id}");
      await LocalStorage().removeAudit(audit);
      await LocalStorage().deleteAuditData(audit.id);
      await LocalStorage().deleteAuditQuestion(audit.id);

      try {
        var client = await ClientsShortRepository.getClient(audit.clientId);
        if(client?.lastAudit == null || client!.lastAudit!.millisecondsSinceEpoch < audit.date.millisecondsSinceEpoch) {
          BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Оновлення останнього аудиту для клієнта ${audit.clientId}");
          BlocProvider.of<ClientsCubit>(navigatorKey.currentContext!).updateClientLastAudit(audit.clientId, BlocProvider.of<UserCubit>(navigatorKey.currentContext!).state?.name ?? "", audit.date);
          await FirebaseFirestore.instance.collection(tableClients).doc(audit.clientId).update({
            "lastAudit": audit.date,
            "userLastAudit": BlocProvider.of<UserCubit>(navigatorKey.currentContext!).state?.name ?? ""
          });
          await FirebaseFirestore.instance.collection(tableClientsShort).doc(audit.clientId).update({
            "lastAudit": audit.date,
            "userLastAudit": BlocProvider.of<UserCubit>(navigatorKey.currentContext!).state?.name ?? ""
          });
        }
      } catch(e) {
        BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("$e");
      }
    }
  }

  static Future<void> syncReviews(NetworkCubit network) async {
    var reviews = await LocalStorage().getAllReviews();
    for(var review in reviews) {
      var network = BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!);
      if(network.state != ConnectivityResult.wifi) return;

      BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Синхронизація огляду ${review.id}");
     try {
       var clientId = review.clientId;
       if(isCacheId(clientId))
         clientId = toFirebaseId(clientId);

       BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Збереження огляду ${review.id}");
       await ReviewRepository.addReview(review, clientId);
       BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Видалення огляду ${review.id}");
       await LocalStorage().removeReview(review);

       if(network.state == ConnectivityResult.none) {
         break;
       }
     } catch(e) {
       BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("$e");
     }
    }
  }

  static Future<void> syncClients(NetworkCubit network) async {
    var clients = await LocalStorage().getClients();

    for(var client in clients) {
      var network = BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!);
      if(network.state != ConnectivityResult.wifi) return;

      try {
        BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Синхронизація клієнту ${client.name}");
        var oldId = client.id;
        client.id = client.id.split("_")[0];
        BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Збереження клієнту ${client.name}");
        await ClientsRepository.createClient(client);
        client.id = oldId;
        BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("Видалення клієнту ${client.name}");
        await LocalStorage().removeClient(client);
        if(network.state == ConnectivityResult.none) {
          break;
        }
      } catch(e) {
        BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("$e");
      }
    }

    try {
      var clients = await ClientsShortRepository.getClients();
      try {
        var localClients = await LocalStorage().getClientsPreview();
        clients.addAll(localClients);
      } catch(e) {
        BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("$e");
      }

      BlocProvider.of<ClientsCubit>(navigatorKey.currentContext!).set(clients);
    } catch(e) {
      BlocProvider.of<SyncCubit>(navigatorKey.currentContext!).set("$e");
    }
  }
}