import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    var networkAudits = await AuditRepository.getAudits(client!.id);
    var localAudits = await LocalStorage().getAudits(client!.id);
    audits.addAll(localAudits);
    audits.addAll(networkAudits);
    setState(() => client?.audits = audits);
  }

  @override
  Widget build(BuildContext context) {
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
                    itemCount: client!.audits.length,
                    itemBuilder: (_, i) => AuditItem(client!.audits[i]).onClick(() async {
                      await goToNamed(Routes.audit, {
                        "audit": client!.audits[i]
                      });
                      setState(() {});
                    }).marginSymmetricWidget(horizontal: margin5X),
                    separatorBuilder: (_, i) => Container(height: 10)
                )
            ).marginWidget(top: blockY).expanded()
          ),
          AppTextButton(Text("start_audit".tr(), style: styleBoldP14.copyWith(color: blueAccent)), onPressed: () async {
            print(client);
            await goToNamed(Routes.auditClient, {
              "client": ClientPreview.fromClient(client!)
            });
            load();
          }).width(width).marginSymmetricWidget(horizontal: margin5X).marginWidget(top: blockY * 1.5, bottom: blockY * 2.5)
        ]
      )
    );
  }
}