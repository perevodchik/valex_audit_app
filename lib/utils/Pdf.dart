import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:valex_agro_audit_app/All.dart';
import 'package:http/http.dart' as http;

Future<dynamic> createPdf(ClientAudit audit, bool imagesFromNetwork) async {
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy');
  final pdf = pw.Document();
  final logo = await rootBundle.loadString('assets/icons/valex_logo.svg');
  // rgbToCmykPdf(blueAccent.red, blueAccent.green, blueAccent.blue);
  // rgbToCmykPdf(blue.red, blue.green, blue.blue);
  // rgbToCmykPdf(blueDark.red, blueDark.green, blueDark.blue);

  var alert = await rootBundle.loadString('assets/icons/alert.svg');
  var warning = await rootBundle.loadString('assets/icons/warning.svg');
  var perfect = await rootBundle.loadString('assets/icons/perfect.svg');

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.SvgImage(svg: logo, width: 100),
            pw.Container(height: 10),
            pw.Container(
                padding: pw.EdgeInsets.all(5),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                          child: pw.Text("gospodarstvo")
                      ),
                      pw.Container(
                          child: pw.Text("visit_date ${dateFormat.format(DateTime.tryParse(audit.date) ?? DateTime.now())}")
                      )
                    ]
                )
            ),
            pw.Table.fromTextArray(
                headers: [],
                columnWidths: {
                  0: pw.IntrinsicColumnWidth(flex: 1),
                  1: pw.IntrinsicColumnWidth(flex: 1),
                  2: pw.IntrinsicColumnWidth(flex: 1)
                },
                data: audit.data.map<List<String>>((d) => [d.title, d.value, d.additional]).toList()
            )
          ]
        ); // Center
      }));

  var rows0 = <pw.TableRow> [];
  var rows1 = <pw.TableRow> [];
  var rows2 = <pw.TableRow> [];

  generateRows(rows0, audit, "audit_0", alert, warning, perfect);
  rows0.add(pw.TableRow(children: [
    pw.Container(height: 50)
  ]));
  generateRows(rows1, audit, "audit_1", alert, warning, perfect);
  rows1.add(pw.TableRow(children: [
    pw.Container(height: 50)
  ]));
  generateRows(rows2, audit, "audit_2", alert, warning, perfect);

  var wrapChildren = <pw.Widget> [];
  print("imagesFromNetwork $imagesFromNetwork");

  for(var e in audit.auditQuestions.entries) {
    for(var entry in e.value.entries) {
      for(var m in entry.value) {
        try {
          if(imagesFromNetwork) {
            if(m.photosSrc?.isEmpty ?? true) continue;
            for(var c = 0; c < (m.photosSrc?.length ?? 0); c++) {
              var p = m.photosSrc![c];
              print(p);
              var response = await http.get(Uri.parse(p));
              var bytes = response.bodyBytes;
              final image = pw.MemoryImage(bytes);
              wrapChildren.add(pw.Column(
                  children: [
                    pw.Text(m.question),
                    pw.Container(height: 10),
                    pw.Image(image, height: 300)
                  ]
              ));
            }
          } else {
            if(m.photosSrc?.isNotEmpty ?? false) {
              for(var c = 0; c < (m.photosSrc?.length ?? 0); c++) {
                var p = m.photosSrc![c];
                print(p);
                final image = pw.MemoryImage(File(p).readAsBytesSync());
                wrapChildren.add(pw.Column(
                    children: [
                      pw.Text(m.question),
                      pw.Container(height: 10),
                      pw.Image(image, height: 300)
                    ]
                ));
              }
            } else if(m.photos?.isNotEmpty ?? false) {
              for(var p in m.photos ?? <File?>[]) {
                final image = pw.MemoryImage(p!.readAsBytesSync());
                wrapChildren.add(pw.Column(
                    children: [
                      pw.Text(m.question),
                      pw.Container(height: 10),
                      pw.Image(image, height: 300)
                    ]
                ));
              }
            }
          }
        } catch(e) {
          print("error ${m.question} => $e");
        }
      }
    }
  }
  var wrap = pw.Wrap(
    direction: pw.Axis.horizontal,
    children: wrapChildren
  );

  var table = pw.Table(
    children: [
      pw.TableRow(
        children: [wrap]
      )
    ]
  );


  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context c) => [
        pw.Table(
            children: rows0
        )
      ]
  ));
  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context c) => [
        pw.Table(
            children: rows1
        )
      ]
  ));
  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context c) => [
        pw.Table(
            children: rows2
        )
      ]
  ));

  if(wrapChildren.isNotEmpty) {
  // if(rows.isNotEmpty) {
    var p = pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context c) => [
          table
          // pw.Table(
          //     children: rows
          // )
        ]
    );
    pdf.addPage(p);
  }


  final output = await getTemporaryDirectory();
  final file = File('${output.path}/example.pdf');
  await file.writeAsBytes(await pdf.save());
  Navigator.push(navigatorKey.currentContext!, CupertinoPageRoute(builder: (_) =>  PdfViewPage(file)));
}

Future<void> generateRows(List<pw.TableRow> rows, ClientAudit audit, String auditName,
    String alert, String warning, String perfect, {bool addBottomMargin = true}) async {
  bool isAddAuditTitle = false;
  if(audit.auditQuestions[auditName] == null) return;

  for(var e in audit.auditQuestions[auditName]!.entries) {
    if(!isAddAuditTitle) {
      isAddAuditTitle = true;
      rows.add(pw.TableRow(
          children: [
            pw.Container(
                decoration: pw.BoxDecoration(
                    border: pw.Border(
                        left: pw.BorderSide(color: PdfColors.black),
                        top: pw.BorderSide(color: PdfColors.black),
                        bottom: pw.BorderSide(color: PdfColors.black)
                    ),
                    color: pdfBlue.shade(.35)
                ),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.symmetric(vertical: 7.5),
                        child: pw.Text(auditName, textAlign: pw.TextAlign.center)
                      )
                    ]
                )
            )
          ]
      ));
    }
    rows.add(pw.TableRow(
        children: [
          pw.Container(
              decoration: pw.BoxDecoration(
                  border: pw.Border(
                      left: pw.BorderSide(color: PdfColors.black),
                      top: pw.BorderSide(color: PdfColors.black),
                      bottom: pw.BorderSide(color: PdfColors.black)
                  ),
                  color: pdfBlueAccent.shade(.35)
              ),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(vertical: 5),
                      child: pw.Text("${e.key}", textAlign: pw.TextAlign.center)
                    )
                  ]
              )
          )
        ]
    ));

    rows.add(pw.TableRow(
        children: [
          pw.Container(
              decoration: pw.BoxDecoration(
                  border: pw.Border(
                      left: pw.BorderSide(color: PdfColors.black),
                      top: pw.BorderSide(color: PdfColors.black),
                      bottom: pw.BorderSide(color: PdfColors.black)
                  )
              ),
              child: pw.Table(
                  children: [
                    pw.TableRow(
                        children: [
                          pw.Container(
                              width: 170,
                              padding: pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(color: PdfColors.black),
                                  color: pdfBlueAccent.shade(.2)
                              ),
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("revision_point", textAlign: pw.TextAlign.center)
                                  ]
                              )
                          ),
                          pw.Container(
                              width: 60,
                              padding: pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(color: PdfColors.black),
                                  color: pdfBlueAccent.shade(.2)
                              ),
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("rate", textAlign: pw.TextAlign.center)
                                  ]
                              )
                          ),
                          pw.Container(
                              width: 250,
                              padding: pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(color: PdfColors.black),
                                  color: pdfBlueAccent.shade(.2)
                              ),
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("revision_params", textAlign: pw.TextAlign.center)
                                  ]
                              )
                          ),
                          pw.Container(
                              width: 150,
                              padding: pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(color: PdfColors.black),
                                  color: pdfBlueAccent.shade(.2)
                              ),
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("comment", textAlign: pw.TextAlign.center)
                                  ]
                              )
                          )
                        ]
                    )
                  ]
              )
          )
        ]
    ));

    for(var q in e.value) {
      var t = pw.Table.fromTextArray(
          headers: [],
          data: [[
            q.question,
            if(q.withRate)
              q.firstRate,
            if(q.withRate)
              q.secondRate,
            if(q.withSelector)
              q.rateParam,
            q.comment
          ]],
          columnWidths: q.withRate && !q.withSelector ? {
            0: pw.FixedColumnWidth(170),
            1: pw.FixedColumnWidth(30),
            2: pw.FixedColumnWidth(30),
            3: pw.FixedColumnWidth(400)
          } : !q.withRate && !q.withSelector ? {
            0: pw.FixedColumnWidth(230),
            1: pw.FixedColumnWidth(400)
          } : {
            0: pw.FixedColumnWidth(170),
            1: pw.FixedColumnWidth(30),
            2: pw.FixedColumnWidth(30),
            3: pw.FixedColumnWidth(250),
            4: pw.FixedColumnWidth(150)
          });

      if(q.withRate && q.firstRate.isNotEmpty) {
        String icon = "";
        var rate = q.firstRate;

        switch (rate) {
          case "1": {
            icon = warning;
            break;
          }
          case "2": {
            icon = alert;
            break;
          }
          case "3": {
            icon = perfect;
            break;
          }
        }
        t.children[1].children[2] = pw.Container(
            child: pw.Center(
                child: pw.SvgImage(svg: icon, width: 15, height: 15)
            )
        );
      }
      rows.add(pw.TableRow(children: [t]));
    }
    if(addBottomMargin)
      rows.add(pw.TableRow(children: [
        pw.Container(height: 10)
      ]));
  }
}