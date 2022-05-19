import 'dart:io';
import 'dart:async';
import 'package:futgolazo/src/env/env.model.dart';
import 'package:futgolazo/src/services/pool_services.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:archive/archive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LoadAssetsService {
  String _dir;
  List<String> _images, _tempImages;
  String _localZipFileName = 'images.zip';
  String _zipPath = 'http://coderzheaven.com/youtube_flutter/images.zip';

  final EnvModel env =
      GetIt.I<PoolServices>().environment.environment;

  void init() {
    _images = List();
    _tempImages = List();
    _initDir();
  }

  // Initialize the directory to get the Device's Documents directory //
  _initDir() async {
    if (null == _dir) {
      _dir = (await getApplicationDocumentsDirectory()).path;
    }
  }

  Future<void> downloadZip() async {
    _images.clear();
    _tempImages.clear();

    var zippedFile = await _downloadFile(_zipPath, _localZipFileName);
    await unarchiveAndSave(zippedFile);

    _images.addAll(_tempImages);
  }

  // Download the ZIP file using the HTTP library //
  Future<File> _downloadFile(String url, String fileName) async {
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$_dir/$fileName');
    return file.writeAsBytes(req.bodyBytes);
  }

  // Unarchive and save the file in Documents directory and save the paths in the array
  unarchiveAndSave(var zippedFile) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$_dir/${file.name}';
      if (file.isFile) {
        var outFile = File(fileName);
        print('File:: ' + outFile.path);
        _tempImages.add(outFile.path);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
        DefaultCacheManager().putFile(fileName, outFile.readAsBytesSync());
      }
    }
  }

  void testLoadingImage() {
    String img1 =
        "${env.imagePath}trivia_app/soccer_fields/field/Cancha_estadio_1.jpg";
    String img2 =
        "${env.imagePath}trivia_app/soccer_fields/field/Cancha_estadio_2.jpg";

    String img3 =
        "${env.imagePath}trivia_app/soccer_fields/field/Cancha_estadio_3.jpg";

    var stream1 = loadingImageTest(img1);
    var stream2 = loadingImageTest(img2);
    var stream3 = loadingImageTest(img3);

    ForkJoinStream.list<FileResponse>([stream1, stream2, stream3])
        .listen((event) {
      print('Termino');
    });
  }

  Stream<FileInfo> loadingImageTest(imageString) {
    FileInfo _fromMemory;
    _fromMemory = DefaultCacheManager().getFileFromMemory(imageString);

    if (_fromMemory != null) {
      return Stream.value(_fromMemory);
    } else {
      return DefaultCacheManager()
          .getFileStream(
            imageString,
            withProgress: true,
          )
          .map((r) => r as FileInfo);
    }
  }
}
