import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:easy_localization/easy_localization.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SignInScreen> {
  TextEditingController? name, company, rang;

  @override
  void initState() {
    name = TextEditingController();
    company = TextEditingController();
    rang = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    name?.dispose();
    company?.dispose();
    rang?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgPicture.asset("assets/icons/valex_logo.svg", height: 100),
          Wrap(
            runSpacing: blockY * 2.5,
            children: [
              CustomRoundedTextField(name, hint: "login_pib".tr()),
              CustomRoundedTextField(company, hint: "login_company".tr()),
              CustomRoundedTextField(rang, hint: "login_rang".tr())
            ]
          ).marginSymmetricWidget(horizontal: margin5X),
          AppTextButton(Text("next".tr(), style: styleBoldP14.copyWith(color: blueAccent)), onPressed: () async {
            var user = User(
                name: name?.text ?? "",
                company: company?.text ?? "",
                rang: rang?.text ?? ""
            );
            BlocProvider.of<UserCubit>(navigatorKey.currentContext!).set(user);
            await UserRepository.createUser(user);
            user.toShared(await SharedPreferences.getInstance());
            // (await SharedPreferences.getInstance()).setString("user", user.id!);
            goToNamed(Routes.main, {}, isRemovePreviously: true);
          })
        ]
      ).safe()
    );
  }
}