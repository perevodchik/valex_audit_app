import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../All.dart';

class EditClientScreen extends StatefulWidget {
  final Map<String, dynamic>? args;
  EditClientScreen(this.args);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EditClientScreen> {
  TextEditingController? name, address, inventory, countPC, countCow;
  List<ContactPeople> contactPeoples = [];
  List<Inventory> inventoryItems = [];
  PageController? page;
  int currentPage = 0;
  ClientFull? client;
  Map<String, dynamic> args = {};
  ClientPreview? clientPreview;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    args = widget.args ?? {};
    clientPreview = args["client"];
    super.didChangeDependencies();
  }

  @override
  void initState() {
    name = TextEditingController();
    address = TextEditingController();
    inventory = TextEditingController();
    countPC = TextEditingController();
    countCow = TextEditingController();
    page = PageController();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if(clientPreview!.isCached) {
        client = await LocalStorage().getClient(clientPreview!.id);
        name?.text = client?.name ?? "";
        address?.text = client?.address ?? "";
        inventory?.text = client?.inventory ?? "";
        countPC?.text = (client?.countPC ?? 0).toString();
        countCow?.text = (client?.countCow ?? 0).toString();
        contactPeoples.addAll(client?.contactPeoples ?? <ContactPeople>[]);
        inventoryItems.addAll(client?.clientInventory ?? <Inventory>[]);
      } else {
        FirebaseFirestore
            .instance
            .collection(tableClients)
            .doc(clientPreview?.id ?? "123")
            .get().then((r) async {
          if(!r.exists) return;

          var clientFull = ClientFull.fromJson(r.data()!);
          clientFull.id = r.id;
          client = clientFull;
          name?.text = client?.name ?? "";
          address?.text = client?.address ?? "";
          inventory?.text = client?.inventory ?? "";
          countPC?.text = (client?.countPC ?? 0).toString();
          countCow?.text = (client?.countCow ?? 0).toString();
          contactPeoples.addAll(client?.contactPeoples ?? <ContactPeople>[]);
          inventoryItems.addAll(client?.clientInventory ?? <Inventory>[]);
        });
      }

    });
    super.initState();
  }

  @override
  void dispose() {
    name?.dispose();
    address?.dispose();
    inventory?.dispose();
    countPC?.dispose();
    countCow?.dispose();
    page?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("client_edit".tr()),
            backgroundColor: blueAccent,
            elevation: 0,
            brightness: Brightness.dark
        ),
        body: Stack(
          children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PageView(
                      onPageChanged: (p) => setState(() => currentPage = p),
                      controller: page,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("main_info".tr(), style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY * 1.5),
                              Wrap(
                                  runSpacing: 10,
                                  children: [
                                    CustomRoundedTextField(name, hint: "client_name".tr(), helperText: "client_name".tr()),
                                    CustomRoundedTextField(address, hint: "client_address".tr(), helperText: "client_address".tr()),
                                    CustomRoundedTextField(inventory, hint: "client_inventory".tr(), helperText: "client_inventory".tr()),
                                    CustomRoundedTextField(countPC, hint: "client_countPC".tr(), helperText: "client_countPC".tr()),
                                    CustomRoundedTextField(countCow, hint: "client_countCow".tr(), helperText: "client_countCow".tr())
                                  ]
                              ).marginSymmetricWidget(horizontal: margin5X)
                            ]
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("client_contact_peoples".tr(), style: styleBoldP20),
                                    Icon(Icons.add_circle_outline_rounded, color: blueAccent).onClick(() =>
                                        setState(() => contactPeoples.add(ContactPeople.empty()))
                                    )
                                  ]
                              ).marginSymmetricWidget(horizontal: margin5X, vertical: blockY * 1.5),

                              Container(
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: contactPeoples.length,
                                      itemBuilder: (_, i) {
                                        if(contactPeoples[i].isNeedDelete)
                                          return Container();
                                        else return Dismissible(
                                            key: Key(contactPeoples[i].id),
                                            child: ContactPeopleItem(contactPeoples[i]).marginSymmetricWidget(horizontal: margin5X),
                                            onDismissed: (direction) => setState(() => contactPeoples[i].isNeedDelete = true)
                                        );
                                      },
                                      separatorBuilder: (_, i) => Container(height: blockY)
                                  ).scrollWidget()
                              ).expanded()
                            ]
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("client_inventory".tr(), style: styleBoldP20),
                                    Icon(Icons.add_circle_outline_rounded, color: blueAccent).onClick(() =>
                                        setState(() => inventoryItems.add(Inventory.empty()))
                                    )
                                  ]
                              ).marginSymmetricWidget(horizontal: margin5X, vertical: blockY * 1.5),
                              Container(
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      itemCount: inventoryItems.length,
                                      itemBuilder: (_, i) {
                                        if(inventoryItems[i].isNeedDelete)
                                          return Container();
                                        return Dismissible(
                                            key: Key(inventoryItems[i].id),
                                            child: InventoryItem(inventoryItems[i]).marginSymmetricWidget(horizontal: margin5X),
                                            onDismissed: (direction) => setState(() => inventoryItems[i].isNeedDelete = true)
                                        );
                                      },
                                      separatorBuilder: (_, i) => Container(height: blockY)
                                  )
                              ).expanded()
                            ]
                        )
                      ]
                  ).expanded(),
                  Row(
                      children: [
                        (currentPage > 0 ? AppTextButton(
                            Text("back".tr(), style: styleBoldP14.copyWith(color: blueAccent)),
                            onPressed: () => page?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn)
                        ) : Container()).expanded(),
                        Container(width: 20),
                        AppElevatedButton(
                            Text(currentPage < 2 ? "next".tr() : "save".tr(), style: styleBoldP14.copyWith(color: Colors.white)),
                            onPressed: () async {
                              if(currentPage == 2) {
                                if(isLoading) return;
                                setState(() => isLoading = true);
                              }
                              if(currentPage < 2) {
                                page?.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                                return;
                              }
                              var newClient = ClientFull(
                                  client!.id,
                                  name?.text ?? "",
                                  address?.text ?? "",
                                  inventory?.text ?? "",
                                  int.tryParse(countPC?.text ?? "") ?? 0,
                                  int.tryParse(countCow?.text ?? "") ?? 0,
                                  DateTime.now().millisecondsSinceEpoch,
                                  client?.lastAudit,
                                  contactPeoples,
                                  inventoryItems,
                                  <Potential>[],
                                  <ClientAudit>[]
                              );

                              await NetworkRepository.refreshNetworkStatus();
                              if(BlocProvider.of<NetworkCubit>(context).state == ConnectivityResult.none) {
                                if(newClient.isCached)
                                  await LocalStorage().updateClient(newClient);
                                else {
                                  FirebaseFirestore
                                      .instance
                                      .collection(tableClients)
                                      .doc(newClient.id)
                                      .update(newClient.toJson());
                                  ClientsShortRepository.updateClient(ClientPreview.fromClient(newClient));
                                }
                              } else {
                                await ClientsRepository.updateClient(newClient);
                              }
                              await Future.delayed(Duration(seconds: 1));
                              var clientPreview = ClientPreview.fromClient(newClient);
                              BlocProvider.of<ClientsCubit>(navigatorKey.currentContext!).update(clientPreview);
                              Navigator.pop(context);
                            }
                        ).expanded()
                      ]
                  ).width(width).marginSymmetricWidget(horizontal: margin5X)
                ]
            ).safe(),
            if(isLoading)
              LoadingHud()
          ]
        )
    );
  }
}