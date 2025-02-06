import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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
Future<PickedFile?> pickSingleFile(BuildContext context, List<String>? allowedExtensions) async {
  if (Platform.isIOS) {
    return pickFileUsingDocumentsUI(allowedExtensions);
  } else {
    List<bool> allowedMethods = [true, true, true, true];
    return showPickerUI(context, allowedMethods, allowedExtensions);
  }
}

/// Allowed Methods (Position in [List<bool>]):
/// ```
/// 0 = DocumentsUI (File Picker)
/// 1 = Scan Document
/// 2 = Camera
/// 3 = Gallery
/// ```
Future<PickedFile?> showPickerUI(BuildContext context, List<bool> allowedMethods, List<String>? allowedExtensions) async {
  PickedFile? pickedFile;
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
                  if (allowedMethods[0]) (
                    MenuItemButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        pickedFile = await pickFileUsingDocumentsUI(allowedExtensions);
                      },
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Icon(Icons.file_open_rounded),
                          Padding(padding: EdgeInsets.only(right: 8.0)),
                          Text(AppLocalizations.of(context).fileManager)
                        ],
                      ),
                    )
                  ),
                  if (allowedMethods[1]) (
                    MenuItemButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        pickedFile = await pickFileUsingDocumentScanner();
                      },
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Icon(Icons.document_scanner_rounded),
                          Padding(padding: EdgeInsets.only(right: 8.0)),
                          Text(AppLocalizations.of(context).documentScanner)
                        ],
                      ),
                    )
                  ),
                  if (allowedMethods[2]) (
                    MenuItemButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        pickedFile = await pickFileUsingCamera();
                      },
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Icon(Icons.camera_alt_rounded),
                          Padding(padding: EdgeInsets.only(right: 8.0)),
                          Text(AppLocalizations.of(context).camera)
                        ],
                      ),
                    )
                  ),
                  if (allowedMethods[3]) (
                    MenuItemButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        pickedFile = await pickFileUsingGallery();
                      },
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.only(left: 10.0)),
                          Icon(Icons.photo_library_rounded),
                          Padding(padding: EdgeInsets.only(right: 8.0)),
                          Text(AppLocalizations.of(context).gallery)
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
          ),
        );
      }
  );
  return pickedFile;
}

Future<PickedFile?> pickFileUsingDocumentsUI(List<String>? allowedExtensions) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: allowedExtensions,
  );

  if (result == null) {
    return null;
  } else {
    final PlatformFile firstFile = result.files.first;

    final PickedFile pickedFile = PickedFile(name: firstFile.name, path: firstFile.path, size: firstFile.size);
    return pickedFile;
  }
}

Future<PickedFile?> pickFileUsingDocumentScanner() async {
  return null;
}

Future<PickedFile?> pickFileUsingCamera() async {
  return null;
}

Future<PickedFile?> pickFileUsingGallery() async {
  return null;
}

