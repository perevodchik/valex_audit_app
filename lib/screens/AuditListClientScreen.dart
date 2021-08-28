import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class AuditListClientScreen extends StatefulWidget {
  final Map<String, dynamic> args;
  AuditListClientScreen(this.args);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AuditListClientScreen> {
  Map<String, dynamic> args = {};
  ClientFull? client;
  RefreshController? _refreshController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    args = widget.args;
    client = args["client"];
    _refreshController = RefreshController();
    load();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  Future<void> load() async {
    var audits = <ClientAudit> [];
    try {
      var networkAudits = await AuditRepository.getAudits(client!.id);
      audits.addAll(networkAudits);
    } catch(e) {}
    try {
      var localAudits = await LocalStorage().getAudits(client!.id);
      audits.addAll(localAudits);
    } catch(e) {}
    setState(() => client?.audits = audits);
  }

  @override
  Widget build(BuildContext context) {
    print("setState");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueAccent,
        title: Text("audits".tr()),
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark
      ),
      body: Column(
        children: [
          Container(
            child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: CustomHeader(
                    builder: (_, status) {
                      if(status == RefreshStatus.refreshing || status == RefreshStatus.completed)
                        return AppProgressIndicator().sized(25, 25).marginWidget(bottom: blockY * 2.5).center();
                      return Container();
                    }
                ),
                controller: _refreshController!,
                onRefresh: () async {
                  await load();
                  _refreshController?.refreshCompleted();
                },
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: client?.audits.length ?? 0,
                    itemBuilder: (_, i) => AuditItem(client!.audits[i], onDelete: () async {
                      client?.audits.removeWhere((a) => a.id == client!.audits[i].id);
                      setState(() {});
                    }).onClick(() async {
                      if(BlocProvider.of<UserCubit>(navigatorKey.currentContext!).state?.canCreate != true)
                        return;
                      await goToNamed(Routes.audit, {
                        "audit": client!.audits[i]
                      });
                      await load();
                    }).marginSymmetricWidget(horizontal: margin5X),
                    separatorBuilder: (_, i) => Container(height: 10)
                )
            ).marginWidget(top: blockY).expanded()
          ),
          BlocBuilder<UserCubit, User?>(
              builder: (_, state) {
                if(state?.canCreate != true)
                  return Container();
                return AppTextButton(Text("start_audit".tr(), style: styleBoldP14.copyWith(color: blueAccent)), onPressed: () async {
                  print(client);
                  await goToNamed(Routes.auditClient, {
                    "client": ClientPreview.fromClient(client!)
                  });
                  await load();
                }).width(width).marginSymmetricWidget(horizontal: margin5X).marginWidget(top: blockY * 1.5, bottom: blockY * 2.5);
              }
          )
        ]
      )
    );
  }
}