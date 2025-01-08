import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../../core/sph/sph.dart';
import '../../../../models/lessons_teacher.dart';

class UploadFileToCourseChip extends StatelessWidget {
  final void Function(List<CourseFolderHistoryEntryFile> newFile)? onFileUploaded;
  final String courseId;
  final String entryId;
  const UploadFileToCourseChip({super.key, required this.courseId, required this.entryId, this.onFileUploaded});

  void uploadFile(BuildContext context) async {
    FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withReadStream: true
    );
    if (pickerResult == null) return;
    if (pickerResult.files.isEmpty) return;

    ValueNotifier<double> progressNotifier = ValueNotifier<double>(0.0);
    ValueNotifier<String> fileNameNotifier = ValueNotifier<String>('');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Uploading..."),
          content: ValueListenableBuilder(
            valueListenable: fileNameNotifier,
            builder: (context, fileName, _) => ValueListenableBuilder<double>(
              valueListenable: progressNotifier,
              builder: (context, value, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    LinearProgressIndicator(value: value),
                    const SizedBox(height: 20),
                    Text("${(value * 100).toStringAsFixed(0)}%"),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    List<MultipartFile> multiPartFiles = [];
    for (PlatformFile file in pickerResult.files) {
      multiPartFiles.add(MultipartFile.fromStream(
            () => file.readStream!,
        file.size,
        filename: file.name,
        contentType: MediaType.parse(lookupMimeType(file.path!) ?? 'application/octet-stream'),
      ));
    }
    List<FormData> formData = multiPartFiles.map((e) => FormData.fromMap({
      'a': 'uploadFileBook',
      'id': courseId,
      'entry': entryId,
      'file': e,
    })).toList();
    List<CourseFolderHistoryEntryFile> resultFiles = [];
    try {
      for (final (index, data) in formData.indexed) {
        fileNameNotifier.value = multiPartFiles[index].filename??'';
        final response = await sph!.session.dio.post(
          'https://start.schulportal.hessen.de/meinunterricht.php',
          data: data,
          options: Options(headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data;",
            "Sec-Fetch-Dest": "document",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-Site": "same-origin",
          }),
          onSendProgress: (int sent, int total) {
            progressNotifier.value = sent / total;
          },
        );
        final responseData = jsonDecode(response.data);
        if (responseData['error'] != 0) return;

        resultFiles.add(
          CourseFolderHistoryEntryFile(
            name: responseData['filename'],
            extension: responseData['extension'],
            entryId: entryId,
            isVisibleForStudents: true,
            url: Uri.parse('https://start.schulportal.hessen.de/meinunterricht.php?a=downloadFile&id=$courseId&e=$entryId&f=${responseData['filename']}'),
          )
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Unbekannter Fehler beim Hochladen'),
        backgroundColor: Colors.red,
      ));
    } finally {
      Navigator.of(context).pop();
    }

    if (onFileUploaded != null) {
      onFileUploaded!(resultFiles);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.upload_rounded, size: 16),
          const SizedBox(width: 4.0),
          const Text('Datei hinzufügen'),
        ],
      ),
      onPressed: () => uploadFile(context),
    );
  }
}