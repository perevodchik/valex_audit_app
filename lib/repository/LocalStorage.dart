import 'package:valex_agro_audit_app/All.dart';
import 'package:valex_agro_audit_app/repository/storage/Storage.dart';

class LocalStorage {
  static final ClientStorage clientStorage = ClientStorage();
  static final ClientShortStorage clientsPreviewStorage = ClientShortStorage();
  static final ReviewsStorage reviewsStorage = ReviewsStorage();
  static final AuditStorage auditStorage = AuditStorage();
  static final PotentialStorage potentialStorage = PotentialStorage();
  static final InventoryStorage inventoryStorage = InventoryStorage();
  static final ContactPeopleStorage contactPeopleStorage = ContactPeopleStorage();
  static final AdditionalQuestionStorage additionalQuestionStorage = AdditionalQuestionStorage();
  static final AuditDataStorage auditDataStorage = AuditDataStorage();
  static final AuditQuestionStorage auditQuestionStorage = AuditQuestionStorage();

  /// clients begin

  Future<List<ClientFull>> getClients() async {
    var clients = await clientStorage.getClients();
    for(var client in clients) {
      var potential = await getPotential(client.id);
      var inventory = await getInventory(client.id);
      var contactPeople = await getContactPeoples(client.id);
      client.contactPeoples = contactPeople;
      client.clientInventory = inventory;
      client.clientPotential = potential;
    }
    return clients;
  }

  Future<ClientFull?> getClient(clientId) async {
    var client = await clientStorage.getClient(clientId);
    var potential = await getPotential(client!.id);
    var inventory = await getInventory(client.id);
    var contactPeople = await getContactPeoples(client.id);
    client.contactPeoples = contactPeople;
    client.clientInventory = inventory;
    client.clientPotential = potential;
    return client;
  }

  Future<ClientFull> addClient(ClientFull client) async {
    var r = await clientStorage.addClient(client);

    for(var i in client.clientInventory) {
      i.clientId = r.id;
      await addInventory(i);
    }

    for(var p in client.clientPotential) {
      p.clientId = r.id;
      await addPotential(p);
    }

    for(var p in client.contactPeoples) {
      p.clientId = r.id;
      await addContactPeople(p);
    }

    await addClientPreview(ClientPreview.fromClient(r));

    return client;
  }

  Future<ClientFull> updateClient(ClientFull client) async {
    var r = await clientStorage.updateClient(client);

    for(var i in client.clientInventory) {
      if(i.isNeedDelete && i.id.isEmpty) continue;
      if(i.isNeedDelete)
        await removeInventory(i);
      else if(i.id.isEmpty) {
        i.clientId = r.id;
        await addInventory(i);
      } else await updateInventory(i);
    }

    for(var p in client.clientPotential) {
      if(p.isNeedDelete && p.id.isEmpty) continue;
      if(p.isNeedDelete)
        await removePotential(p);
      else if(p.id.isEmpty) {
        p.clientId = client.id;
        await addPotential(p);
      } else await updatePotential(p);
    }

    for(var p in client.contactPeoples) {
      if(p.isNeedDelete && p.id.isEmpty) continue;
      if(p.isNeedDelete)
        await removeContactPeople(p);
      else if(p.id.isEmpty) {
        p.clientId = r.id;
        await addContactPeople(p);
      } else await updateContactPeople(p);
    }

    await updateClientPreview(ClientPreview.fromClient(r));
    return client;
  }

  Future<void> removeClient(ClientFull client) async {
    await clientStorage.removeClient(client);
    removeContactPeoples(client.id);
    removeInventories(client.id);
    removePotentials(client.id);
  }

  Future<void> removeClientById(String id) async {
    await clientStorage.removeClientById(id);
    removeContactPeoples(id);
    removeInventories(id);
    removePotentials(id);
  }

  Future<void> removeClients(List<ClientFull> clients) async {
    await clientStorage.removeClients(clients);
    for(var client in clients) {
      removeContactPeoples(client.id);
      removeInventories(client.id);
      removePotentials(client.id);
    }
  }

  /// clients begin

  /// clients preview begin

  Future<List<ClientPreview>> getClientsPreview() async {
    var clients = await clientStorage.getClientsPreview();
    return clients;
  }

  Future<ClientPreview> addClientPreview(ClientPreview client) async {
    return await clientsPreviewStorage.addClient(client);
  }

  Future<ClientPreview> updateClientPreview(ClientPreview client) async {
    return await clientsPreviewStorage.updateClient(client);
  }

  Future<void> removeClientPreview(ClientPreview client) async {
    await clientsPreviewStorage.removeClient(client);
  }

  Future<void> removeClientsPreview(List<ClientPreview> clients) async {
    await clientsPreviewStorage.removeClients(clients);
  }

  /// clients preview begin


  /// reviews begin

  Future<List<ClientReview>> getReviews(String clientId) async {
    var reviews = await reviewsStorage.getReviews(clientId);
    for(var review in reviews) {
      review.questions = await getAdditionalQuestion(review.id);
    }

    return reviews;
  }

  Future<List<ClientReview>> getAllReviews() async {
    var reviews = await reviewsStorage.getAllReviews();
    for(var review in reviews) {
      review.questions = await getAdditionalQuestion(review.id);
    }

    return reviews;
  }

  Future<ClientReview> addReview(ClientReview review, ClientFull client) async {
    var r = await reviewsStorage.addReview(review, client);
    for(var q in r.questions) {
      q.id = generate(10);
      q.reviewId = review.id;
      await addAdditionalQuestion(q);
    }
    return r;
  }

  Future<void> removeReview(ClientReview review) async {
    await reviewsStorage.removeReview(review);
    await removeAdditionalQuestions(review.id);
  }

  Future<void> removeReviews(String clientId) async {
    await reviewsStorage.removeReviews(clientId);
  }

  /// reviews finish


  /// reviews begin

  Future<List<ClientAudit>> getAudits(String clientId) async {
    return await auditStorage.getAudits(clientId);
  }

  Future<List<ClientAudit>> getAuditsAll() async {
    return await auditStorage.getAuditsAll();
  }

  Future<ClientAudit?> getAudit(String auditId) async {
    var audit = await auditStorage.getAudit(auditId);
    audit?.data = await getAuditData(audit.id);
    audit?.auditQuestions = await getAuditQuestions(audit.id);
    return audit;
  }

  Future<ClientAudit> addAudit(ClientAudit audit) async {
    await auditStorage.addAudit(audit);
    for(var d in audit.data) {
      d.auditId = audit.id;
      await addAuditData(d);
    }
    for(var e in audit.auditQuestions.entries) {
      for(var entry in e.value.entries) {
        for(var question in entry.value) {
          int c = 0;
          for(var file in question.photos ?? []) {
            var fileName = "${audit.id}_${question.question}_${c++}.jpg";
            var f = await saveFileInTmpDir(file, fileName);
            if(f != null) {
              question.photosSrc?.add(f.path);
            }
          }
          question.questionTitle = entry.key;
          question.audit = e.key;
          question.auditId = audit.id;
          await addAuditQuestion(question);
        }
      }
    }
    return audit;
  }

  Future<void> removeAudit(ClientAudit audit) async {
    await auditStorage.removeAudit(audit);
  }

  Future<void> removeAudits(String clientId) async {
    await auditStorage.removeAudits(clientId);
  }

  /// reviews finish


  /// audit data begin

  Future<List<AuditData>> getAuditData(String auditId) async {
    return await auditDataStorage.getAuditData(auditId);
  }

  Future<AuditData> addAuditData(AuditData data) async {
    return auditDataStorage.addAuditData(data);
  }

  Future<void> deleteAuditData(String auditId) async {
    await auditDataStorage.deleteAuditData(auditId);
  }

  /// audit data finish


  /// audit question begin

  Future<Map<String, Map<String, List<ClientAuditQuestion>>>> getAuditQuestions(String auditId) async {
    return await auditQuestionStorage.getAuditQuestions(auditId);
  }

  Future<ClientAuditQuestion> addAuditQuestion(ClientAuditQuestion data) async {
    return await auditQuestionStorage.addAuditQuestion(data);
  }

  Future<void> deleteAuditQuestion(String auditId) async {
    await auditQuestionStorage.deleteAuditQuestion(auditId);
  }

  /// audit question finish


  /// contact people begin

  Future<List<ContactPeople>> getContactPeoples(String clientId) async {
    return await contactPeopleStorage.getContactPeoples(clientId);
  }

  Future<ContactPeople> addContactPeople(ContactPeople contact) async {
    return await contactPeopleStorage.addContactPeople(contact);
  }

  Future<ContactPeople> updateContactPeople(ContactPeople contact) async {
    return await contactPeopleStorage.updateContactPeople(contact);
  }

  Future<void> removeContactPeople(ContactPeople contact) async {
    await contactPeopleStorage.removeContactPeople(contact);
  }

  Future<void> removeContactPeoples(String clientId) async {
    await contactPeopleStorage.removeContactPeoples(clientId);
  }

  /// contact people finish

  /// potential begin

  Future<List<Potential>> getPotential(String clientId) async {
    return await potentialStorage.getPotential(clientId);
  }

  Future<Potential> addPotential(Potential potential) async {
    return await potentialStorage.addPotential(potential);
  }

  Future<Potential> updatePotential(Potential potential) async {
    return await potentialStorage.updatePotential(potential);
  }

  Future<void> removePotential(Potential potential) async {
    await potentialStorage.removePotential(potential);
  }

  Future<void> removePotentials(String clientId) async {
    await potentialStorage.removePotentials(clientId);
  }

  /// potential finish

  /// inventory begin

  Future<List<Inventory>> getInventory(String clientId) async {
    return await inventoryStorage.getInventory(clientId);
  }

  Future<Inventory> addInventory(Inventory inventory) async {
    return await inventoryStorage.addInventory(inventory);
  }

  Future<Inventory> updateInventory(Inventory inventory) async {
    return await inventoryStorage.updateInventory(inventory);
  }

  Future<void> removeInventory(Inventory inventory) async {
    await inventoryStorage.removeInventory(inventory);
  }

  Future<void> removeInventories(String clientId) async {
    await inventoryStorage.removeInventories(clientId);
  }

  /// inventory finish

  /// additional question begin

  Future<List<ClientAdditionalQuestion>> getAdditionalQuestion(String reviewId) async {
    return await additionalQuestionStorage.getAdditionalQuestion(reviewId);
  }

  Future<ClientAdditionalQuestion> addAdditionalQuestion(ClientAdditionalQuestion question) async {
    return await additionalQuestionStorage.addAdditionalQuestion(question);
  }

  Future<void> removeAdditionalQuestion(ClientAdditionalQuestion question) async {
    await additionalQuestionStorage.removeAdditionalQuestion(question);
  }

  Future<void> removeAdditionalQuestions(String reviewId) async {
    await additionalQuestionStorage.removeAdditionalQuestions(reviewId);
  }

  /// additional question finish
}