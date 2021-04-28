import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:valex_agro_audit_app/screens/AuditClientScreen.dart';
import 'package:valex_agro_audit_app/screens/ReviewClientScreen.dart';
import 'package:valex_agro_audit_app/screens/EditClientScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true
  );
  await AppDatabase().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<UserCubit>(create: (BuildContext context) => UserCubit()),
          BlocProvider<ClientsCubit>(create: (BuildContext context) => ClientsCubit()),
          BlocProvider<NetworkCubit>(create: (BuildContext context) => NetworkCubit()),
          BlocProvider<SyncCubit>(create: (BuildContext context) => SyncCubit())
        ],
        child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Valex Agro Audit App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: Routes.splash,
            onGenerateRoute: (routerSettings) {
              switch(routerSettings.name) {
                  case Routes.splash:
                    return CupertinoPageRoute(builder: (_) => SplashScreen());
                  case Routes.signIn:
                    return CupertinoPageRoute(builder: (_) => SignInScreen());
                  case Routes.main:
                    return CupertinoPageRoute(builder: (_) => MainScreen());
                case Routes.client:
                  return CupertinoPageRoute(builder: (_) => ClientScreen(routerSettings.arguments as Map<String, dynamic>));
                  case Routes.newClient:
                    return CupertinoPageRoute(builder: (_) => NewClientScreen());
                  case Routes.editClient:
                    return CupertinoPageRoute(builder: (_) => EditClientScreen(routerSettings.arguments as Map<String, dynamic>));
                  case Routes.reviewClient:
                    return CupertinoPageRoute(builder: (_) => ReviewClientScreen(routerSettings.arguments as Map<String, dynamic>));
                  case Routes.reviewPage:
                    return CupertinoPageRoute(builder: (_) => ReviewPageScreen(routerSettings.arguments as Map<String, dynamic>));
                  case Routes.auditClient:
                    return CupertinoPageRoute(builder: (_) => AuditClientScreen(routerSettings.arguments as Map<String, dynamic>));
                  case Routes.auditListClient:
                    return CupertinoPageRoute(builder: (_) => AuditListClientScreen(routerSettings.arguments as Map<String, dynamic>));
                  case Routes.audit:
                    return CupertinoPageRoute(builder: (_) => AuditScreen(routerSettings.arguments as Map<String, dynamic>));
                  default:
                    return CupertinoPageRoute(builder: (_) => SplashScreen());
              }
            }
        )
    );
  }
}