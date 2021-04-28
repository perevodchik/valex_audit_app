import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../All.dart';

class ModalImageSourcePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Container(
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
                                      Text("pick_image", style: styleBoldP34.copyWith(color: blueDark, fontFamily: "Arial")),
                                      Text("select_image_source", textAlign: TextAlign.center, style: styleNormalP14.copyWith(fontFamily: "Arial")).marginSymmetricWidget(horizontal: defaultMargin)
                                    ]
                                ).marginWidget(bottom: margin5Y).expanded(),
                                Column(
                                  children: [
                                    AppTextButton(
                                      Text("from_camera", style: styleBoldP14.copyWith(color: blueAccent)),
                                      onPressed: () async {
                                        var r = await selectImage(source: ImageSource.camera);
                                        if(r != null)
                                          Navigator.pop(context, File(r.path));
                                      }
                                    ).width(width),
                                    AppTextButton(
                                      Text("from_gallery", style: styleBoldP14.copyWith(color: blueAccent)),
                                        onPressed: () async {
                                          var r = await selectImage(source: ImageSource.gallery);
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
        )
    );
  }
}