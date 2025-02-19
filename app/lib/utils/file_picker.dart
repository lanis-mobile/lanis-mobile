import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:sph_plan/utils/file_operations.dart';
import 'package:sph_plan/utils/random.dart';

import '../generated/l10n.dart';

class PickedFile {
  String name;

  /// The size in bytes (is 0 if something went wrong)
  num? size;

  String? path;

  String get extension => name.split('.').last;

  /// May be null if no mimeType was found
  String? get mimeType => lookupMimeType(path!);

  MediaType? get mediaType => MediaType.parse(mimeType!);

  PickedFile({required this.name, this.size, this.path});
}

extension Actions on PickedFile {
  Future<MultipartFile> intoMultipart() async {
    return await MultipartFile.fromFile(
      path!,
      filename: name,
      contentType: mediaType,
    );
  }
}

const storageChannel = MethodChannel('io.github.lanis-mobile/storage');

/// Allows the user to pick any file using any supported method
Future<PickedFile?> pickSingleFile(
    BuildContext context, List<String>? allowedExtensions) async {
  List<bool> allowedMethods = [true, true, true, true];
  return showPickerUI(context, allowedMethods, allowedExtensions);
}

/// Allowed Methods (Position in [List<bool>]):
/// ```
/// 0 = File Manager
/// 1 = Scan Document (Requires API >= 26)
/// 2 = Camera
/// 3 = Gallery (iOS Only)
/// ```
Future<PickedFile?> showPickerUI(BuildContext context,
    List<bool> allowedMethods, List<String>? allowedExtensions) async {
  bool documentScannerSupported = true;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  if (androidInfo.version.sdkInt < 26) {
    documentScannerSupported = false;
  }

  PickedFile? pickedFile;
  if (context.mounted) {
    await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        builder: (context) {
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (allowedMethods[0])
                      (MenuItemButton(
                        onPressed: () async {
                          pickedFile =
                              await pickFileUsingDocumentsUI(allowedExtensions);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10.0)),
                            Icon(Icons.file_open_rounded),
                            Padding(padding: EdgeInsets.only(right: 8.0)),
                            Text(AppLocalizations.of(context).fileManager)
                          ],
                        ),
                      )),
                    if (allowedMethods[1] && documentScannerSupported)
                      (MenuItemButton(
                        onPressed: () async {
                          pickedFile =
                              await pickFileUsingDocumentScanner(context);
                        },
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10.0)),
                            Icon(Icons.document_scanner_rounded),
                            Padding(padding: EdgeInsets.only(right: 8.0)),
                            Text(AppLocalizations.of(context).documentScanner)
                          ],
                        ),
                      )),
                    if (allowedMethods[2])
                      (MenuItemButton(
                        onPressed: () async {
                          pickedFile = await pickFileUsingCamera();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10.0)),
                            Icon(Icons.camera_alt_rounded),
                            Padding(padding: EdgeInsets.only(right: 8.0)),
                            Text(AppLocalizations.of(context).camera)
                          ],
                        ),
                      )),
                    if (allowedMethods[3] && Platform.isIOS)
                      ( // DocumentsUI supports galleries and the photo picker is horrible (from a user perspective)
                          MenuItemButton(
                        onPressed: () async {
                          pickedFile = await pickFileUsingGallery();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10.0)),
                            Icon(Icons.photo_library_rounded),
                            Padding(padding: EdgeInsets.only(right: 8.0)),
                            Text(AppLocalizations.of(context).gallery)
                          ],
                        ),
                      ))
                  ],
                ),
              ),
            ),
          );
        });
  }
  return pickedFile;
}

Future<PickedFile?> pickFileUsingDocumentsUI(
    List<String>? allowedExtensions) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
  );

  if (result == null) {
    return null;
  } else {
    final PlatformFile firstFile = result.files.first;

    final PickedFile pickedFile = PickedFile(
        name: firstFile.name, path: firstFile.path, size: firstFile.size);
    return pickedFile;
  }
}

// TODO: Add iOS support
Future<PickedFile?> pickFileUsingDocumentScanner(BuildContext context) async {
  List<String> paths = List.empty(growable: true);
  bool breakLoop = false;

  while (true) {
    String? path = await storageChannel.invokeMethod("scanDocument");
    if (path == null) {
      return null;
    }

    final newPath = "$path-${getRandomString(32)}";
    await moveFile(path, newPath);
    paths.add(newPath);

    if (context.mounted) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).morePages),
              content:
                  Text(AppLocalizations.of(context).scanAnotherPageQuestion),
              actions: <Widget>[
                ElevatedButton(
                    onPressed: () {
                      breakLoop = true;
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).no)),
                FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppLocalizations.of(context).yes))
              ],
            );
          });
      if (breakLoop) {
        break;
      }
    }
  }
  List<String>? newPaths;
  if (context.mounted) {
    newPaths = await imageCycler(context, paths);
  }

  if (newPaths == null) {
    return null;
  }

  return null;
}

Future<PickedFile?> pickFileUsingCamera() async {
  return null;
}

/// This will return null if called on anything other than iOS
Future<PickedFile?> pickFileUsingGallery() async {
  if (Platform.isIOS) {
    return null;
  } else {
    return null;
  }
}

Future<List<String>?> imageCycler(
    BuildContext context, List<String> paths) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ImageCyclerScreen(initialPaths: paths),
    ),
  );
}

class ImageCyclerScreen extends StatefulWidget {
  final List<String> initialPaths;

  const ImageCyclerScreen({super.key, required this.initialPaths});

  @override
  ImageCyclerScreenState createState() => ImageCyclerScreenState();
}

class ImageCyclerScreenState extends State<ImageCyclerScreen> {
  late List<String> paths;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    paths = List.from(widget.initialPaths);
  }

  void removeImage(int index) {
    setState(() {
      paths.removeAt(index);
      if (currentIndex >= paths.length) {
        currentIndex = paths.length - 1;
      }
      if (paths.isEmpty) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check_rounded),
            onPressed: () {
              Navigator.of(context).pop();
            },
            tooltip: AppLocalizations.of(context).confirm,
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            children: [
              if (paths.isNotEmpty)
                (SizedBox(
                  child: Image.file(File(paths[currentIndex])),
                )),
              Expanded(child: SizedBox()), // I know that this code looks stupid but i couldn't find another way
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          child: currentIndex > 0 ? IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(Icons.arrow_left_rounded, size: 48.0),
                            onPressed: () {
                              setState(() {
                                currentIndex = currentIndex - 1;
                              });
                            },
                          ) : SizedBox(width: 48.0)
                      ),
                      Flexible(
                          child: IconButton(
                            padding: EdgeInsets.all(0.0),
                            icon: Icon(Icons.delete_forever_rounded, size: 32.0,),
                            onPressed: () => removeImage(currentIndex),
                          ),
                      ),
                      Flexible(
                        child: currentIndex < paths.length - 1 ? IconButton(
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(Icons.arrow_right_rounded, size: 48.0),
                          onPressed: () {
                            setState(() {
                              currentIndex = currentIndex + 1;
                            });
                          },
                        ) : SizedBox(width: 48.0),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
