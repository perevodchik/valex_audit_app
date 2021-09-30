import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../All.dart';

class ModalImageSourcePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        width: 320,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16)
        ),
        child: Stack(
            children: [
              Positioned(
                  top: height / 2 - 150,
                  left: 0,
                  right: 0,
                  child: Container(
                      padding: EdgeInsets.only(top: margin5Y),
                      height: 300,
                      width: 320,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16)
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("modal_pick_image".tr(), style: styleBoldP34.copyWith(color: blueDark, fontFamily: "Arial")),
                                  Text("modal_select_image_source".tr(), textAlign: TextAlign.center, style: styleNormalP14.copyWith(fontFamily: "Arial")).marginSymmetricWidget(horizontal: defaultMargin)
                                ]
                            ).marginWidget(bottom: margin5Y).expanded(),
                            Column(
                                children: [
                                  AppTextButton(
                                      Text("modal_from_camera".tr(), style: styleBoldP14.copyWith(color: blueAccent)),
                                      onPressed: () async {
                                        var r = await selectImage(source: ImageSource.camera);
                                        if(r != null)
                                          Navigator.pop(context, File(r.path));
                                      }
                                  ).width(width),
                                  AppTextButton(
                                      Text("modal_from_gallery".tr(), style: styleBoldP14.copyWith(color: blueAccent)),
                                      onPressed: () async {
                                        var r = await selectImage(source: ImageSource.gallery);
                                        print("select from gallery $r");
                                        if(r != null)
                                          Navigator.pop(context, File(r.path));
                                      }
                                  ).width(width)
                                ]
                            ).marginSymmetricWidget(horizontal: margin5X / 2)
                          ]
                      )
                  )
              )
            ]
        ).marginSymmetricWidget(horizontal: margin5X)
    );
  }
}