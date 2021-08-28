import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:valex_agro_audit_app/All.dart';
import 'package:share/share.dart';

class PdfFileViewPage extends StatefulWidget {
  final File pdf;
  final ClientAudit audit;
  PdfFileViewPage(this.pdf, this.audit);

  @override
  PdfFileViewPageState createState() => PdfFileViewPageState();
}

class PdfFileViewPageState extends State<PdfFileViewPage> {
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
          centerTitle: true,
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
            ),
            IconButton(
                icon: Icon(Icons.add_to_drive_outlined),
                onPressed:() async {
                  uploadFileToDrive(widget.pdf, widget.audit.user, widget.audit.address, widget.audit.date);
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

class PdfByteViewPage extends StatefulWidget {
  final Uint8List pdf;
  final ClientAudit audit;
  PdfByteViewPage(this.pdf, this.audit);

  @override
  PdfByteViewPageState createState() => PdfByteViewPageState();
}

class PdfByteViewPageState extends State<PdfByteViewPage> {
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
                centerTitle: true,
                brightness: Brightness.dark,
                backgroundColor: blueAccent,
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () async {
                        var f = File("");
                        f.writeAsBytes(widget.pdf);
                        Share.shareFiles([f.path], text: "audit");
                      }
                  ),
                  IconButton(
                      icon: Icon(Icons.add_to_drive_outlined),
                      onPressed:() async {
                        var f = File("");
                        f.writeAsBytes(widget.pdf);
                        uploadFileToDrive(f, widget.audit.user, widget.audit.address, widget.audit.date);
                      }
                  )
                ]
            ),
            body: Stack(
                children: <Widget>[
                  PDFView(
                    pdfData: widget.pdf,
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