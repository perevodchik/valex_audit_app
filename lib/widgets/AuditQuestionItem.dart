import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:valex_agro_audit_app/widgets/modals/ModalCarousel.dart';

class AuditQuestionItem extends StatefulWidget {
  final ClientAuditQuestion data;
  final bool isEditable;
  final bool isCached;
  AuditQuestionItem(this.data, {this.isEditable = true, this.isCached = false});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AuditQuestionItem> {
  TextEditingController? firstRate, secondRate, question, rateParam, comment;
  List<String> questions = [];
  String currentQuestion = "";
  Widget leading = Container();

  @override
  void initState() {
    firstRate = TextEditingController(text: widget.data.firstRate.toString());
    secondRate = TextEditingController(text: widget.data.secondRate.toString());
    question = TextEditingController(text: widget.data.question);
    rateParam = TextEditingController(text: widget.data.rateParam);
    comment = TextEditingController(text: widget.data.comment);

    var v = int.tryParse(widget.data.firstRate.toString()) ?? 1;
    if(v == 1)
      leading = SvgPicture.asset("assets/icons/warning.svg", height: 30, width: 30);
    else if(v == 2)
      leading = SvgPicture.asset("assets/icons/alert.svg", height: 30, width: 30);
    else if(v == 3)
      leading = SvgPicture.asset("assets/icons/perfect.svg", height: 30, width: 30);
    else leading = Container(height: 30, width: 30);

    questions.add("");
    questions.add("question_${widget.data.question}_0");
    questions.add("question_${widget.data.question}_1");
    questions.add("question_${widget.data.question}_2");
    currentQuestion = questions.first;
    super.initState();
  }

  @override
  void dispose() {
    firstRate?.dispose();
    secondRate?.dispose();
    question?.dispose();
    rateParam?.dispose();
    comment?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.data.photosSrc?.removeWhere((s) => s.isEmpty);
    currentQuestion = widget.data.rateParam;
    // if(widget.data.photosSrc?.isEmpty ?? false)
      print(File("/data/user/0/com.perevodchik.valex_agro_audit_app/app_flutter/m8r44gt2KB9R16Ho2bnO_07u951rN7tB4NNEy2gr1_zhorskist_0.png").existsSync());
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: greyMedium)
        ),
        child: Wrap(
            runSpacing: 10,
            children: [
              Text(widget.data.question, style: styleBoldP16.copyWith(color: blueAccent)),
              if(widget.data.withRate)
              Row(
                children: [
                  CustomRoundedTextField(firstRate, hint: "firstRate", helperText: "firstRate",
                      formatters: [
                        FilteringTextInputFormatter(RegExp(r"^[1-3]$"), allow: true, replacementString: "")
                      ],
                      onChanged: (r) {
                        var v = int.tryParse(r) ?? 0;
                        if(v == 1)
                          leading = SvgPicture.asset("assets/icons/warning.svg", height: 30, width: 30);
                        else if(v == 2 || v == 0)
                          leading = SvgPicture.asset("assets/icons/alert.svg", height: 30, width: 30);
                        else if(v == 3)
                          leading = SvgPicture.asset("assets/icons/perfect.svg", height: 30, width: 30);
                        else leading = Container(height: 30, width: 30);
                        setState(() {});
                        widget.data.firstRate = v.toString();
                      }, isEnable: widget.isEditable).expanded(),
                  Container(width: 10),
                  CustomRoundedTextField(secondRate, hint: "", helperText: "",
                      isEnable: false, leading: leading).expanded()
                ]
              ).height(50),
              if(widget.data.withSelector)
              AbsorbPointer(
                absorbing: !widget.isEditable,
                child: AppRoundedDropdown(
                    questions,
                    currentQuestion,
                        (q) {
                      setState(() {
                        currentQuestion = q;
                        widget.data.rateParam = currentQuestion;
                      });
                    })
              ).width(width),
              CustomRoundedTextField(comment, hint: "comment", helperText: "comment", maxLines: 3,
                  onChanged: (c) => widget.data.comment = c, isEnable: widget.isEditable).center(),
              Row(
                children: [
                  Icon(Icons.add_circle_outline_rounded, color: blueAccent).onClick(() async {
                    var r = await showDialog(
                      context: context,
                      builder: (_) => ModalImageSourcePicker()
                    );
                    if(r != null)
                      setState(() => widget.data.photos?.add(r));
                  }),
                  if(!widget.isEditable)
                    if(widget.isCached)
                      Row(
                          children: (widget.data.photosSrc ?? []).map<Widget>((s) => Container(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(File(s))
                              )
                          ).onClick(() {
                            showModal(ModalCarouselNetwork(widget.data.photosSrc ?? []));
                          })).toList()
                      ).scrollWidget()
                      else
                      Row(
                          children: (widget.data.photosSrc ?? []).map<Widget>((s) => Container(
                              height: 100,
                              width: 100,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                      imageUrl: s,
                                      placeholder: (context, url) => CircularProgressIndicator().center(),
                                      errorWidget: (context, url, error) => Icon(Icons.error)
                                  )
                              )
                          ).onClick(() {
                            showModal(ModalCarouselNetwork(widget.data.photosSrc ?? []));
                          })).toList()
                      ).scrollWidget()
                  else if(widget.data.auditId?.isEmpty ?? true)
                    Row(
                        children: (widget.data.photos ?? []).map<Widget>((f) => Stack(
                            children: [
                              Container(
                                  height: 100,
                                  width: 100,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(f)
                                  )
                              ).onClick(() {
                                showModal(ModalCarousel(widget.data.photos ?? []));
                              }),
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Icon(Icons.remove_circle_outline_outlined, color: blueAccent).onClick(() => setState(() => widget.data.photos?.remove(f)))
                              )
                            ]
                        )).toList()
                    ).scrollWidget()
                  else Row(
                      children: (widget.data.photos ?? []).map<Widget>((f) => Container(
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(f)
                          )
                      )).toList()
                  ).scrollWidget()
                ]
              )
            ]
        )
    );
  }
}