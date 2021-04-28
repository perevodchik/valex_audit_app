import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:share/share.dart';

class PdfViewPage extends StatefulWidget {
  final File pdf;
  PdfViewPage(this.pdf);

  @override
  PdfViewPageState createState() => PdfViewPageState();
}

class PdfViewPageState extends State<PdfViewPage> {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(
          title: Text("Document"),
          brightness: Brightness.dark,
          backgroundColor: blueAccent,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                Share.shareFiles([widget.pdf.path],
                text: "audit");
              }
            )
          ]
        ),
        body: Stack(
          children: <Widget>[
            PDFView(
              filePath: widget.pdf.path,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage!,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation:
              false,
              onRender: (_pages) {
                setState(() {
                  pages = _pages;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                print(error.toString());
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String? uri) {
                print('goto uri: $uri');
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              },
            ),
            errorMessage.isEmpty
                ? !isReady
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Container()
                : Center(
              child: Text(errorMessage),
            )
          ]
        )
      )
    );
  }
}