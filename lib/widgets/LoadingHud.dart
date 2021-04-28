import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../All.dart';

class LoadingHud extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.black45,
      child: AppProgressIndicator().center()
  );
}