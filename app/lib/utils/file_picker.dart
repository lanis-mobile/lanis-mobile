import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
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

/// Allows the user to pick any file using either the file picker, image picker or the camera by making a photo / video
Future<PickedFile?> pickSingleFile(BuildContext context, List<String>? allowedExtensions) async {
  if (Platform.isIOS) {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    final PlatformFile firstFile = result!.files.first;

    final PickedFile pickedFile = PickedFile(name: firstFile.name, path: firstFile.path, size: firstFile.size);
    return pickedFile;
  } else {
    const platform = MethodChannel('io.github.lanis-mobile/storage');
    int i = -1;
    FilePickerModalScreen(
        allowedMethods: [true, true, true].toList(),
        onValueSelect: (int value) {
          i = value;
        }
    );
  }
  return null;
}

class FilePickerModalScreen extends StatefulWidget {
  final List<bool> allowedMethods;
  final Function(int) onValueSelect;

  const FilePickerModalScreen({super.key, required this.allowedMethods, required this.onValueSelect});

  @override
  FilePickerModal createState() => FilePickerModal();
}

class FilePickerModal extends State<FilePickerModalScreen> {
  void selectValue(int i) {
    widget.onValueSelect(i);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      showModalBottomSheet<void>(
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
                      MenuItemButton(
                        onPressed: () => {

                        },
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10.0)),
                            Icon(Icons.camera_alt_rounded),
                            Padding(padding: EdgeInsets.only(right: 8.0)),
                            Text(AppLocalizations.of(context).camera)
                          ],
                        ),
                      ),
                      MenuItemButton(
                        onPressed: () => {

                        },
                        child: Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10.0)),
                            Icon(Icons.photo_library_rounded),
                            Padding(padding: EdgeInsets.only(right: 8.0)),
                            Text(AppLocalizations.of(context).gallery)
                          ],
                        ),
                      ),
                      MenuItemButton(
                        onPressed: () => {

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
                    ],
                  ),
                ),
              ),
            );
          }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column();
  }

}

Future<PickedFile?> pickFileUsingCamera() async {
  return null;
}

Future<PickedFile?> pickFileUsingGallery() async {
  return null;
}
