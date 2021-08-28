import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../All.dart';

class AuditRepository {

  static Future<ClientAudit> updateAudit(ClientAudit audit) async {
    for(var q0 in audit.auditQuestions.entries) {
      for(var q1 in q0.value.entries) {
        for(var question in q1.value) {
          if(question.isChangePhoto != true)
            continue;
          int c = 0;
          for(var photo in question.photos ?? []) {
            var fileName = "${audit.id}/${question.question}_$c.png";
            question.photosSrc?.add(fileName);
            c++;
          }
        }
      }
    }

    await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(audit.clientId)
        .collection(tableAuditsShort)
        .doc(audit.id)
        .set(audit.toJsonShort());
    await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(audit.clientId)
        .collection(tableAudits)
        .doc(audit.id)
        .set(audit.toJson());
    await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(audit.clientId)
        .collection(tableAudits)
        .doc(audit.id)
        .set(audit.toJson());
    await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(audit.clientId)
        .collection(tableAuditsShort)
        .doc(audit.id)
        .set(audit.toJsonShort());

    for(var q0 in audit.auditQuestions.entries) {
      for(var q1 in q0.value.entries) {
        for(var question in q1.value) {
          if(question.isChangePhoto != true)
            continue;

          for(var i = 0; i < (question.photos?.length ?? 0); i++) {
            var fileName = question.photosSrc![i];
            var storageRef = FirebaseStorage
                .instance
                .ref()
                .child("$fileName");
            var file = question.photos![i];

            // TODO compress
            // print("pre compress ${file.lengthSync()}")
            // var result = await FlutterImageCompress.compressWithFile(
            //     file.absolute.path,
            //     quality: 70
            // );
            // file.writeAsBytes(result!.toList());
            // print("post compress ${file.lengthSync()}");

            var uploadTask = await storageRef.putFile(file);
            var url = await uploadTask.ref.getDownloadURL();
            try {
              question.photosSrc![i] = url;
            } catch(e) {print("e0 $e");}
            question.photosSrc?.add(fileName);
          }
        }
      }
    }
    return audit;
  }

  static Future<void> removeAudit(String clientId, String auditId) async {
    await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(clientId)
        .collection(tableAuditsShort)
        .doc(auditId)
        .delete();
    await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(clientId)
        .collection(tableAudits)
        .doc(auditId)
        .delete();
    await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(clientId)
        .collection(tableAudits)
        .doc(auditId)
        .delete();
    await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(clientId)
        .collection(tableAuditsShort)
        .doc(auditId)
        .delete();
  }

  static Future<ClientAudit> addAudit(ClientAudit audit, {StreamController<String>? s}) async {
    var oldId = audit.id;
    audit.id = generate(20);
    s?.add("Підготовка медіа даних");
    int allPhotos = 0;
    int countPhotos = 0;
    for(var q0 in audit.auditQuestions.entries) {
      for(var q1 in q0.value.entries) {
        for(var question in q1.value) {
          int c = 0;
          for(var photo in question.photos ?? []) {
            s?.add("Підготовка фото: $countPhotos");
            countPhotos++;
            var fileName = "${audit.id}/${question.question}_$c.png";
            question.photosSrc?.add(fileName);
            c++;
          }
        }
      }
    }
    allPhotos = countPhotos;

    s?.add("Збереження короткої інформації аудиту");
    await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(audit.clientId)
        .collection(tableAuditsShort)
        .doc(audit.id)
        .set(audit.toJsonShort());
    s?.add("Збереження аудиту");
    await FirebaseFirestore
        .instance
        .collection(tableClients)
        .doc(audit.clientId)
        .collection(tableAudits)
        .doc(audit.id)
        .set(audit.toJson());
    s?.add("Збереження аудиту");
    await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(audit.clientId)
        .collection(tableAudits)
        .doc(audit.id)
        .set(audit.toJson());
    s?.add("Збереження короткої інформації аудиту");
    await FirebaseFirestore
        .instance
        .collection(tableClientsShort)
        .doc(audit.clientId)
        .collection(tableAuditsShort)
        .doc(audit.id)
        .set(audit.toJsonShort());

    countPhotos = 0;

    for(var q0 in audit.auditQuestions.entries) {
      for(var q1 in q0.value.entries) {
        for(var question in q1.value) {
          for(var i = 0; i < (question.photos?.length ?? 0); i++) {
            var fileName = question.photosSrc![i];
            var storageRef = FirebaseStorage
                .instance
                .ref()
                .child("$fileName");
            var file = question.photos![i];

            // TODO compress
            // print("pre compress ${file.lengthSync()}")
            // var result = await FlutterImageCompress.compressWithFile(
            //     file.absolute.path,
            //     quality: 70
            // );
            // file.writeAsBytes(result!.toList());
            // print("post compress ${file.lengthSync()}");

            s?.add("Збереження фото: $countPhotos/$allPhotos");
            countPhotos++;
            var uploadTask = await storageRef.putFile(file);
            var url = await uploadTask.ref.getDownloadURL();
            try {
              question.photosSrc![i] = url;
            } catch(e) {print("e0 $e");}
            question.photosSrc?.add(fileName);
          }
        }
      }
    }
    s?.add("Аудит збережено!");
    audit.id = oldId;
    return audit;
  }

  static Future<List<ClientAudit>> getAudits(String clientId) async {
    var audits = <ClientAudit> [];
    var r = await FirebaseFirestore
        .instance
        .collection("clients")
        .doc(clientId)
        .collection(tableAuditsShort)
        .orderBy("date", descending: true)
        .get();
    for(var dataSet in r.docs) {
      var a = ClientAudit.fromJson(dataSet.data());

      for(var q1 in a.auditQuestions.entries) {
        for(var q0 in q1.value.entries) {
          for(var question in q0.value) {
            for(var p = 0; p > question.photosSrc!.length; p++) {
              var storageRef = FirebaseStorage
                  .instance
                  .ref()
                  .child(question.photosSrc![p]);
              var newPath = await storageRef.getDownloadURL();
              question.photosSrc![p] = newPath;
            }
          }
        }
      }

      a.id = dataSet.id;
      audits.add(a);
    }
    return audits;
  }

  static Future<List<String>> getAuditList(String clientId) async {
    var audits = <String> [];
    var r = await FirebaseFirestore
        .instance
        .collection("clients")
        .doc(clientId)
        .collection(tableAuditsShort)
        .orderBy("date", descending: true)
        .get();
    for(var dataSet in r.docs)
      audits.add(dataSet.id);
    return audits;
  }

  static Future<ClientAudit?> getAudit(String auditId, String clientId) async {
    var r = await FirebaseFirestore
        .instance
        .collection("clients")
        .doc(clientId)
        .collection(tableAudits)
        .doc(auditId)
        .get();
   if(!r.exists) return null;
   var a = ClientAudit.fromJson(r.data()!);

    for(var q1 in a.auditQuestions.entries) {
      for(var q0 in q1.value.entries) {
        for(var question in q0.value) {
          for(var p = 0; p < question.photosSrc!.length; p++) {
            try {
              if(question.photosSrc![p].isEmpty) continue;
              var storageRef = FirebaseStorage
                  .instance
                  .ref()
                  .child(question.photosSrc![p]);
              var newPath = await storageRef.getDownloadURL();
              print("1 ${question.photosSrc![p]}");
              print("path) $newPath");
              question.photosSrc![p] = newPath;
            } catch(e) {
              print("e $e");
            }
          }
        }
      }
    }

   a.id = r.id;
   return a;
  }
}