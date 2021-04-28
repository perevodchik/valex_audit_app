import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> selectImage({ImageSource source = ImageSource.camera, int quality = 80}) async {
  final f = await ImagePicker().getImage(source: source, imageQuality: quality);
  if(f == null) return null;
  return File(f.path);
}

Future<File?> saveFileInTmpDir(File file, String fileName) async {
  try {
    Directory appDir = await getApplicationDocumentsDirectory();
    var newFile = File("${appDir.path}/$fileName");
    await newFile.create(recursive: true);
    newFile = await newFile.writeAsBytes(await file.readAsBytes());
    return newFile;
  } catch(e) {
    return null;
  }
}

Future<File?> loadFileFromTmpDir(String name) async {
  final appDir = await getTemporaryDirectory();
  var file = File("$appDir/$name");
  print("$appDir/$name exist? ${file.exists()}");
  return file;
}