import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:valex_agro_audit_app/widgets/ContactPeopleItem.dart';
import 'package:valex_agro_audit_app/widgets/InventoryItem.dart';

class NewClientScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<NewClientScreen> {
  TextEditingController? name, address, inventory, countPC, countCow;
  List<ContactPeople> contactPeoples = [];
  List<Inventory> inventoryItems = [];
  PageController? page;
  int currentPage = 0;
  bool isLoading = false;

  @override
  void initState() {
    name = TextEditingController();
    address = TextEditingController();
    inventory = TextEditingController();
    countPC = TextEditingController();
    countCow = TextEditingController();
    page = PageController();
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
          title: Text("new_client"),
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
                            Text("main_info", style: styleBoldP20).marginSymmetricWidget(horizontal: margin5X, vertical: blockY * 1.5),
                            Wrap(
                                runSpacing: 10,
                                children: [
                                  CustomRoundedTextField(name, hint: "name", helperText: "name"),
                                  CustomRoundedTextField(address, hint: "address", helperText: "address"),
                                  CustomRoundedTextField(inventory, hint: "inventory", helperText: "inventory"),
                                  CustomRoundedTextField(countPC, hint: "countPC", helperText: "countPC"),
                                  CustomRoundedTextField(countCow, hint: "countCow", helperText: "countCow")
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
                                  Text("contact_peoples", style: styleBoldP20),
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
                                    itemBuilder: (_, i) => Dismissible(
                                        key: Key(contactPeoples[i].id),
                                        child: ContactPeopleItem(contactPeoples[i]).marginSymmetricWidget(horizontal: margin5X),
                                        onDismissed: (direction) => setState(() => contactPeoples.removeAt(i))
                                    ),
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
                                  Text("inventory", style: styleBoldP20),
                                  Icon(Icons.add_circle_outline_rounded, color: blueAccent).onClick(() =>
                                      setState(() => inventoryItems.add(Inventory.empty()))
                                  )
                                ]
                            ).marginSymmetricWidget(horizontal: margin5X, vertical: blockY * 1.5),
                            Container(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: inventoryItems.length,
                                    itemBuilder: (_, i) => Dismissible(
                                        key: Key(inventoryItems[i].id),
                                        child: InventoryItem(inventoryItems[i]).marginSymmetricWidget(horizontal: margin5X),
                                        onDismissed: (direction) => setState(() => inventoryItems.removeAt(i))
                                    ),
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
                          Text("back", style: styleBoldP14.copyWith(color: blueAccent)),
                          onPressed: () => page?.previousPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn)
                      ) : Container()).expanded(),
                      Container(width: 20),
                      AppElevatedButton(
                          Text(currentPage < 2 ? "next" : "save", style: styleBoldP14.copyWith(color: Colors.white)),
                          onPressed: () async {
                            if(currentPage == 2) {
                              if(isLoading) return;
                              setState(() => isLoading = true);
                              try {
                                var client = ClientFull(
                                    "",
                                    name?.text ?? "",
                                    address?.text ?? "",
                                    inventory?.text ?? "",
                                    int.tryParse(countPC?.text ?? "") ?? 0,
                                    int.tryParse(countCow?.text ?? "") ?? 0,
                                    DateTime.now().millisecondsSinceEpoch,
                                    contactPeoples,
                                    inventoryItems,
                                    <Potential>[],
                                    <ClientAudit>[]
                                );
                                await NetworkRepository.refreshNetworkStatus();
                                if(BlocProvider.of<NetworkCubit>(context).state == ConnectivityResult.none || !(await NetworkRepository.hasNetwork())) {
                                  await LocalStorage().addClient(client);
                                } else {
                                  await ClientsRepository.createClient(client);
                                }
                                var clientPreview = ClientPreview.fromClient(client);
                                BlocProvider.of<ClientsCubit>(navigatorKey.currentContext!).add([clientPreview]);
                              } catch(e) {}
                              setState(() => isLoading = false);
                              Navigator.pop(context);
                            }
                            if(currentPage < 2) {
                              page?.nextPage(duration: Duration(milliseconds: 350), curve: Curves.easeIn);
                              return;
                            }
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