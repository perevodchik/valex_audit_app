import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../All.dart';

class AuditRepository {

  static Future<ClientAudit> addAudit(ClientAudit audit) async {
    var oldId = audit.id;
    audit.id = generate(20);
    for(var q0 in audit.auditQuestions.entries) {
      for(var q1 in q0.value.entries) {
        for(var question in q1.value) {
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
          for(var i = 0; i < (question.photos?.length ?? 0); i++) {
            var fileName = question.photosSrc![i];
            var storageRef = FirebaseStorage
                .instance
                .ref()
                .child("$fileName");
            try {
              var uploadTask = await storageRef.putFile(question.photos![i]);
              var url = await uploadTask.ref.getDownloadURL();
              question.photosSrc![i] = url;
            } catch(e) {}
            question.photosSrc?.add(fileName);
          }
        }
      }
    }
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
            if(question.photosSrc![p].isEmpty) continue;
            var storageRef = FirebaseStorage
                .instance
                .ref()
                .child(question.photosSrc![p]);
            print("1 ${question.photosSrc![p]}");
            var newPath = await storageRef.getDownloadURL();
            print("path) $newPath");
            question.photosSrc![p] = newPath;
          }
        }
      }
    }

   a.id = r.id;
   return a;
  }
  
}