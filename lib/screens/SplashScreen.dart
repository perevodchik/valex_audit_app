import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valex_agro_audit_app/All.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      Global.build();

      NetworkRepository.subscribeToChanges();
      var state = await Connectivity().checkConnectivity();
      await NetworkRepository.refreshNetworkStatus();
      BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!).set(state);
      if(state == ConnectivityResult.none)
        await FirebaseFirestore.instance.disableNetwork();

      var user = User.fromShared(await SharedPreferences.getInstance());
      if(user.id == null || user.id!.isEmpty) {
        goToNamed(Routes.signIn, {}, isRemovePreviously: true);
      } else {
        BlocProvider.of<UserCubit>(context).set(user);
        goToNamed(Routes.main, {}, isRemovePreviously: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}