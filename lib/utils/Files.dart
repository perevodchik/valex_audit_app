import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/analytics/v3.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/storage/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'Colors.dart';

Future<File?> selectImage({ImageSource source = ImageSource.camera, int quality = 80}) async {
  final f = await ImagePicker().getImage(
      source: source,
      imageQuality: quality,
      maxWidth: 1920,
      maxHeight: 1024
  );
  if(f == null) return null;
  return File(f.path);
}

Future<File?> saveFileInTmpDir(Uint8List file, String fileName) async {
  try {
    Directory appDir = await getApplicationDocumentsDirectory();
    var newFile = File("${appDir.path}/$fileName");

    await newFile.create(recursive: true);
    newFile = await newFile.writeAsBytes(file);

    // TODO comperss
    // print("pre compress ${file.lengthSync()}");
    // var result = (await FlutterImageCompress.compressAndGetFile(
    //     file.absolute.path, newFile.absolute.path,
    //     quality: 70
    // ))!;
    // print("post compress ${result.lengthSync()}");
    return newFile;
  } catch(e) {
    return null;
  }
}

Future<File?> loadFileFromTmpDir(String name) async {
  final appDir = await getTemporaryDirectory();
  var file = File("$appDir/$name");
  return file;
}

Future<void> uploadFileToDrive(File file, String user, String place, DateTime auditDate) async {
  final googleSignIn = GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
  GoogleSignInAccount? account = await googleSignIn.signIn();
  if(account == null) return;
  var date = DateFormat('HH:mm dd.MM.yyyy').format(auditDate);
  String fileName = "$user $place $date.pdf";
  final authHeaders = await account.authHeaders;
  print(authHeaders);
  final authenticateClient = GoogleAuthClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);
  var driveFile = new drive.File();
  driveFile.name = fileName;
  driveFile.parents = ["1NUP8icZyBWGwY57kNUAmjDUzIgswt53I"];
  final result = await driveApi.files.create(
      driveFile,
      uploadMedia: Media(file.openRead(), file.lengthSync())
  );
  print(result.toJson());
  Fluttertoast.showToast(
      msg: "upload_success".tr(),
      backgroundColor: blueDark,
      textColor: Colors.white,
      fontSize: 16,
      gravity: ToastGravity.CENTER
  );
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = new http.Client();
  GoogleAuthClient(this._headers);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}