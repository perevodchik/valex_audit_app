import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:valex_agro_audit_app/All.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';

Future<dynamic> createPdf(ClientAudit audit, bool imagesFromNetwork, {String company = "Valex Agro", String manager = "Ісаев Денис"}) async {
  final DateFormat dateFormat = DateFormat('dd.MM.yyyy');

  var theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Regular.ttf")),
    bold: pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Bold.ttf")),
    italic: pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-Italic.ttf")),
    boldItalic: pw.Font.ttf(await rootBundle.load("assets/fonts/OpenSans-BoldItalic.ttf")),
  );

  final pdf = pw.Document(theme: theme);
  final logo = await rootBundle.loadString('assets/icons/valex_logo.svg');

  var data = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
  var openSans = pw.Font.ttf(data);
  var style = pw.TextStyle(font: openSans);

  var alert = await rootBundle.loadString('assets/icons/alert.svg');
  var warning = await rootBundle.loadString('assets/icons/warning.svg');
  var perfect = await rootBundle.loadString('assets/icons/perfect.svg');

  var header = pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("DeLaval", style: pw.TextStyle(fontSize: 26, color: pdfBlue.shade(.35), fontWeight: pw.FontWeight.bold)),
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text("pdf_tov".tr(args: [company]), style: pw.TextStyle(fontSize: 20, color: pdfBlue.shade(.35), fontWeight: pw.FontWeight.bold)),
              pw.Text("pdf_dealer".tr(), style: pw.TextStyle(fontSize: 14, color: pdfBlue.shade(.35), fontWeight: pw.FontWeight.normal))
            ]
        )
      ]
  );
  var footer = pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Text("pdf_program".tr(), style: pw.TextStyle(fontSize: 16, color: pdfBlue.shade(.35), fontWeight: pw.FontWeight.normal)),
                  pw.Text(" \"".tr(), style: pw.TextStyle(fontSize: 16, color: pdfBlue.shade(.35), fontWeight: pw.FontWeight.normal)),
                  pw.Text("pdf_program_title".tr(), style: pw.TextStyle(fontSize: 16, color: pdfBlue.shade(.35), fontWeight: pw.FontWeight.bold)),
                  pw.Text("\"".tr(), style: pw.TextStyle(fontSize: 16, color: pdfBlue.shade(.35), fontWeight: pw.FontWeight.normal))
                ]
              ),
              pw.Text("pdf_manager".tr(args: [manager]), style: pw.TextStyle(fontSize: 16, color: pdfBlue.shade(.35), fontWeight: pw.FontWeight.normal))
            ]
        )
      ]
  );

  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      footer: (c) => footer,
      header: (c) => header,
      build: (pw.Context context) {
        return [
          pw.Container(
              padding: pw.EdgeInsets.all(5),
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                        child: pw.Text("pdf_gospodarstvo".tr())
                    ),
                    pw.Container(
                        child: pw.Text("pdf_visit_date".tr(args: [dateFormat.format(audit.date)]))
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
              data: audit.data.map<List<String>>((d) => [d.title.tr(), d.value, d.additional]).toList()
          )
        ]; // Center
      }));

  var rows0 = <pw.TableRow> [];
  var rows1 = <pw.TableRow> [];
  var rows2 = <pw.TableRow> [];

  try {
    await generateRows(rows0, audit, "audit_0", alert, warning, perfect, style, imagesFromNetwork);
    // rows0.add(pw.TableRow(children: [
    //   pw.Container(height: 50)
    // ]));
  } catch(e) {
    Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  try {
    await generateRows(rows1, audit, "audit_1", alert, warning, perfect, style, imagesFromNetwork);
    // rows1.add(pw.TableRow(children: [
    //   pw.Container(height: 50)
    // ]));
  } catch(e) {
    Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  try {
    await generateRows(rows2, audit, "audit_2", alert, warning, perfect, style, imagesFromNetwork);
  } catch(e) {
    Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  var wrapChildren = <pw.Widget> [];

  pdf.addPage(pw.MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context c) => [
        pw.Table(
            children: rows0
        )
      ],
      header: (c) => header,
      footer: (c) => footer
  ));
  pdf.addPage(pw.MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context c) => [
        pw.Table(
            children: rows1
        )
      ],
      header: (c) => header,
      footer: (c) => footer
  ));
  pdf.addPage(pw.MultiPage(
      maxPages: 100,
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context c) => [
        pw.Table(
            children: rows2
        )
      ],
      header: (c) => header,
      footer: (c) => footer
  ));

  if(wrapChildren.isNotEmpty) {
    var p = pw.MultiPage(
        maxPages: 100,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context c) => [
        ]
    );
    pdf.addPage(p);
  }



  final output = await getTemporaryDirectory();
  final file = File('${output.path}/example.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}

Future<void> generateRows(List<pw.TableRow> rows, ClientAudit audit, String auditName,
    String alert, String warning, String perfect, pw.TextStyle style, bool imagesFromNetwork, {bool addBottomMargin = true}) async {
  bool isAddAuditTitle = false;
  if(audit.auditQuestions[auditName] == null) return;

  for(var e in audit.auditQuestions[auditName]!.entries) {
    if(!isAddAuditTitle) {
      print(auditName.tr());
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
                        child: pw.Text(auditName.tr(), textAlign: pw.TextAlign.center)
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
                      child: pw.Text("${e.key}".tr(), textAlign: pw.TextAlign.center)
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
                            // -70
                              width: 100,
                              padding: pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(color: PdfColors.black),
                                  color: pdfBlueAccent.shade(.2)
                              ),
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("pdf_revision_point".tr(), textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal))
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
                                    pw.Text("pdf_rate".tr(), textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal))
                                  ]
                              )
                          ),
                          pw.Container(
                              width: 125,
                              padding: pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(color: PdfColors.black),
                                  color: pdfBlueAccent.shade(.2)
                              ),
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("pdf_revision_params".tr(), textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal))
                                  ]
                              )
                          ),
                          pw.Container(
                              width: 125,
                              padding: pw.EdgeInsets.all(5),
                              decoration: pw.BoxDecoration(
                                  border: pw.Border.all(color: PdfColors.black),
                                  color: pdfBlueAccent.shade(.2)
                              ),
                              child: pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("pdf_comment".tr(), textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal))
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
                                    pw.Text("pdf_photo".tr(), textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.normal))
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
            q.question.tr(),
            if(q.withRate)
              q.firstRate,
            if(q.withRate)
              q.secondRate,
            if(q.withSelector)
              q.rateParam.tr(),
            q.comment,
            ""
          ]],
          columnWidths: q.withRate && !q.withSelector ? {
            0: pw.FixedColumnWidth(100),
            1: pw.FixedColumnWidth(30),
            2: pw.FixedColumnWidth(30),
            3: pw.FixedColumnWidth(250),
            4: pw.FixedColumnWidth(150)
          } : !q.withRate && !q.withSelector ? {
            0: pw.FixedColumnWidth(160),
            1: pw.FixedColumnWidth(250),
            2: pw.FixedColumnWidth(150)
          } : {
            0: pw.FixedColumnWidth(100),
            1: pw.FixedColumnWidth(30),
            2: pw.FixedColumnWidth(30),
            3: pw.FixedColumnWidth(125),
            4: pw.FixedColumnWidth(125),
            5: pw.FixedColumnWidth(150)
          });

      if(q.withRate && q.firstRate.isNotEmpty) {
        String icon = "";
        var rate = q.firstRate;

        switch (rate) {
          case "1": {
            icon = perfect;
            break;
          }
          case "2": {
            icon = alert;
            break;
          }
          case "3": {
            icon = warning;
            break;
          }
        }
        t.children[1].children[0] = pw.Container(
            padding: pw.EdgeInsets.all(5),
            child: pw.Center(
                child: pw.Text(q.question.tr(), style: pw.TextStyle(fontSize: 12), textAlign: pw.TextAlign.center)
            )
        );
        t.children[1].children[1] = pw.Container(
            padding: pw.EdgeInsets.all(5),
            child: pw.Center(
                child: pw.Text(q.firstRate)
            )
        );
        t.children[1].children[3] = pw.Container(
            padding: pw.EdgeInsets.all(5),
            child: pw.Center(
                child: pw.Text(q.rateParam, style: pw.TextStyle(fontSize: 10))
            )
        );
        t.children[1].children[2] = pw.Container(
            padding: pw.EdgeInsets.all(5),
            child: pw.Center(
                child: pw.SvgImage(svg: icon, width: 15, height: 15)
            )
        );

        var photoColumnIndex = q.withRate && !q.withSelector ? 4 : (!q.withRate && !q.withSelector ? 3 : 5);
        var photoImages = <pw.Widget> [];
        pw.Image? photoImage;

        for(var src in (q.photosSrc ?? [])) {

          try {
            print("add photoImage from photosSrc with network $imagesFromNetwork => $src");
            if(imagesFromNetwork) {
              if(src.contains("https://firebasestorage.googleapis.com:")) {
                var response = await http.get(Uri.parse(src));
                var bytes = response.bodyBytes;
                final image = pw.MemoryImage(bytes);
                photoImage = pw.Image(image, height: 100, width: 125);
              } else {
                var src1 = await FirebaseStorage.instance.ref(src).getDownloadURL();
                var response = await http.get(Uri.parse(src1));
                var bytes = response.bodyBytes;
                final image = pw.MemoryImage(bytes);
                photoImage = pw.Image(image, height: 100, width: 125);
              }
            }
            else {
              final image = pw.MemoryImage(File(src).readAsBytesSync());
              photoImage = pw.Image(image, height: 100, width: 125);
            }
            photoImages.add(photoImage);
          } catch(e) {
            Fluttertoast.showToast(
                msg: "$e",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
            print("error ${q.question} => $e");
          }

        }

        if(photoImages.isNotEmpty) {
          t.children[1].children[photoColumnIndex] = pw.Column(
            children: photoImages
            // children: [
            //   pw.Center(
            //     child: photoImage
            //   )
            // ]
          );
          // t.children[1].children[photoColumnIndex] = pw.Container(
          //     child: pw.Center(
          //         child: photoImage
          //     )
          // );
        }
      }
      rows.add(pw.TableRow(children: [t]));
    }
  }
}