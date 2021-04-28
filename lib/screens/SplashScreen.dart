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
      var userId = (await SharedPreferences.getInstance()).getString("user");
      print("userId: [ $userId ]");
      NetworkRepository.subscribeToChanges();
      var state = await Connectivity().checkConnectivity();
      await NetworkRepository.refreshNetworkStatus();
      BlocProvider.of<NetworkCubit>(navigatorKey.currentContext!).set(state);
      if(state == ConnectivityResult.none)
        await FirebaseFirestore.instance.disableNetwork();
      if(userId != null && userId.isNotEmpty) {
        var user = await UserRepository.getUserById(userId);
        print("user: [ $user ]");
        if(user != null) {
          goToNamed(Routes.main, {}, isRemovePreviously: true);
          return;
        }
      }
      goToNamed(Routes.signIn, {}, isRemovePreviously: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}