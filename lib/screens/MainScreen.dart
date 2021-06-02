import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MainScreen> {
  bool isLoading = true;
  RefreshController? _refreshController;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      setState(() => isLoading = true);
      try {
        var clients = await ClientsShortRepository.getClients();
        var localClients = await LocalStorage().getClientsPreview();
        clients.addAll(localClients);
        BlocProvider.of<ClientsCubit>(navigatorKey.currentContext!).set(clients);
      } catch(e) {
        print("init clients error: $e");
      }
      setState(() => isLoading = false);
    });
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("ъї w1ыі ww/.".replaceAll(RegExp(r"[^ іІїЇа-яА-Яa-zA-Z0-9]"), "_"));
    return Scaffold(
      body: Column(
        children: [
          SvgPicture.asset("assets/icons/valex_logo.svg", height: 75).marginSymmetricWidget(vertical: blockY),
          BlocBuilder<ClientsCubit, List<ClientPreview>>(
            builder: (_, data) {
              if(isLoading)
                return AppProgressIndicator().center();
              return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: false,
                  header: CustomHeader(
                      builder: (_, status) {
                        print(status);
                        if(status == RefreshStatus.refreshing || status == RefreshStatus.completed)
                          return AppProgressIndicator().sized(25, 25).marginWidget(bottom: blockY * 2.5).center();
                        return Container();
                      }
                  ),
                  controller: _refreshController!,
                  onRefresh: () async {
                    try {
                      var clients = await ClientsShortRepository.getClients();
                      try {
                        var localClients = await LocalStorage().getClientsPreview();
                        clients.addAll(localClients);
                      } catch(e) {
                        print("e $e");
                      }
                      clients.sort((c0, c1) => (c0.createdAt ?? 0).compareTo(c1.createdAt ?? 0));
                      BlocProvider.of<ClientsCubit>(navigatorKey.currentContext!).set(clients);
                    } catch(e) {
                      print("init clients error: $e");
                    }
                    _refreshController?.refreshCompleted();
                  },
                  child: ListView(
                      shrinkWrap: true,
                      children: data.map<Widget>((c) => ClientPreviewWidget(c)
                          .marginWidget(left: margin5X, right: margin5X, bottom: blockY)
                      ).toList()
                  )
              );
            }
          ).expanded(),
          AppTextButton(
            Text("new_client".tr(), style: styleBoldP14.copyWith(color: blueAccent)),
            onPressed: () {
              goToNamed(Routes.newClient, {});
            }
          ).width(width).marginSymmetricWidget(horizontal: margin5X)
        ]
      ).safe()
    );
  }
}